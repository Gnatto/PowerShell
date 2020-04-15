$servers = Get-Content -Path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\TestServer.txt"
$noConnections = Get-Content -Path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\TestStatus\NoConnection.txt"
$connections = Get-Content -Path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\TestStatus\Connection.txt"
$countofnoConnections = Get-Content -Path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\TestStatus\NoConnection.txt" | Measure-Object -Line | Select-Object Lines
$countofConnections = Get-Content -Path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\TestStatus\Connection.txt" | Measure-Object -Line | Select-Object Lines
$noconnectionPath = "C:\Users\con-nkaro.HQNET\Desktop\Powershell\TestStatus\NoConnection.txt"
$connectionPath = "C:\Users\con-nkaro.HQNET\Desktop\Powershell\TestStatus\Connection.txt"
#$Server = "quseawindweb01.hqnet.longandfoster.com"
ForEach($server in $servers)
{
    IF(-not(Test-Connection $server -Quiet -ErrorAction SilentlyContinue))
    {
        Write-Host "$server Added to noconnectArray"
        IF($noConnections -contains $server -eq $false)
        {
            Add-Content $server -Path $noConnectionPath
        }
        ELSE
        {
          Write-Host "Server is already in noconnection text file"
        }
    }
}
IF($countofnoConnections.Lines -ne 0)
{
    ForEach($noConnection in $noConnections)
    {
        IF((Test-Connection $noConnection -Quiet -ErrorAction SilentlyContinue) -eq $true)
        {
            IF($connections -contains $noConnection -eq $false)
            {
                Add-Content $noConnection -Path $connectionPath
                $noConnections | ForEach-Object {$_ -replace $noConnection,""} | Out-File $noConnectionPath
            }
        }
        ELSEIF(-not(Test-Connection $noConnection -Quiet -ErrorAction SilentlyContinue))
        {
            sendEmailDown
        }
    }
}
IF($countofConnections.Lines -ne 0)
{
    ForEach($connection in $connections)
    {
      sendEmailUp
      $connections | ForEach-Object {$_ -replace $connection,""} | Out-File $connectionPath
    }
}

Function sendEmailDown
{
    $SMTPServer = "smtp.office365.com"
    $SMTPPort = "587"
    $MailFrom = "AppUser3@Longandfoster.com"
    $MailTo = "Nat@Longandfoster.com"
    $MailSubject = "$noConnection is down"
    $MailBody = "$noConnection is not responding to (PING)"
    $MailCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "Appuser3@Longandfoster.com",(Get-Content -Path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\EncryptTest.txt" | ConvertTo-SecureString)
    Send-MailMessage -From $MailFrom -To $MailTo -Subject $MailSubject -Body $MailBody -smtpserver $SMTPServer -useSSL -Credential $MailCred -Port $SMTPPort
}
Function sendEmailUp
{
    $SMTPServer = "smtp.office365.com"
    $SMTPPort = "587"
    $MailFrom = "AppUser3@Longandfoster.com"
    $MailTo = "Nat@Longandfoster.com"
    $MailSubject = "$connection is up"
    $MailBody = "$connection is now up."
    $MailCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "Appuser3@Longandfoster.com",(Get-Content -Path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\EncryptTest.txt" | ConvertTo-SecureString)
    Send-MailMessage -From $MailFrom -To $MailTo -Subject $MailSubject -Body $MailBody -smtpserver $SMTPServer -useSSL -Credential $MailCred -Port $SMTPPort
}



