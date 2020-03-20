#Simple script requested by colleague to get printer driver and IP address(port) then export it to a CSV file
Get-Printer |  
Where-Object PortName -like [1-255]* | 
Select-Object  Name, DriverName, PortName |
Export-CSV -Path $home\Desktop\PrinterPorts.csv 



 

