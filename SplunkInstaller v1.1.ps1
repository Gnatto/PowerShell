IF(Test-Path -path "C:\SplunkDeploy\splunkinstall.txt")
{
  Write-Host "Content for servers retrieved from serverlist"
  $servers = get-content "C:\SplunkDeploy\splunkinstall.txt"
  Foreach($server in $servers)
  {
    $node = 0
    $path = "\\$server\c$\Program Files\SplunkUniversalForwarder"
    IF((Test-Path -path $path))
    {
      Write-Host "Splunk is already installed on $server"
    }
    ELSE
    {
     Write-Host "Splunk is not on $server. Installing Splunk."
     New-Item -Path "\\$server\c$\" -Name "splunktemp" -ItemType "directory"
     Copy-Item -Path "C:\SplunkDeploy\splunkforwarder-7.3.2-c60db69f8e32-x64-release.msi" -Destination "\\$server\c$\splunktemp"
     Invoke-Command -ComputerName $server -ScriptBlock {
         cmd.exe /c msiexec.exe /i C:\splunktemp\splunkforwarder-7.3.2-c60db69f8e32-x64-release.msi AGREETOLICENSE=yes LAUNCHSPLUNK=1 SERVICESTARTTYPE=auto /quiet
      }
      WHILE($node -eq 0)
         {
           IF(Get-Service -ComputerName $server -Name "SplunkForwarder Service")
           {
            Write-Host "SplunkForwarder Service Detected. Stopping Service."
              Invoke-Command -ComputerName $server -ScriptBlock {
                Stop-Service "SplunkForwarder Service"
              }
            $node = 1
           }
           ELSE
           {
            Write-Host "SplunkForwarder Service Not Detected. Checking..."
           }
         }
      Remove-Item -Path \\$server\c$\splunktemp -Recurse
      Copy-Item -Path "C:\SplunkDeploy\Transfer\100_homeservices_splunkcloud" -Destination "\\$server\c$\Program Files\SplunkUniversalForwarder\etc\apps\" -Recurse
      Copy-Item -Path "C:\SplunkDeploy\Transfer\LGRF_Inputs_windows" -Destination "\\$server\c$\Program Files\SplunkUniversalForwarder\etc\apps\" -Recurse
      IF(Get-Service -ComputerName $server -Name "SplunkForwarder Service" | WHERE {$_.Status -eq "Stopped"})
      {
         Invoke-Command -ComputerName $server -ScriptBlock {
               Start-Service "SplunkForwarder Service"
             }
      }
      ELSE
      {
       Write-Host "ERROR: SplunkForwarder Service was already running. Check $server"
      }
    } 
  }
}
ELSE
{
    Write-Host "Unable to get information from server list text file"   
}
















