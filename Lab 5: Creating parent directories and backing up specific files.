<#
.SYNOPSIS
  Tests the path to working directory path and moves course files.
.DESCRIPTION
    The script uses the ARGS array to store the working directory and directory name to create.
    It then compares the working directory to the $PWD variable, if the user is not in the correct directory,
    a message is displayed and the user is moved to the correct directory. The script checks
    for the existence of the parent folder and if it is empty. IF the folder exists the script renames the
    folder. If it does not exist the script creates the folder and subfolders. A recursive search is done
    to move all course files which is stored in a folder WIN213Xcopy. The files are then sorted by file tag 
    and moved to the appropriate subfolder. A counter is enabled to indicate how many files were moved. 
.EXAMPLE
    PS:> .\Win213R_Lab_TestDir.ps1 WorkingDirectory DirectoryName
.Notes
        Author:  Michael Zulian
        DateLastModified: 02/10/2017  
#>

## Create 2 command line variables
############################################################################
$WorkingDirectory = $args[0]
$DirectoryName = $args[1]

## Check if variables are empty and get user input if necessary
##############################################################################
if("$WorkingDirectory" -eq "") {
Write-Warning "Paramter Required."
$WorkingDirectory= Read-Host "Enter an absolute path to working directory"} 
 
if("$DirectoryName" -eq "") {
    Write-Warning "Paramter Required."
    $DirectoryName= Read-Host "Enter a directory name to search for in."}
 
 clear

## “Test to see if $PWD is equal to $WorkingDirectory and if not move the user”
#############################################################################
if ("$PWD" -ne "$WorkingDirectory") {
    echo "You are not in the <$WorkingDirectory>. Do you wish to move? Press CTRL + C to exit or," 
    PAUSE
    Set-Location $WorkingDirectory
}

## “Test if directory exists in the working directory”
#############################################################################
if ((Test-Path $DirectoryName) -ne $true){
    echo "Directory <$DirectoryName> does not exist."
    New-Item . -Name $DirectoryName -ItemType Directory
}else{
    echo "Directory <$DirectoryName> does exist."  
}



If ((gci $Directoryname).count –ne  0 ) {
    echo "Folder <$DirectoryName> is not empty and will be renamed. Press CTRL +C to exit or" 
    Pause
    Rename-Item $DirectoryName -NewName "$DirectoryName.old"  
    Exit-PSSession  
    
}


## “Create variables for subfolders ”
#############################################################################
$SubDirs = @{"Data1" = "Lectures"; "Data2" = "Labs"; "Data3" = "Assignments"; "Data4" = "Scripts"}  



## “Loop through collection to create subfolders”
#############################################################################
ForEach ($newdir in $SubDirs.Values) {
  md $WorkingDirectory\$DirectoryName\$newdir
} 

## “Recursively search Documents folder only for files and save them to a new Win213Copy directory”
#############################################################################
$files = gci $WorkingDirectory -File -Recurse 

if ((Test-Path win213.copy) -ne $True){
    echo "Directory win213.copy needed to store files." 
    Pause
    New-Item -Path . -Itemtype Directory -Name "win213.copy"
}

$files | Copy-Item -Destination .\win213.copy   


## “Get a listing of the files in the Copy folder and move them to the appropriate subfolder”
#############################################################################
$filelist = gci .\win213.copy -File -Recurse
$count = 0 

ForEach ($file in $filelist) {
    $count = $count + 1 
    Copy-Item ".\win213.copy\*lec*"-Destination "$PWD\win213\Lectures"
    Copy-Item  ".\win213.copy\*lab*"-Destination "$PWD\win213\Labs"
    Copy-Item  ".\win213.copy\*Assign*" -Destination "$PWD\win213\Assignments"
    Copy-Item  ".\win213.copy\*.ps1" -Destination "$PWD\win213\Scripts"
}
Write-Warning "<$count> is the total # of moved files to win213" 
Remove-Item .\win213.copy 
Write-Warning "Removing .\win213.copy directory" 

if ((Test-Path win213.copy) -eq $True) { 
    echo "Directory win213.copy has not been removed"
}
else { 
    echo "Directory .\win213.copy is removed" 
}
