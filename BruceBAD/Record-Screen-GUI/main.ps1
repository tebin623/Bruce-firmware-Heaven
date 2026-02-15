$Import = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);';
add-type -name win -member $Import -namespace native;
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0);

Add-Type -AssemblyName System.Windows.Forms
$form = New-Object Windows.Forms.Form
$form.Text = "  BeigeTools | Screen Recorder "
$form.Font = 'Microsoft Sans Serif,12,style=Bold'
$form.Size = New-Object Drawing.Size(350, 200)
$form.StartPosition = 'Manual'
$form.BackColor = [System.Drawing.Color]::Black
$form.ForeColor = [System.Drawing.Color]::White
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$Text = New-Object Windows.Forms.Label
$Text.Text = "Framerate"
$Text.AutoSize = $true
$Text.Font = 'Microsoft Sans Serif,10'
$Text.Location = New-Object System.Drawing.Point(15, 20)
$fps = New-Object Windows.Forms.Label
$fps.Text = "fps"
$fps.AutoSize = $true
$fps.Font = 'Microsoft Sans Serif,10'
$fps.Location = New-Object System.Drawing.Point(60, 40)

$frBox = New-Object System.Windows.Forms.TextBox
$frBox.Location = New-Object System.Drawing.Point(18, 40)
$frBox.BackColor = "#eeeeee"
$frBox.Width = 40
$frBox.Text = "25"
$frBox.Multiline = $false
$frBox.Font = 'Microsoft Sans Serif,8,style=Bold'

$Text2 = New-Object Windows.Forms.Label
$Text2.Text = "Record Time"
$Text2.Font = 'Microsoft Sans Serif,10'
$Text2.AutoSize = $true
$Text2.Location = New-Object System.Drawing.Point(120, 20)
$sec = New-Object Windows.Forms.Label
$sec.Text = "s"
$sec.AutoSize = $true
$sec.Font = 'Microsoft Sans Serif,10'
$sec.Location = New-Object System.Drawing.Point(165, 40)

$tBox = New-Object System.Windows.Forms.TextBox
$tBox.Location = New-Object System.Drawing.Point(123, 40)
$tBox.BackColor = "#eeeeee"
$tBox.Width = 40
$tBox.Text = "30"
$tBox.Multiline = $false
$tBox.Font = 'Microsoft Sans Serif,8,style=Bold'

$Text3 = New-Object Windows.Forms.Label
$Text3.Text = "Offset X"
$Text3.Font = 'Microsoft Sans Serif,10'
$Text3.AutoSize = $true
$Text3.Location = New-Object System.Drawing.Point(15, 70)
$ofx = New-Object Windows.Forms.Label
$ofx.Text = "px"
$ofx.AutoSize = $true
$ofx.Font = 'Microsoft Sans Serif,10'
$ofx.Location = New-Object System.Drawing.Point(60, 90)

$oxBox = New-Object System.Windows.Forms.TextBox
$oxBox.Location = New-Object System.Drawing.Point(18, 90)
$oxBox.BackColor = "#eeeeee"
$oxBox.Width = 40
$oxBox.Text = "0"
$oxBox.Multiline = $false
$oxBox.Font = 'Microsoft Sans Serif,8,style=Bold'

$Text4 = New-Object Windows.Forms.Label
$Text4.Text = "Offset Y"
$Text4.Font = 'Microsoft Sans Serif,10'
$Text4.AutoSize = $true
$Text4.Location = New-Object System.Drawing.Point(120, 70)
$ofy = New-Object Windows.Forms.Label
$ofy.Text = "px"
$ofy.AutoSize = $true
$ofy.Font = 'Microsoft Sans Serif,10'
$ofy.Location = New-Object System.Drawing.Point(165, 90)

$oyBox = New-Object System.Windows.Forms.TextBox
$oyBox.Location = New-Object System.Drawing.Point(123, 90)
$oyBox.BackColor = "#eeeeee"
$oyBox.Width = 40
$oyBox.Text = "0"
$oyBox.Multiline = $false
$oyBox.Font = 'Microsoft Sans Serif,8,style=Bold'

$Text5 = New-Object Windows.Forms.Label
$Text5.Text = "Video Size"
$Text5.Font = 'Microsoft Sans Serif,10'
$Text5.AutoSize = $true
$Text5.Location = New-Object System.Drawing.Point(15, 120)

$vsBox = New-Object System.Windows.Forms.TextBox
$vsBox.Location = New-Object System.Drawing.Point(18, 140)
$vsBox.BackColor = "#eeeeee"
$vsBox.Width = 140
$vsBox.Text = "1920x1080"
$vsBox.Multiline = $false
$vsBox.Font = 'Microsoft Sans Serif,8,style=Bold'

$Download = New-Object Windows.Forms.Button
$Download.Text = "Get ffmpeg.exe"
$Download.Width = 120
$Download.Height = 30
$Download.BackColor = [System.Drawing.Color]::White
$Download.ForeColor = [System.Drawing.Color]::Black
$Download.Location = New-Object System.Drawing.Point(210, 50)
$Download.Font = 'Microsoft Sans Serif,10,style=Bold'

$Check = New-Object Windows.Forms.Button
$Check.Text = "Check Files"
$Check.Width = 120
$Check.Height = 30
$Check.BackColor = [System.Drawing.Color]::White
$Check.ForeColor = [System.Drawing.Color]::Black
$Check.Location = New-Object System.Drawing.Point(210, 90)
$Check.Font = 'Microsoft Sans Serif,10,style=Bold'

$startrecord = New-Object Windows.Forms.Button
$startrecord.Text = "Start"
$startrecord.Width = 120
$startrecord.Height = 30
$startrecord.BackColor = [System.Drawing.Color]::White
$startrecord.ForeColor = [System.Drawing.Color]::Black
$startrecord.Location = New-Object System.Drawing.Point(210, 130)
$startrecord.Font = 'Microsoft Sans Serif,10,style=Bold'

$form.Controls.AddRange(@($Text,$fps,$frBox,$Text2,$sec,$tbox,$Text3,$ofx,$oxBox,$Text4,$ofy,$oyBox,$Text5,$vsBox,$Download,$Check,$startrecord))


$Download.Add_Click{
$Path = "$env:Temp\ffmpeg.exe"
If (!(Test-Path $Path)){  
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
Write-Output "FFmpeg has been downloaded and extracted to $tempDir"
}
}

$Check.Add_Click{
$Path = "$env:Temp\ffmpeg.exe"
If (!(Test-Path $Path)){msg.exe * 'Not Installed'}
else {msg.exe * 'Installed'}
}

$startrecord.Add_Click{
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$mkvPath = "Clip_$timestamp.mkv"

if ($t.Length -eq 0){$t = 10}
if ($fr.Length -eq 0){$fr = 25}
if ($ox.Length -eq 0){$ox = 0}
if ($oy.Length -eq 0){$oy = 0}
if ($vs.Length -eq 0){$vs = "1920x1080"}

.$env:Temp\ffmpeg.exe -f gdigrab -framerate $fr -t $t -offset_x $ox -offset_y $oy -video_size $vs -show_region 1 -i desktop $mkvPath
}

$form.ShowDialog()
