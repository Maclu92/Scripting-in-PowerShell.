<#Author: Michael Zulian
Date: 07/02/2017
Purpose: Create a log file which records System Info.#> 

#Create Variables for Log Path Directory, Log Path File, Disk Information, Bios #Information #and Installed Products (Applications) Information and Today's Date. Use CIM cmdlets 
########################################################################


$log_path_dir="$Home\Documents\Lab4_Week4"
$log_path_file="$Home\Documents\Lab4_Week4\lab4\mzulian_lab4_logfile.log"
$date=Get-Date

#Create a Message “Gathering Machine Informationon <computername>. Please wait…”
#########################################################################

Write-Host "Gathering System Info on $env:COMPUTERNAME. Please Wait."

#Create Log file and output Log File Title with Computer Name and Date of Report
########################################################################

Write-Output "System Info for $env:COMPUTERNAME on $date" | Out-File -Force -FilePath "$log_path_file"  
Write-Output "================================================== " | Out-file -FilePath "$log_path_file"  -append
 #Create a Disk Drive Summary Header, Get Disk Information and Output to log file
########################################################################

Write-Output "`n`n`n`n"| Out-File  "$log_path_file" -append
Write-Output "Disk Drive Summary" |Out-file "$log_path_file" -append
Write-Output "============================================" | Out-file "$log_path_file"  -append

$disk_info=Get-CimInstance CIM_DiskDrive | Select-Object -Property Model,Size 
Write-Output "$disk_info" | Out-File -FilePath $log_path_file -Append

 #Create a Bios Summary Header, Get Bios Information and Output to log file
########################################################################

Write-Output "`n`n`n`n"| Out-File  "$log_path_file" -append
Write-Output "BIOS Summary" |Out-file "$log_path_file" -append
Write-Output "============================================" | Out-file "$log_path_file"  -append

$bios_info=Get-CimInstance CIM_BIOSElement | Select-Object -Property Manufacturer,Version 
Write-Output "$bios_info" | Out-File -FilePath $log_path_file -Append

#Create an Installed Software Summary Header, Get Product Information and Output to #log file
#######################################################################

Write-Output "`n`n`n`n"| Out-File  "$log_path_file" -append
Write-Output "Product Summary" |Out-file "$log_path_file" -append
Write-Output "============================================" | Out-file "$log_path_file"  -append

$app_info=Get-CimInstance CIM_Product | Select-Object -Property Name,Description,Version 
Write-Output "$app_info" | Out-File -FilePath $log_path_file -Append


#Display a Message Log File Created.
########################################################################

Write-Host "`n`n"
Write-Host "Log file completed at $log_path_dir" 




 
