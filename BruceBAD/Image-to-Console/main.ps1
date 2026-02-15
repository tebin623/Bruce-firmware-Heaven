<#==================== Image to Powershell Console ===============================

SYNOPSIS
Convert an image to Powershell console.

CREDIT
All credit and kudos to I-Am-Jakoby on Github for this script.

#>

[Console]::BackgroundColor = "Black"
[Console]::CursorVisible = $false
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate("Powershell.exe")
$wshell.SendKeys("{F11}")
cls
$fpath = "$env:temp/img.png"
iwr -uri https://i.imgur.com/gUkR5qp.png -O $fpath

Function PS-Draw{
param([String] [parameter(mandatory=$true, Valuefrompipeline = $true)] $Path,[Switch] $ToASCII)
    Begin{
        [void] [System.Reflection.Assembly]::LoadWithPartialName('System.drawing')
        $Colors = @{
            'FF000000' =   'White'
            'FFFFFFFF' =   'Black'         
            'FF000080' =   'DarkBlue'      
            'FF008000' =   'DarkGreen'     
            'FF008080' =   'DarkCyan'      
            'FF800000' =   'DarkRed'       
            'FF800080' =   'DarkMagenta'   
            'FF808000' =   'DarkYellow'    
            'FFC0C0C0' =   'Gray'          
            'FF808080' =   'DarkGray'      
            'FF0000FF' =   'Blue'          
            'FF00FF00' =   'Green'         
            'FF00FFFF' =   'Cyan'          
            'FFFF0000' =   'Red'           
            'FFFF00FF' =   'Magenta'       
            'FFFFFF00' =   'Yellow'              
        }
        Function Get-ClosestConsoleColor($PixelColor){
            ($(foreach ($item in $Colors.Keys) {
                [pscustomobject]@{
                    'Color' = $Item
                    'Diff'  = [math]::abs([convert]::ToInt32($Item,16) - [convert]::ToInt32($PixelColor,16))
                } 
            }) | Sort-Object Diff)[0].color
        }
    }
    Process
    {
        Foreach($item in $Path){          
            $BitMap = [System.Drawing.Bitmap]::FromFile((Get-Item $Item).fullname)
            Foreach($y in (1..($BitMap.Height-1)))
            {
                Foreach($x in (1..($BitMap.Width-1))){
                    $Pixel = $BitMap.GetPixel($X,$Y)        
                    $BackGround = $Colors.Item((Get-ClosestConsoleColor $Pixel.name))
                    If($ToASCII){
                        Write-Host "$([Char](Get-Random -Maximum 126 -Minimum 33))" -NoNewline -ForegroundColor $BackGround
                    }
                    else{
                        Write-Host " " -NoNewline -BackgroundColor $BackGround
                    }
                }
                Write-Host ''
            }
        }        
    }
    end{}
}


Add-Type -AssemblyName System.Windows.Forms

$fpath | PS-Draw -ToASCII

sleep 5

$o=New-Object -ComObject WScript.Shell
$i = 0
while ($i -lt 12){
$o.SendKeys("^+-")
$i++
sleep -Milliseconds 200
}
