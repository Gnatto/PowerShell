DO
{
  try
  {
   $answer = Read-Host "Please enter an IP address"
   [ipaddress]$IP = $answer
   Write-Host "You entered $answer as the IP address"
  }
  catch
  {
   Write-Host "$answer is not a valid IP address"
  }
  finally
  {
   $ans = Read-Host "(Y/N) Would you like to enter another IP address?"
  }
}WHILE($ans -eq 'Y')
