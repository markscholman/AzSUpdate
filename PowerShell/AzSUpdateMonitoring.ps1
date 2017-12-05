#region Variables
$pepServer = '10.1.52.224'
$pepCred = New-Object pscredential("AZURESTACK\cloudadmin",(ConvertTo-SecureString -AsPlainText -Force "<PASSWORD>"))
$functionUri = '<FUNCTION-URI>.azurewebsites.net'
$functionCode = '<FUNCTION KEY (Auth level is function - is key behind ?code in URI)>'
#endregion

#region Monitor AzS Update
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $pepServer -Force
$MonitoringParams =@{
    pepServer =10.1.52.224
    pepCred =$pepCred
    mobilePhone = +15552293334
    functionURI = $functionUri
    functionCode = $functionCode
}
Monitor-AzSUpdate @MonitoringParams
#endregion