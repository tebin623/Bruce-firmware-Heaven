Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic
[System.Windows.Forms.Application]::EnableVisualStyles()

$tooltip1 = New-Object System.Windows.Forms.ToolTip
$ShowHelp={
    Switch ($this.name) {

      
        "start"  {$tip = "Start Spamming!"}

        "image"  {$tip = "Select an Image"}

        "url"  {$tip = "Input Discord Webhook URL"}

        "message"  {$tip = "Input Message Here"}

        "imgpath"  {$tip = "Path to your Image"}

        "delay"  {$tip = "Delay Between Sending"}

        "amount"  {$tip = "Amount of Messages to Send"}
}
$tooltip1.SetToolTip($this,$tip)
}

$MainWindow = New-Object System.Windows.Forms.Form
$MainWindow.ClientSize = '435,300'
$MainWindow.Text = "| BeigeTools | Webhook Spammer |"
$MainWindow.BackColor = "#242424"
$MainWindow.Opacity = 1
$MainWindow.TopMost = $true
$MainWindow.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\DevicePairingWizard.exe")

$StartSpam = New-Object System.Windows.Forms.Button
$StartSpam.Text = "Start"
$StartSpam.Width = 80
$StartSpam.Height = 25
$StartSpam.Location = New-Object System.Drawing.Point(340, 263)
$StartSpam.Font = 'Microsoft Sans Serif,8,style=Bold'
$StartSpam.BackColor = "#eeeeee"
$StartSpam.add_MouseHover($showhelp)
$StartSpam.name="start"

$selimage = New-Object System.Windows.Forms.Button
$selimage.Text = "Browse"
$selimage.Width = 80
$selimage.Height = 25
$selimage.Location = New-Object System.Drawing.Point(245, 263)
$selimage.Font = 'Microsoft Sans Serif,8,style=Bold'
$selimage.BackColor = "#eeeeee"
$selimage.add_MouseHover($showhelp)
$selimage.name="image"

$URLboxInputHeader = New-Object System.Windows.Forms.Label
$URLboxInputHeader.Text = "Discord Webhook URL"
$URLboxInputHeader.ForeColor = "#bcbcbc"
$URLboxInputHeader.AutoSize = $true
$URLboxInputHeader.Width = 25
$URLboxInputHeader.Height = 10
$URLboxInputHeader.Location = New-Object System.Drawing.Point(15, 15)
$URLboxInputHeader.Font = 'Microsoft Sans Serif,8,style=Bold'

$URLboxInput = New-Object System.Windows.Forms.TextBox
$URLboxInput.Location = New-Object System.Drawing.Point(20, 35)
$URLboxInput.BackColor = "#eeeeee"
$URLboxInput.Width = 400
$URLboxInput.Height = 40
$URLboxInput.Text = "https://discord.com/api/webhooks/..."
$URLboxInput.Multiline = $false
$URLboxInput.Font = 'Microsoft Sans Serif,8,style=Bold'
$URLboxInput.add_MouseHover($showhelp)
$URLboxInput.name="url"

$TextboxInputHeader = New-Object System.Windows.Forms.Label
$TextboxInputHeader.Text = "Message Content"
$TextboxInputHeader.ForeColor = "#bcbcbc"
$TextboxInputHeader.AutoSize = $true
$TextboxInputHeader.Width = 25
$TextboxInputHeader.Height = 10
$TextboxInputHeader.Location = New-Object System.Drawing.Point(15, 63)
$TextboxInputHeader.Font = 'Microsoft Sans Serif,8,style=Bold'

$TextBoxInput = New-Object System.Windows.Forms.TextBox
$TextBoxInput.Location = New-Object System.Drawing.Point(20, 83)
$TextBoxInput.BackColor = "#eeeeee"
$TextBoxInput.Width = 400
$TextBoxInput.Height = 110
$TextBoxInput.Text = ""
$TextBoxInput.Multiline = $true
$TextBoxInput.Font = 'Microsoft Sans Serif,8,style=Bold'
$TextBoxInput.add_MouseHover($showhelp)
$TextBoxInput.name="message"

$ImageInputHeader = New-Object System.Windows.Forms.Label
$ImageInputHeader.Text = "Image Path"
$ImageInputHeader.ForeColor = "#bcbcbc"
$ImageInputHeader.AutoSize = $true
$ImageInputHeader.Width = 25
$ImageInputHeader.Height = 10
$ImageInputHeader.Location = New-Object System.Drawing.Point(15, 200)
$ImageInputHeader.Font = 'Microsoft Sans Serif,8,style=Bold'

