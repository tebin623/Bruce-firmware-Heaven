
<#
====================== Mon's Network Enumeration Tool With GUI ==========================

SYNOPSIS
This script presents a GUI for enumerating other devices on the LAN network..

USAGE
1. Run script with powershell
2. Input ip Range and select additional parameters
3. Press "Start Scan"

#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic
[System.Windows.Forms.Application]::EnableVisualStyles()

$tooltip1 = New-Object System.Windows.Forms.ToolTip
$ShowHelp={
    Switch ($this.name) {

      
        "start"  {$tip = "Start Search"}

        "ipsearch"  {$tip = "Define the first part of the IP here"}

        "startrange"  {$tip = "Define the start of the IP range"}

        "endrange"  {$tip = "Define the start of the IP range"}

        "hostname"  {$tip = "Try to resolve each IP's hostname"}

        "ssh"  {$tip = "Test port 22 (ssh) on each IP"}

        "manufact"  {$tip = "Get any manufacturer details"}
}
$tooltip1.SetToolTip($this,$tip)
}

$MainWindow = New-Object System.Windows.Forms.Form
$MainWindow.ClientSize = '552,535'
$MainWindow.Text = "| beigetools | LAN Device Search & Enumeration |"
$MainWindow.BackColor = "#242424"
$MainWindow.Opacity = 0.93
$MainWindow.TopMost = $false
$MainWindow.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\DevicePairingWizard.exe")

$OutputBox = New-Object System.Windows.Forms.TextBox 
$OutputBox.Multiline = $True;
$OutputBox.Location = New-Object System.Drawing.Size(15,180) 
$OutputBox.Width = 522
$OutputBox.Height = 340
$OutputBox.Scrollbars = "Vertical" 
$OutputBox.Text = "-----------------------------------       RESULTS       -----------------------------------"
$OutputBox.Font = 'Microsoft Sans Serif,8,style=Bold'

$StartScan = New-Object System.Windows.Forms.Button
$StartScan.Text = "Start"
$StartScan.Width = 100
$StartScan.Height = 25
$StartScan.Location = New-Object System.Drawing.Point(435, 33)
$StartScan.Font = 'Microsoft Sans Serif,8,style=Bold'
$StartScan.BackColor = "#eeeeee"
$StartScan.add_MouseHover($showhelp)
$StartScan.name="start"

$sshboxtext = New-Object System.Windows.Forms.Label
$sshboxtext.Text = "Test for SSH"
$sshboxtext.ForeColor = "#bcbcbc"
$sshboxtext.AutoSize = $true
$sshboxtext.Width = 25
$sshboxtext.Height = 10
$sshboxtext.Location = New-Object System.Drawing.Point(35, 67)
$sshboxtext.Font = 'Microsoft Sans Serif,8,style=Bold'

$sshbox = New-Object System.Windows.Forms.CheckBox
$sshbox.Width = 20
$sshbox.Height = 20
$sshbox.Location = New-Object System.Drawing.Point(15, 65)
$sshbox.add_MouseHover($showhelp)
$sshbox.name="ssh"

$manufacturerboxtext = New-Object System.Windows.Forms.Label
$manufacturerboxtext.Text = "Include Manufacturer"
$manufacturerboxtext.ForeColor = "#bcbcbc"
$manufacturerboxtext.AutoSize = $true
$manufacturerboxtext.Width = 25
$manufacturerboxtext.Height = 10
$manufacturerboxtext.Location = New-Object System.Drawing.Point(35, 97)
$manufacturerboxtext.Font = 'Microsoft Sans Serif,8,style=Bold'

$manufacturerbox = New-Object System.Windows.Forms.CheckBox
$manufacturerbox.Width = 20
$manufacturerbox.Height = 20
$manufacturerbox.Location = New-Object System.Drawing.Point(15, 95)
$manufacturerbox.add_MouseHover($showhelp)
$manufacturerbox.name="manufact"

$hostnameboxtext = New-Object System.Windows.Forms.Label
$hostnameboxtext.Text = "Include Network Hostname"
$hostnameboxtext.ForeColor = "#bcbcbc"
$hostnameboxtext.AutoSize = $true
$hostnameboxtext.Width = 25
$hostnameboxtext.Height = 10
$hostnameboxtext.Location = New-Object System.Drawing.Point(35, 127)
$hostnameboxtext.Font = 'Microsoft Sans Serif,8,style=Bold'

$hostnamebox = New-Object System.Windows.Forms.CheckBox
$hostnamebox.Width = 20
$hostnamebox.Height = 20
$hostnamebox.Location = New-Object System.Drawing.Point(15, 125)
$hostnamebox.add_MouseHover($showhelp)
$hostnamebox.name="hostname"

$TextboxInputHeader = New-Object System.Windows.Forms.Label
$TextboxInputHeader.Text = "Search IP Range for All Devices"
$TextboxInputHeader.ForeColor = "#bcbcbc"
$TextboxInputHeader.AutoSize = $true
$TextboxInputHeader.Width = 25
$TextboxInputHeader.Height = 10
$TextboxInputHeader.Location = New-Object System.Drawing.Point(15, 15)
$TextboxInputHeader.Font = 'Microsoft Sans Serif,8,style=Bold'

