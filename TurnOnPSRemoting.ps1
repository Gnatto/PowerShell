$Path = "C:\SplunkDeploy\splunkinstall.txt"
IF(Test-Path $Path)
{
    $servers = get-content "C:\SplunkDeploy\splunkinstall.txt"
    foreach($server in $servers)
    {
     Write-Host "Turning on PSRemoting on $server" 
     psexec.exe -s \\xweb2 powershell.exe Enable-PSRemoting -Force 
    }
}
ELSE
{
 Write-Host "Splunk install file is missing" 
}


