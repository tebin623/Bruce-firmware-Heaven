<# ========================== .db / .sqlite FILE VIEWER ==============================

SYNOPSIS
This script uses sqlite to enumerate database files and return table information to the user.

Option 1
Scrape this computer's browser directories for database files, extract information and display results

Option 2
Specify a .db OR .sqlite file to display information 

USAGE
1. Run the script and follow instructions
2. select a table to view
3. Log files are located in your temp folder in 'DB_Files' 

#>
# ---------------------------------------------------------------------------------------------------------------------

# Replace with your sqlite3.exe direct download link (optional)
$url = 'https://github.com/beigeworm/assets/raw/main/sqlite3.exe'

# ---------------------------------------------------------------------------------------------------------------------

$sqlite = Join-Path -Path $temppath -ChildPath 'sqlite3.exe'
iwr -Uri $url -OutFile $sqlite 

$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host
[Console]::SetWindowSize(80, 30)
[Console]::Title = "DB File Viewer"

Function CopyFiles {

    param ([string]$dbfile,[string]$folder,[switch]$db)

    Write-Host "Input : $dbfile Selected"
    Write-Host "Folder : $folder Selected"

    $filesToCopy = Get-ChildItem -Path $dbfile -Filter '*' -Recurse | Where-Object { $_.Name -like 'Web Data' -or $_.Name -like 'History' -or $_.Name -like 'formhistory.sqlite' -or $_.Name -like 'places.sqlite' -or $_.Name -like 'cookies.sqlite'}

    foreach ($file in $filesToCopy) {
        
        Write-Host $file
        $randomLetters = -join ((65..90) + (97..122) | Get-Random -Count 5 | ForEach-Object {[char]$_})
        if ($db -eq $true){
            $newFileName = $file.BaseName + "_" + $randomLetters + $file.Extension + '.db'
        }
        else{
            $newFileName = $file.BaseName + "_" + $randomLetters + $file.Extension 
        }
        $destination = Join-Path -Path $folder -ChildPath $newFileName
        Copy-Item -Path $file.FullName -Destination $destination -Force
    }

} 

function generateCSV {
    param ([string]$path,[string]$folder)

    $tables = & "$sqlite" $path ".tables" | % { $_.Split() } | % { $_ }
    $tables = $tables | Where-Object { $_.Trim() -ne "" }
    foreach ($table in $tables) {
        $schema = & "$sqlite" $path ".schema $table"
        $data = & "$sqlite" -header -csv $path "SELECT * FROM $table"
        $schema | Out-File -FilePath "$folder/table_$table.txt"
        $randomLetters = -join ((65..90) + (97..122) | Get-Random -Count 3 | ForEach-Object {[char]$_})
        $data | Out-File -FilePath "$folder/data_$table`_$randomLetters.csv"   
    }
}

function examinefile {
    param ([string]$dbfile,[string]$folder,[switch]$db)

    if ($db -eq $true){
        $filesToExamine = Get-ChildItem -Path $dbfile -Filter '*' -Recurse | Where-Object { $_.Name -like '*.db' }
    }
    else{
        $filesToExamine = Get-ChildItem -Path $dbfile -Filter '*' -Recurse | Where-Object { $_.Name -like '*.sqlite' }
    }
    foreach ($file in $filesToExamine) {
        $script:path = $file.FullName
        Write-Host $path
        $script:csvdest = "$csvdir/$folder"
        generateCSV -path $path -folder $csvdest
    }
    
}

$temppath = [System.IO.Path]::GetTempPath() 
$tempFolder = Join-Path -Path $temppath -ChildPath "DB_Files"
rm -Path $tempFolder -Force -Confirm:$false
New-Item -Path $tempFolder -ItemType Directory -Force | Out-Null
$csvdir = Join-Path -Path $tempFolder -ChildPath 'CSV'
New-Item -Path $csvdir -ItemType Directory -Force | Out-Null
$sqlite = Join-Path -Path $temppath -ChildPath 'sqlite3.exe'
iwr -Uri 'https://github.com/beigeworm/assets/raw/main/sqlite3.exe' -OutFile $sqlite 

$getfiles = Read-Host "Do you want to scrape this machine [y/n]"
 