$ImageInput = New-Object System.Windows.Forms.TextBox
$ImageInput.Location = New-Object System.Drawing.Point(20, 220)
$ImageInput.BackColor = "#eeeeee"
$ImageInput.Width = 400
$ImageInput.Height = 20
$ImageInput.Text = ""
$ImageInput.Multiline = $true
$ImageInput.Font = 'Microsoft Sans Serif,8,style=Bold'
$ImageInput.add_MouseHover($showhelp)
$ImageInput.name="imgpath"

$coolboxInputHeader = New-Object System.Windows.Forms.Label
$coolboxInputHeader.Text = "Cooldown"
$coolboxInputHeader.ForeColor = "#bcbcbc"
$coolboxInputHeader.AutoSize = $true
$coolboxInputHeader.Width = 25
$coolboxInputHeader.Height = 10
$coolboxInputHeader.Location = New-Object System.Drawing.Point(115, 245)
$coolboxInputHeader.Font = 'Microsoft Sans Serif,8,style=Bold'

$coolboxInput = New-Object System.Windows.Forms.TextBox
$coolboxInput.Location = New-Object System.Drawing.Point(120, 265)
$coolboxInput.BackColor = "#eeeeee"
$coolboxInput.Width = 60
$coolboxInput.Height = 40
$coolboxInput.Text = "700"
$coolboxInput.Multiline = $false
$coolboxInput.Font = 'Microsoft Sans Serif,8,style=Bold'
$coolboxInput.add_MouseHover($showhelp)
$coolboxInput.name="delay"

$amtboxInputHeader = New-Object System.Windows.Forms.Label
$amtboxInputHeader.Text = "Amount"
$amtboxInputHeader.ForeColor = "#bcbcbc"
$amtboxInputHeader.AutoSize = $true
$amtboxInputHeader.Width = 25
$amtboxInputHeader.Height = 10
$amtboxInputHeader.Location = New-Object System.Drawing.Point(15, 245)
$amtboxInputHeader.Font = 'Microsoft Sans Serif,8,style=Bold'

$amtBoxInput = New-Object System.Windows.Forms.TextBox
$amtBoxInput.Location = New-Object System.Drawing.Point(20, 265)
$amtBoxInput.BackColor = "#eeeeee"
$amtBoxInput.Width = 60
$amtBoxInput.Height = 40
$amtBoxInput.Text = "100"
$amtBoxInput.Multiline = $false
$amtBoxInput.Font = 'Microsoft Sans Serif,8,style=Bold'
$amtBoxInput.add_MouseHover($showhelp)
$amtBoxInput.name="amount"

$mstext = New-Object System.Windows.Forms.Label
$mstext.Text = "ms"
$mstext.ForeColor = "#bcbcbc"
$mstext.AutoSize = $true
$mstext.Width = 25
$mstext.Height = 10
$mstext.Location = New-Object System.Drawing.Point(185, 268)
$mstext.Font = 'Microsoft Sans Serif,8,style=Bold'

#==================================================== Define GUI Elements ==========================================================
    
$MainWindow.controls.AddRange(@($StartSpam, $ImageInput, $ImageInputHeader, $selimage, $URLBoxInput, $URLBoxInputHeader, $TextBoxInput, $coolboxInput, $amtBoxInput, $TextboxInputHeader, $coolboxInputHeader, $amtboxInputHeader, $mstext))

#==================================================== Click Functions ==========================================================

$StartSpam.Add_Click({

$hookurl = $URLBoxInput.Text 
$n = [int]$amtBoxInput.Text   
$c = [int]$coolBoxInput.Text
$i = 0

while($i -lt $n) {
$msgsys = $TextboxInput.Text
$escmsgsys = $msgsys -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
$jsonsys = @{"username" = "Spammer" ;"content" = $escmsgsys} | ConvertTo-Json
Start-Sleep -Milliseconds $c
Invoke-RestMethod -Uri $hookurl -Method Post -ContentType "application/json" -Body $jsonsys
$i++
}

$imageBytes = [System.IO.File]::ReadAllBytes($ImageInput.Text)
$b64 = [System.Convert]::ToBase64String($imageBytes)
$decodedFile = [System.Convert]::FromBase64String($b64)
$File = "$env:temp\bl.png"
Set-Content -Path $File -Value $decodedFile -Encoding Byte

while($i -lt $n) {
curl.exe -F "file1=@$file" $hookurl
$i++
}

Remove-Item -Path $file -Force
})


$selimage.Add_Click({

$FileDialog = New-Object Windows.Forms.OpenFileDialog
$FileDialog.Filter = "All Files (*.*)|*.*"

if ($FileDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
$SelectedFilePath = $FileDialog.FileName
$ImageInput.Text = $SelectedFilePath
}

})

$MainWindow.ShowDialog() | Out-Null
exit 
