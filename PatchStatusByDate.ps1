#Get-Content for 2008
$computers = Get-Content "C:\Users\con-nkaro.HQNET\Desktop\Powershell\2008server_bydate.txt" 
foreach ($computer in $computers)    
{    
  if (get-hotfix -computername $computer -ErrorAction SilentlyContinue | WHERE {$_.InstalledOn -gt "11/1/2019"})    
  {    
   Add-content "Present, $computer" -path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\PatchStatus\2008bydatePATCHED_OK_DEC2019.log"   
  }  
  Else    
  {    
   Add-content "Missing, $computer" -path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\PatchStatus\2008bydatePATCHED_MISSING_DEC2019.log"     

  }   
} 

#Get Content for 2012
$computers = Get-Content "C:\Users\con-nkaro.HQNET\Desktop\Powershell\2012server_list_2019.txt" 
foreach ($computer in $computers)    
{    
  if (get-hotfix -computername $computer -ErrorAction SilentlyContinue | WHERE {$_.InstalledOn -gt "11/1/2019"})    
  {    
   Add-content "Present, $computer" -path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\PatchStatus\2012PATCHED_OK_DEC2019.log"   
  }  
  Else    
  {    
   Add-content "Missing, $computer" -path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\PatchStatus\2012PATCHED_MISSING_DEC2019.log"     

  }   
} 

#Get Content for 2016
$computers = Get-Content "C:\Users\con-nkaro.HQNET\Desktop\Powershell\2016server_list_2019.txt" 
foreach ($computer in $computers)    
{    
  if (get-hotfix -computername $computer -ErrorAction SilentlyContinue | WHERE {$_.InstalledOn -gt "11/1/2019"})    
  {    
   Add-content "Present, $computer" -path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\PatchStatus\2016PATCHED_OK_DEC2019.log"   
  }  
  Else    
  {    
   Add-content "Missing, $computer" -path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\PatchStatus\2016PATCHED_MISSING_DEC2019.log"     

  }   
} 

