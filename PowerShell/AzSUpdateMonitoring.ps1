#region Variables
$mobilePhone = '+15552293334'
$pepServer = '10.1.52.224'
$pepCred = New-Object pscredential("AZURESTACK\cloudadmin",(ConvertTo-SecureString -AsPlainText -Force "<PASSWORD>"))
$functionUri = '<FUNCTION-URI>.azurewebsites.net'
$functionCode = '<FUNCTION KEY (Auth level is function - is key behind ?code= in URI)>'
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