<# ===================== VOICE ACTIVATED DARK/LIGHT MODE ======================

SYNOPSIS
Control Windows theme with your voice.
Say 'Light' OR 'Dark' to change theme.

#>

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

while ($true) {    
    Add-Type -AssemblyName System.Speech
    $speech = New-Object System.Speech.Recognition.SpeechRecognitionEngine
    $grammar = New-Object System.Speech.Recognition.DictationGrammar
    $speech.LoadGrammar($grammar)
    $speech.SetInputToDefaultAudioDevice()
    $result = $speech.Recognize()
    $Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    if ($result) {
        $text = $result.Text
        Write-Output $text

        if ($text -match 'Dark'){
            Write-Host "Set Dark Theme"
            Set-ItemProperty $Theme AppsUseLightTheme -Value 0
            Set-ItemProperty $Theme SystemUsesLightTheme -Value 0
        }
        if ($text -match 'Light'){
            Set-ItemProperty $Theme AppsUseLightTheme -Value 1
            Set-ItemProperty $Theme SystemUsesLightTheme -Value 1
            Write-Host "Set Light Theme"
        }
    }
}