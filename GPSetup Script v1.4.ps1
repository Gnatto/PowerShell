Set-ExecutionPolicy Bypass
Start-Process -NoNewWindow -Wait -Filepath "\\GP16QA2\GPShare\NatInstall\dotnetfx35setup.exe"
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$node = 0
$Path = "C:\Program Files (x86)\Microsoft Dynamics\GP2018\Data"
#Install GP
Start-Process -NoNewWindow -Wait -filepath "\\GP16QA2\GPShare\NatInstall\GPInstallation\setup.exe"
#RUN THIS AFTER INSTALLING GP
#Create a new directory in C: called Pub, add the logs file, copy all of the templates, add the FORM&REPORT dictionaries to the GP programs folder
New-Item -Path "C:\" -Name "Pub" -ItemType "directory" 
New-Item -Path "C:\Pub" -Name "logs" -ItemType "directory"
New-Item -Path "C:\Pub" -Name "DBs" -ItemType "directory"
Copy-Item -Path "\\GP16QA2\GPShare\NatInstall\IM DBs\*" -Destination "C:\pub\DBs" -Recurse
Copy-Item -Path "\\GP16QA2\GPShare\NatInstall\IMTemplates\*" -Destination "C:\Pub" -Recurse
Start-Process -NoNewWindow -Wait -filepath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Dynamics\GP 2018"
#Loop module for adding dictionaries and other content dependent on the filepath
WHILE($node -eq 0)
{
    $FolderExists = Test-Path $path
    Write-Host "Checking if GP folder exists..."
    IF($FolderExists -eq $True)
    {
     $node = 1
     Write-Host "GP File Path Exists. Transferring dictionaries and giving GP users full access to GP folder."
     Copy-Item -Path "\\GP16QA2\GPShare\NatInstall\Dictionaries\*" -Destination "C:\Program Files (x86)\Microsoft Dynamics\GP2018\Data" -Recurse 
     #Give GP_Users full control to folder, subfolder and files for GP Dynamics folder. 
     $Acl = Get-Acl "C:\Program Files (x86)\Microsoft Dynamics"
     $Ar = New-Object system.security.accesscontrol.filesystemaccessrule("GPS_Users",'FullControl','ContainerInherit, ObjectInherit', 'None', "Allow")
     $Acl.SetAccessRule($Ar)
     Set-Acl "C:\Program Files (x86)\Microsoft Dynamics" $Acl
    }
    ELSE
    {
      Write-Host "The File does not exist" 
    }
} 
#GUI for downloading optional applications
$optGUI                    = New-Object system.Windows.Forms.Form
#Define the size, title and background color
$optGUI.ClientSize         = '500,350'
$optGUI.text               = "Optional Applications"
$optLabel = New-Object System.Windows.Forms.Label
$optLabel.Text = "Click to Install"
$optLabel.Location = New-Object System.Drawing.Point(200,30)
$optGUI.Controls.Add($optLabel)
$optGUI.BackColor          = "#ffffff"

#Integration Manager Button 
$imBtn                       = New-Object system.Windows.Forms.Button
$imBtn.BackColor             = "#ffffff"
$imBtn.text                  = "Integration Manager"
$imBtn.width                 = 150
$imBtn.height                = 50
$imBtn.location              = New-Object System.Drawing.Point(170,60)
$imBtn.Font                  = 'Microsoft Sans Serif,10'
$imBtn.ForeColor             = "#000"
$optGUI.Controls.Add($imBtn)
#Management Reporter Button
$mrBtn                       = New-Object system.Windows.Forms.Button
$mrBtn.BackColor             = "#ffffff"
$mrBtn.text                  = "Management Reporter"
$mrBtn.width                 = 150
$mrBtn.height                = 50
$mrBtn.location              = New-Object System.Drawing.Point(170,130)
$mrBtn.Font                  = 'Microsoft Sans Serif,10'
$mrBtn.ForeColor             = "#000"
$optGUI.Controls.Add($mrBtn)
#Kwik Tag Button
$ktBtn                       = New-Object system.Windows.Forms.Button
$ktBtn.BackColor             = "#ffffff"
$ktBtn.text                  = "Kwik Tag"
$ktBtn.width                 = 150
$ktBtn.height                = 50
$ktBtn.location              = New-Object System.Drawing.Point(170,200)
$ktBtn.Font                  = 'Microsoft Sans Serif,10'
$ktBtn.ForeColor             = "#000"
$optGUI.Controls.Add($ktBtn)

#Management Reporter Button
$mkBtn                       = New-Object system.Windows.Forms.Button
$mkBtn.BackColor             = "#ffffff"
$mkBtn.text                  = "Mekorma"
$mkBtn.width                 = 150
$mkBtn.height                = 50
$mkBtn.location              = New-Object System.Drawing.Point(170,270)
$mkBtn.Font                  = 'Microsoft Sans Serif,10'
$mkBtn.ForeColor             = "#000"
$optGUI.Controls.Add($mkBtn)
#---------------------[Functions]------------------------

function imBtn
{
Start-Process -NoNewWindow -Wait -filepath "\\GP16QA2\GPShare\Microsoft\MDGP2018_R2_DVD_ENUS\MDGP2018_R2_DVD_ENUS\setup.exe"
Start-Process -filepath "C:\Program Files (x86)\Microsoft Dynamics\Integration Manager 18\Microsoft.Dynamics.GP.IntegrationManager.exe"
Start-Process -filepath "\\GP16QA2\GPShare\Long and Foster\Integration_mgr_license.txt"
}

function mrBtn
{
Start-Process -filepath "\\GP16QA2\GPShare\Microsoft\MR2012CU14\setup.exe"
Start-Process -filepath "\\GP16QA2\GPShare\NatInstall\GPInstallation\MR Server Address.txt"
}

function ktBtn
{
Start-Process -filepath "\\GP16QA2\GPShare\NatInstall\KwikTag\KwikTag Connector for Microsoft Dynamics GP 2018.msi"
}
function mkBtn
{
Start-Process -filepath "\\GP16QA2\GPShare\NatInstall\Mekorma\MICR2018b076.exe"
}
#Button cilck for the optional application installations
$imBtn.Add_Click({imBtn})
$mrBtn.Add_Click({mrBtn})
$ktBtn.Add_Click({ktBtn})
$mkBtn.Add_Click({mkBtn})

#DISPLAY contents for optional application buton ABOVE THIS LINE
$result = $optGUI.ShowDialog()
Start-Process -filepath "C:\Windows\SysWOW64\odbcad32.exe"
 



