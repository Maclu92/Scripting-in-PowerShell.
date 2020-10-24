#!/usr/bin/env pwsh

<#
# Author: Michael Zulian
# Last Update: 10/23/2020
# Purpose --
    Delete empty columns with headers
# Details --
    1) User gives a legit csv file and a non-existing dst file
    2) imported via import-csv
    3) Loops through each column with a conditional that notes
        when a column has a value, then adds the column.name property to a generic list
    4) Then load in the imported-csv once more and | select the column.Name properties noted in the loop

# General TODO -
    * Loop on userInput, say someone wants to retype  the src or dst file
    * Catch the non-existing file exception (Import-Csv prints a generic error)
    * Check if the dst file exists and prompt for continuation
    * Tab-compeletion in read-host prompt??
    *
# Report Known Errors/Bugs -
    1)
#>



### Standard Library Modules ###

### Third-Party Modules ###


### GLOBAL VARIABLES ###


### FUNCTIONS ###
# Write-Color -Text Red,White,Blue -Color Red,White,Blue
# Found on StackOverFlow - user actually made a module:
## https://github.com/EvotecIT/PSWriteColor/blob/master/Public/Write-Color.ps1
function Write-Color([String[]]$Text, [ConsoleColor[]]$Color) {
    for ($i = 0; $i -lt $Text.Length; $i++) {
        Write-Host $Text[$i] -Foreground $Color[$i] -NoNewLine
    }
    Write-Host
}

### MAIN ###

$userInput_srcSheet = Read-Host -Prompt 'Input the CSV or Excel you''d like to work with '
$userInput_dstSheet = Read-Host -Prompt 'Export the CSV or Excel to '
$userInput_delimiter = Read-Host -Prompt 'What is the delimiter (hit ENTER for "'',''") '

# default selection
if ([string]::IsNullOrEmpty($userInput_srcSheet))  # :: is a method
    {
        $delimiter = ','
        }
    else
    {
        $delimiter = $userInput_delimiter
        }

Write-Color -Text "Your file: ", $userInput_srcSheet, " delimited by ", """$delimiter""" -Color cyan,red,cyan,red
Read-Host "...Press ENTER to continue..."

## Working with the file
# Import the CSV
try{$sheet = Import-Csv -Path $userInput_srcSheet -Delimiter $delimiter}
catch{"Issue importing file"}
# I avoided using arrays here
# $column_with_values = [System.Collections.ArrayList]::new()
# Instead I used a generic list
# I could of also created the obj with [System.Collections.Generic.List[string]]::new()
$column_with_values = New-Object System.Collections.Generic.List[System.Object]

# Enumerate through the CSV
foreach($line in $sheet)
{   # Enumerate through each row grabbing the property of that row
    # the two properties of the $line is (header/value) with Name and its subsequent value
    $properties = $line | Get-Member -MemberType Properties
    # We could loop through the properties using foreach but we also need a counter
    # We need to loop through every single row to be certain it doesn't contain any values
    for($i=0; $i -lt $properties.Count;$i++)
    {
        # header
        $column = $properties[$i]
        # value of the header/row
        $columnvalue = $line | Select -ExpandProperty $column.Name
        # if column index is not in array continue
        if($column_with_values -notcontains $column.Name){
            # Check if columnvalue is empty, if it isnt continue
            if( -not [string]::IsNullOrEmpty($columnvalue)){
                # Some .NET functions may return a value hence [void] if this was an array
                # [void]$column_with_values.Add($i)
                # we're using a generic list hence:
                $column_with_values.Add($column.Name)
            }
        }
    }
}

# We now know which column contains no values
## That column would not exist in the array we've created above
## We now need to delete that column
$sheet | select $column_with_values | Export-CSV $userInput_dstSheet
