$computers = get-content "C:\Users\con-nkaro.HQNET\Desktop\Powershell\server_list_test.txt"
$computers | foreach {
$computername = $_
[ADSI]$S = "WinNT://$computername"
$S.children.where({$_.class -eq 'group'}) |
Select @{Name="Computername";Expression={$_.Parent.split("/")[-1] }},
@{Name="Name";Expression={$_.name.value}},
@{Name="Members";Expression={
[ADSI]$group = "$($_.Parent)/$($_.Name),group"
$members = $Group.psbase.Invoke("Members")
($members | ForEach-Object {
$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
})
}}
} | Export-CSV -path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\ServerAudit\TestAudit.csv" -notypeinformation 

$csv = Import-CSV -Path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\ServerAudit\TestAudit.csv" 

$csv | Where-Object { $_.Members -eq 'Administrator Domain Admins OPSADMIN appuser3 S-1-5-21-2019431095-136578513-1854500012-16390 excelerate con-salva S-1-5-21-2019431095-136578513-1854500012-17105 QAUser con-apand con-varif S-1-5-21-2019431095-136578513-1854500012-18489 S-1-5-21-2019431095-136578513-1854500012-18797 con-yshak appsServer con-rsoni con-sbhik S-1-5-21-2019431095-136578513-1854500012-22343 Gil' } | Export-CSV -Path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\ServerAudit\FilteredAudit.csv"

#$csv | Export-CSV -Path "C:\Users\con-nkaro.HQNET\Desktop\Powershell\ServerAudit\FilteredAudit.csv"