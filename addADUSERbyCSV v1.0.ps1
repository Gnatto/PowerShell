$csv = Import-CSV -Path C:\Users.csv
$password = ConvertTo-SecureString -String "Ch@ng3me!" -Asplaintext -Force
foreach($user in $csv)
{
  $username = $user.Username
  $firstname = $user.FirstName
  $lastname = $user.LastName
  $description = $user.Description

  New-ADUser -SamAccountName $username -AccountPassword $password -Name "$firstname $lastname" -DisplayName "$firstname $lastname" -GivenName "$firstname" -Surname "$lastname" -Description "$description" -Path "OU=testgroup,DC=ADDEV,DC=local"
   Set-ADUser -Identity "$username" -ChangePasswordAtLogon $True -UserPrincipalName "$username@ADDEV.local" -Enabled $True
}
