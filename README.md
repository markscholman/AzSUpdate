# AzSUpdate
Tools to interact with Azure Stack Patch and Update (PnU)

This repo contains 2 parts that makes the puzzle. 

First you need to setup an Twilio account and publish the Azure Function into you public Azure Subscription. Update the SendMessage.cs file with the settings from your Twilio account. Technicaly if you have a connected Azure Stack environment with AppService installed, hosting it in there should work to. 

The second part is a PowerShell module that you need to load onto the HLH server or your admin workstation that is able to reach the privileged endpoints in the Azure Stack stamp.

Then you run from your admin workstation or HLH the script with the updated variables:
```PowerShell
#region Variables
$mobilePhone = '+15552293334'
$pepServer = '10.1.52.224'
$pepCred = New-Object pscredential("AZURESTACK\cloudadmin",(ConvertTo-SecureString -AsPlainText -Force "<PASSWORD>"))
$functionUri = '<FUNCTION-URI>.azurewebsites.net'
$functionCode = '<FUNCTION KEY (Auth level is function - is key behind ?code in URI)>'
#endregion

#region Monitor AzS Update
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $pepServer -Force
$MonitoringParams =@{
    pepServer = $pepServer
    pepCred =$pepCred
    mobilePhone = $mobilePhone
    functionURI = $functionUri
    functionCode = $functionCode
}
Monitor-AzSUpdate @MonitoringParams
#endregion
```
