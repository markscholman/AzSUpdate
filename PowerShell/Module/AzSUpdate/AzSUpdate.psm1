function Monitor-AzSUpdate {
    [cmdletbinding()]
    param(
        [IPAddress]
        $pepServer,
        [PSCredential]
        $pepCred,
        [string]
        $mobilePhone,
        [string]
        $functionURI,
        [string]
        $functionCode
    )
    
    BEGIN{
        $pepSession = New-PSSession -ComputerName $pepServer -Credential $pepCred -ConfigurationName PrivilegedEndpoint
    }

    PROCESS{
        #region Check if Update Module is present
        $commands = Invoke-Command -Session $pepSession -ScriptBlock { Get-Command }
        $updateManagementModuleName = "Microsoft.Azurestack.UpdateManagement"
        if (($commands | ? Source -eq $updateManagementModuleName)) {
            Write-Output "Privileged endpoint was updated to support update monitoring tools."
        } else {
            Write-Output "Privileged endpoint has not been updated yet. Please try again later."
        }
        #$commands | ? Source -eq $updateManagementModuleName
        #endregion

        #region Check and send PnU status
        if (($commands | ? Source -eq $updateManagementModuleName)) {
            while($true) {
                if ($pepSession.State -eq 'Opened' ) {
                    $statusString = Invoke-Command -Session $pepSession -ScriptBlock { Get-AzureStackUpdateStatus -StatusOnly }
                    $status = $statusString.Value
                    Write-Output "Azure Stack update is: $status."
                    if ($status -eq 'Running') {
                        Write-Output "Sleeping 30 seconds before checking again..."
                        Start-Sleep -Seconds 30
                    } else {
                        #Send status to twilio function
                        Invoke-RestMethod -Method Get -Uri "http://$functionURI/api/SendMessage/$mobilePhone`:$status`?code=$functionCode"
                        break;
                    }
                } else {
                    try {
                        if (Test-Connection $pepServer -Quiet -Count 1) {
                            Write-Output "Trying to setup a new pssesion to the ERCS VM..."
                            $pepSession = New-PSSession -ComputerName $pepServer -Credential $pepCred -ConfigurationName PrivilegedEndpoint
                        } else {
                            Write-Output 'ERCS VM is not online, being rebooted or is updated, will try again in 30 seconds'
                            Start-Sleep -Seconds 30
                        }
                    } catch {
                        Write-Error $Error[0]
                        if ($pepSession) {
                            Get-PSSession $pepServer | Remove-PSSession 
                        }
                        $pepSession = $null
                        #break;
                    }
                }
            }
        } else {
            Write-Output "Make sure PnU package 1710 was installed before using this cmdlet. AzS PowerShell modules where not available in the 1709 GA build"
        }
        #endregion
    }

    END{ 
        Remove-PSSession -Session $pepSession -Confirm:$false
    }
}

Export-ModuleMember Monitor-AzSUpdate