if ($getfiles -eq 'y'){

$script:googleDir = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data"
$script:firefoxDir = Get-ChildItem -Path "$Env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles" -Directory | Where-Object { $_.Name -like '*.default-release' };$firefoxDir = $firefoxDir.FullName
$script:edgeDir = "$Env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data"

$googledest = Join-Path -Path $tempFolder -ChildPath 'google'
$mozdest = Join-Path -Path $tempFolder -ChildPath 'firefox'
$edgedest = Join-Path -Path $tempFolder -ChildPath 'edge'
New-Item -Path $googledest -ItemType Directory -Force | Out-Null
New-Item -Path $mozdest -ItemType Directory -Force | Out-Null
New-Item -Path $edgedest -ItemType Directory -Force | Out-Null
$csvgoogle = Join-Path -Path $csvdir -ChildPath 'Google'
$csvmoz = Join-Path -Path $csvdir -ChildPath 'Firefox'
$csvedge = Join-Path -Path $csvdir -ChildPath 'Edge'
New-Item -Path $csvgoogle -ItemType Directory -Force | Out-Null
New-Item -Path $csvmoz -ItemType Directory -Force | Out-Null
New-Item -Path $csvedge -ItemType Directory -Force | Out-Null
sleep 1

copyFiles -dbfile $googleDir -folder $googledest -db
copyFiles -dbfile $firefoxDir -folder $mozdest
copyFiles -dbfile $edgeDir -folder $edgedest -db

examinefile -dbfile $googledest -folder "google" -db
examinefile -dbfile $firefoxdest -folder "firefox"
examinefile -dbfile $edgedest -folder "edge" -db

}
else{
    $filepath = Read-Host "Enter a filepath OR drag a file to this window "

    $csvcopy = Join-Path -Path $csvdir -ChildPath 'copy'
    New-Item -Path $csvcopy -ItemType Directory -Force

    if (Test-Path -Path $filepath) {
        $copyfolder = Join-Path -Path $tempFolder -ChildPath 'copy'
        New-Item -Path $copyfolder -ItemType Directory -Force | Out-Null
        $destination = Join-Path -Path $copyfolder -ChildPath (Split-Path -Leaf $filepath)
        Copy-Item -Path $filepath -Destination $destination -Force | Out-Null

    }
    else{
        Write-Host "No File Found!"
        sleep 3
    }

    $fileExtension = [System.IO.Path]::GetExtension($filepath).ToLower()
    if ($fileExtension -like '.db'){
        examinefile -dbfile $tempfolder -folder "copy" -db
    }
    if ($fileExtension -like '.sqlite'){
        examinefile -dbfile $tempfolder -folder "copy"
    }

}

sleep 1

while ($true){
    $selectfolders = Get-ChildItem -Path $csvdir -Directory -Recurse | Where-Object { $_.Name -like '*' }
    cls
    $i = 1
    foreach ($folder in $selectfolders) {
        $name = $folder.Name
        Write-Host "$i. $name"
        $i++
    }
    $selectionIndex = Read-Host "Select a folder"
    if ([int]::TryParse($selectionIndex, [ref]$null)) {
        $selectionIndex = [int]$selectionIndex
        if ($selectionIndex -ge 1 -and $selectionIndex -le $selectfolders.Count) {
            $selectedFolder = $selectfolders[$selectionIndex - 1].FullName
            Write-Host "You selected folder: $selectedFolder"
        } 
        else {
            Write-Host "Invalid selection. Please enter a number between 1 and $($selectfolders.Count)."
        }
    } 
    else {
        Write-Host "Invalid input. Please enter a valid number."
    }
    
    
    while($true){
        cls
    
        $showfiles = Get-ChildItem -Path $selectedFolder -Filter '*.csv' -Recurse
        $filesList = @()
        
        foreach ($file in $showfiles) {
            if ($file.Length -gt 0){
                $filesList += [PSCustomObject]@{
                    'Index' = $filesList.Count + 1
                    'Name' = $file.Name
                    'Size (KB)' = [math]::Round($file.Length / 1KB, 2)
                }
            }
        }
        
        if ($filesList.Count -eq 0) {
            Write-Host "No non-empty CSV files found in the selected folder."
            break
        }
    
        $filesList | Format-Table -AutoSize -Wrap
        
        Write-Host "`n0. Back To Folders"
        $selectionIndex = Read-Host "Select a file " 
         
        if ($selectionIndex -eq '0'){
            break
        }
        if ([int]::TryParse($selectionIndex, [ref]$null)) {
            $selectionIndex = [int]$selectionIndex
            if ($selectionIndex -ge 1 -and $selectionIndex -le $filesList.Count) {
                $selectedFile = ($showfiles | Where-Object { $_.Name -eq $filesList[$selectionIndex - 1].Name }).FullName
                Write-Host "You selected file: $selectedFile"  
                if ((Get-Item $selectedFile).length -gt 100) {
                    Import-Csv $selectedFile | Out-GridView -Title "Data from table $table"
                    sleep 1
                    break
                }
                else {
                    Write-Host "File is empty.."
                    sleep 1
                    break
                }
            } 
            else {
                Write-Host "Invalid selection. Please enter a number between 1 and $($filesList.Count)."
            }
        } 
        else {
            Write-Host "Invalid input. Please enter a valid number."
        }
    }
    
}
