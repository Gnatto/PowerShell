#Ask for credentials to access event logs for remote server.
$Cred = Get-Credential -Message "Please enter admin credential to log into server[Example:HQNET\Username]"
#Log user wants to search
$LogName = [Please Enter LogName here]
#Script will ask user to enter a server to search for log
$Server = Read-Host "Enter a server name you want to search event logs"
#Searches the list of logs in Microsoft-AadApplicatrionProxy-Connector
Get-WinEvent -ComputerName $Server -Credential $Cred -LogName $LogName | 
Where-Object LevelDisplayName -eq "Error" | 
Select-Object -First 5