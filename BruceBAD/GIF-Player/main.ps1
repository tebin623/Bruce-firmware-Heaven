Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
 
$url = "https://media3.giphy.com/media/tJqyalvo9ahykfykAj/giphy.gif?ep=v1_gifs_search" # example GIF (replace with your own link)
$gifPath = "$env:temp/g.gif"
iwr -Uri $url -OutFile $gifPath
$ErrorActionPreference = 'Stop'

function Play-Gif {
    param(
        [string]$GifPath
    )

    $form = New-Object System.Windows.Forms.Form
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $timer = New-Object System.Windows.Forms.Timer

    $form.Text = "GIF Player"
    $form.Size = New-Object System.Drawing.Size(490, 300)
    $form.StartPosition = 'CenterScreen'
    $form.Topmost = $true

    $pictureBox.Size = $form.Size
    $pictureBox.Image = [System.Drawing.Image]::FromFile($GifPath)

    $timer.Interval = 50  # Adjust the interval as needed for desired animation speed
    $timer.Add_Tick({
        $pictureBox.Image.SelectActiveFrame([System.Drawing.Imaging.FrameDimension]::Time, $timer.Tag)
        $pictureBox.Refresh()
        $timer.Tag = ($timer.Tag + 1) % $pictureBox.Image.GetFrameCount([System.Drawing.Imaging.FrameDimension]::Time)
    })

    $timer.Tag = 0

    $form.Controls.Add($pictureBox)

    $form.Add_Shown({ $timer.Start() })

    $form.ShowDialog()
}

Play-Gif -GifPath $gifPath
sleep 1
Remove-Item $gifPath
