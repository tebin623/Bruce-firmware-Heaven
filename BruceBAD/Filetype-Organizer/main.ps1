
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host
$width = 88
$height = 30
[Console]::SetWindowSize($width, $height)
$windowTitle = " BeigeTools | Filetype Organizer"
[Console]::Title = $windowTitle
Write-Host "=======================================================================================" -ForegroundColor Green
Write-Host "============================= BeigeTools | Filetype Organizer =================================" -ForegroundColor Green
Write-Host "=======================================================================================`n" -ForegroundColor Green
Write-Host "More info at : https://github.com/beigeworm" -ForegroundColor DarkGray
Write-Host "Starts a GUI window to select a folder, then search for every file with a selected filetype and output to respective named files in the root folder.`n"

# Get the directory of the script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Prompt user for file extensions
$fileExtensions = Read-Host "Enter file extensions separated by commas (e.g., jpg,mp4,png)"

# Convert the input into an array
$fileExtensionsArray = $fileExtensions -split ','

# Prompt user for folder to search recursively
$folderPath = Read-Host "Enter the folder path to search recursively"

# Prompt user to choose between move or copy
$operation = Read-Host "Enter 'M' to move files, 'C' to copy files"

# Validate the user input for the operation
if ($operation -ne 'M' -and $operation -ne 'C') {
    Write-Host "Invalid operation. Please enter 'M' for move or 'C' for copy."
    exit
}

# Create output folders in the script directory
foreach ($extension in $fileExtensionsArray) {
    $folderName = $extension.Trim()
    $folderPathForExtension = Join-Path $scriptDirectory $folderName
    New-Item -ItemType Directory -Path $folderPathForExtension -Force
}

# Search for files and move/copy to appropriate folders
foreach ($extension in $fileExtensionsArray) {
    $files = Get-ChildItem -Path $folderPath -Recurse -Include "*.$extension"
    
    foreach ($file in $files) {
        $destinationFolder = Join-Path $scriptDirectory $extension.Trim()

        if ($operation -eq 'M') {
            $ind = $file.FullName
            Move-Item $file.FullName -Destination $destinationFolder -Force
            Write-Host "Moved : $ind"
            
        } elseif ($operation -eq 'C') {
            $ind = $file.FullName
            Copy-Item $file.FullName -Destination $destinationFolder -Force
            Write-Host "Copied : $ind"
        }
    }
}

Write-Host "Operation Complete." -ForegroundColor Green
pause