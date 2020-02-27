#LAB 1
$ExcelPath = 'C:\Powershell\ExcelTest\HSOA MONTHLY.xlsx'
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $true
$workbook = $excel.Workbooks.Open($ExcelPath)

$workbook.ActiveSheet.Cells.Item(3,7) = '200'


#LAB 2
$inFile = Import-Csv C:\Powershell\ExcelTest\Test1.csv
$targetCell = $inFile.username[1]
Write-Output $targetCell


#LAB 3
$test = Import-CSV -Path 'C:\Powershell\ExcelTest\Test1.csv' | 
       ForEach-Object {
            
       }

#LAB 4

#Arrays set up
$Name = @()
$Phone = @()

Import-Csv C:\Powershell\ExcelTest\Test1.csv |`
    #Goes through each object in each row/column and stores it into the array.
    ForEach-Object {
        $Name += $_.Name
        $Phone += $_."Phone Number"
    }

$Phone

$inputNumber = Read-Host -Prompt "Phone Number"

if ($Phone -contains $inputNumber)
    {
    Write-Host "Customer Exists!"
    #Grabs the first string that is (most likely) in the same row as another array. 
    $Where = [array]::IndexOf($Phone, "867.5309")
    Write-Host "Customer Name: " $Name[$Where]
    }