$TextBoxInput = New-Object System.Windows.Forms.TextBox
$TextBoxInput.Location = New-Object System.Drawing.Point(15, 35)
$TextBoxInput.BackColor = "#eeeeee"
$TextBoxInput.Width = 140
$TextBoxInput.Height = 40
$TextBoxInput.Text = "192.168.0."
$TextBoxInput.Multiline = $false
$TextBoxInput.Font = 'Microsoft Sans Serif,8,style=Bold'
$TextBoxInput.add_MouseHover($showhelp)
$TextBoxInput.name="ipsearch"

$dashline = New-Object System.Windows.Forms.Label
$dashline.Text = "-"
$dashline.ForeColor = "#bcbcbc"
$dashline.AutoSize = $true
$dashline.Width = 25
$dashline.Height = 10
$dashline.Location = New-Object System.Drawing.Point(220, 35)
$dashline.Font = 'Microsoft Sans Serif,9,style=Bold'

$startip = New-Object System.Windows.Forms.TextBox
$startip.Location = New-Object System.Drawing.Point(170, 35)
$startip.BackColor = "#eeeeee"
$startip.Width = 50
$startip.Height = 40
$startip.Text = "1"
$startip.Multiline = $false
$startip.Font = 'Microsoft Sans Serif,8,style=Bold'
$startip.add_MouseHover($showhelp)
$startip.name="startrange"

$endip = New-Object System.Windows.Forms.TextBox
$endip.Location = New-Object System.Drawing.Point(230, 35)
$endip.BackColor = "#eeeeee"
$endip.Width = 50
$endip.Height = 40
$endip.Text = "254"
$endip.Multiline = $false
$endip.Font = 'Microsoft Sans Serif,8,style=Bold'
$endip.add_MouseHover($showhelp)
$endip.name="endrange"

#==================================================== Define GUI Elements ==========================================================
    
$MainWindow.controls.AddRange(@($TextBoxInput, $startip, $endip, $StartScan, $sshboxtext, $sshbox, $manufacturerboxtext, $manufacturerbox, $hostnameboxtext, $hostnamebox,  $OutputBox, $TextboxInputHeader, $dashline))

#==================================================== Click Functions ==========================================================

$StartScan.Add_Click({

Function Add-OutputBoxLine{
    Param ($outfeed) 
    $OutputBox.AppendText("`r`n$outfeed")
    $OutputBox.Refresh()
    $OutputBox.ScrollToCaret()
}
Add-OutputBoxLine -Outfeed "Starting scan..."

$FileOut = "$env:temp\Computers.csv"
$Subnet = $TextBoxInput.Text
$a=[int]$startip.text
$b=[int]$endip.text

$a..$b|ForEach-Object{
    Start-Process -WindowStyle Hidden ping.exe -Argumentlist "-n 1 -l 0 -f -i 2 -w 100 -4 $SubNet$_"
}
$Computers = (arp.exe -a | Select-String "$SubNet.*dynam") -replace ' +',','|
  ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor|
                   Select IPv4,MAC
$Computers | Export-Csv $FileOut -NotypeInformation

if($sshbox.Checked){

$data = Import-Csv "$env:temp\Computers.csv"
$data | Add-Member -MemberType NoteProperty -Name "ssh" -Value ""
$data | ForEach-Object {
    $ip = $_.'IPv4'
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $timeout = 2 * 1000 # 2 seconds timeout
        $asyncResult = $tcpClient.BeginConnect($ip, 22, $null, $null)
        $wait = $asyncResult.AsyncWaitHandle.WaitOne($timeout, $false)
        if ($wait) {
            $tcpClient.EndConnect($asyncResult)
            $ssh = "Yes"
        } else {
            $ssh = "No"
        }
        $tcpClient.Close()
    } catch {
        $ssh = "Closed"
    }
    $_ | Add-Member -MemberType NoteProperty -Name "ssh" -Value $ssh -force
}
$data | Export-Csv "$env:temp\Computers.csv" -NoTypeInformation
}

if($manufacturerbox.Checked){

$data = Import-Csv "$env:temp\Computers.csv"
$data | Add-Member -MemberType NoteProperty -Name "manufacturer" -Value ""
$data | ForEach-Object {

    $mac = $_.'MAC'
    $apiUrl = "https://api.macvendors.com/" + $mac
    $manufacturer = (Invoke-WebRequest -Uri $apiUrl).Content
    start-sleep 1
    $_ | Add-Member -MemberType NoteProperty -Name "manufacturer" -Value $manufacturer -force
}
$data | Export-Csv "$env:temp\Computers.csv" -NoTypeInformation
}


if($hostnamebox.Checked){

$data = Import-Csv "$env:temp\Computers.csv"
$data | Add-Member -MemberType NoteProperty -Name "Hostname" -Value ""
$data | ForEach-Object {
    try{
    $ip = $_.'IPv4'
    $hostname = ([System.Net.Dns]::GetHostEntry($ip)).HostName
    $_ | Add-Member -MemberType NoteProperty -Name "Hostname" -Value $hostname -force
    } catch{
    $_ | Add-Member -MemberType NoteProperty -Name "Hostname" -Value "Error: $($_.Exception.Message)"  
    }
}
$data | Export-Csv "$env:temp\Computers.csv" -NoTypeInformation
}

$textfile = Get-Content "$env:temp\Computers.csv" -Raw 

Add-OutputBoxLine -Outfeed "$textfile"

})

#===================================================== Initialize Script ===================================================
 
$MainWindow.ShowDialog() | Out-Null
exit 
