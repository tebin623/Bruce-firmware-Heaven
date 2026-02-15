$url = "https://i.ibb.co/XJSPt9s/1.png"
$outputPath = "$env:temp\img.jpg"
$wallpaperStyle = 2  # 0: Tiled, 1: Centered, 2: Stretched

IWR -Uri $url -OutFile $outputPath

$signature = @'
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@

Add-Type -TypeDefinition $signature

$SPI_SETDESKWALLPAPER = 0x0014
$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDCHANGE = 0x02

[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $outputPath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)
