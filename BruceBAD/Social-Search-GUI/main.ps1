Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName Microsoft.VisualBasic
[System.Windows.Forms.Application]::EnableVisualStyles()

$MainWindow = New-Object System.Windows.Forms.Form
$MainWindow.ClientSize = '690,700'
$MainWindow.Text = "| Beigetools | Social Search |"
$MainWindow.BackColor = "#242424"
$MainWindow.Opacity = 1
$MainWindow.TopMost = $true
$MainWindow.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\charmap.exe")

$TextInput = New-Object System.Windows.Forms.TextBox
$TextInput.Location = New-Object System.Drawing.Point(20, 40)
$TextInput.BackColor = "#eeeeee"
$TextInput.Width = 370
$TextInput.Height = 40
$TextInput.Font = 'Microsoft Sans Serif,12,style=Bold'
$TextInput.add_MouseHover($showhelp)
$TextInput.name="input"

$TextInputHeader = New-Object System.Windows.Forms.Label
$TextInputHeader.Text = "Username"
$TextInputHeader.ForeColor = "#bcbcbc"
$TextInputHeader.AutoSize = $true
$TextInputHeader.Width = 25
$TextInputHeader.Height = 10
$TextInputHeader.Location = New-Object System.Drawing.Point(20, 20)
$TextInputHeader.Font = 'Microsoft Sans Serif,10,style=Bold'

$OutputBoxHeader = New-Object System.Windows.Forms.Label
$OutputBoxHeader.Text = "Results"
$OutputBoxHeader.ForeColor = "#bcbcbc"
$OutputBoxHeader.AutoSize = $true
$OutputBoxHeader.Width = 25
$OutputBoxHeader.Height = 10
$OutputBoxHeader.Location = New-Object System.Drawing.Point(20, 90)
$OutputBoxHeader.Font = 'Microsoft Sans Serif,10,style=Bold'

$OutputBox = New-Object System.Windows.Forms.TextBox 
$OutputBox.Multiline = $True;
$OutputBox.Location = New-Object System.Drawing.Size(20,110) 
$OutputBox.Width = 650
$OutputBox.Height = 570
$OutputBox.Scrollbars = "Vertical" 
$OutputBox.Font = 'Microsoft Sans Serif,12,style=Bold'

$DecodeBT = New-Object System.Windows.Forms.Button
$DecodeBT.Text = "Start Search"
$DecodeBT.Width = 150
$DecodeBT.Height = 35
$DecodeBT.Location = New-Object System.Drawing.Point(520, 30)
$DecodeBT.Font = 'Microsoft Sans Serif,10,style=Bold'
$DecodeBT.BackColor = "#eeeeee"
$DecodeBT.add_MouseHover($showhelp)
$DecodeBT.name="decode"

$MainWindow.controls.AddRange(@($TextInput,$DecodeBT,$OutputBox,$TextInputHeader,$OutputBoxHeader))


$DecodeBT.Add_Click({

Function Add-OutputBoxLine{
    Param ($outfeed) 
    $OutputBox.AppendText("`r`n$outfeed")
    $OutputBox.Refresh()
    $OutputBox.ScrollToCaret()
}


$myArray = @(
"https://twitter.com/$userhandle",
"https://www.instagram.com/$userhandle/",
"https://ws2.kik.com/user/$userhandle/",
"https://medium.com/@$userhandle",
"https://pastebin.com/u/$userhandle/",
"https://www.patreon.com/$userhandle/",
"https://photobucket.com/user/$userhandle/library",
"https://www.pinterest.com/$userhandle/",
"https://myspace.com/$userhandle/",
"https://www.reddit.com/user/$userhandle/"
"https://2Dimensions.com/a/$userhandle"
"https://www.7cups.com/@$userhandle"
"https://www.9gag.com/u/$userhandle"
"https://about.me/$userhandle"
"https://independent.academia.edu/$userhandle"
"https://www.alik.cz/u/$userhandle"
"https://www.alltrails.com/members/$userhandle"
"https://www.anobii.com/$userhandle/profile"
"https://discussions.apple.com/profile/$userhandle"
"https://archive.org/details/@$userhandle"
"https://asciinema.org/~$userhandle"
"https://ask.fm/$userhandle"
"https://discuss.atom.io/u/$userhandle/summary"
"https://audiojungle.net/user/$userhandle"
"https://www.avizo.cz/$userhandle/"
"https://blip.fm/$userhandle"
"https://$userhandle.booth.pm/"
"https://www.behance.net/$userhandle"
"https://binarysearch.io/@/$userhandle"
"https://bitbucket.org/$userhandle/"
"https://$userhandle.blogspot.com"
"https://bodyspace.bodybuilding.com/$userhandle"
"https://www.bookcrossing.com/mybookshelf/$userhandle/"
"https://buzzfeed.com/$userhandle"
"https://www.cnet.com/profiles/$userhandle/"
"https://$userhandle.carbonmade.com"
"https://career.habr.com/$userhandle"
"https://beta.cent.co/@$userhandle"
"https://www.championat.com/user/$userhandle"
"https://www.chess.com/member/$userhandle"
"https://www.cloob.com/name/$userhandle"
"https://community.cloudflare.com/u/$userhandle"
"https://www.codecademy.com/profiles/$userhandle"
"https://www.codechef.com/users/$userhandle"
"https://www.codewars.com/users/$userhandle"
"https://www.colourlovers.com/lover/$userhandle"
"https://www.coroflot.com/$userhandle"
"https://www.countable.us/$userhandle"
"https://www.cracked.com/members/$userhandle/"
"https://$userhandle.crevado.com"
"https://dev.to/$userhandleali"
"https://www.dailymotion.com/$userhandle"
"https://www.designspiration.net/$userhandle/"
"https://$userhandle.deviantart.com"
"https://www.discogs.com/user/$userhandle"
"https://discuss.elastic.co/u/$userhandle"
"https://disqus.com/$userhandle"
"https://dribbble.com/$userhandle"
"https://www.duolingo.com/profile/$userhandle"
"https://ello.co/$userhandle"
"https://euw.op.gg/summoner/userName=$userhandle"
"https://www.eyeem.com/u/$userhandle"
"https://f3.cool/$userhandle/"
"https://www.facebook.com/$userhandle"
"https://facenama.com/$userhandle"
"https://www.flickr.com/people/$userhandle"
"https://flipboard.com/@$userhandle"
"https://fortnitetracker.com/profile/all/$userhandle"
"https://freelance.habr.com/freelancers/$userhandle"
"https://www.freelancer.com/api/users/0.1/users?usernames%5B%5D=$userhandle&compact=true"
"https://freesound.org/people/$userhandle/"
"https://www.gamespot.com/profile/$userhandle/"
"https://giphy.com/$userhandle"
"https://www.github.com/$userhandle"
"https://gitlab.com/$userhandle"
"https://gitee.com/$userhandle"
"http://en.gravatar.com/$userhandle"
"https://www.gumroad.com/$userhandle"
"https://gurushots.com/$userhandle/photos"
"https://hackaday.io/$userhandle"
"https://news.ycombinator.com/user?id=$userhandle"
"https://hackerone.com/$userhandle"
"https://hackerrank.com/$userhandle"
"https://www.house-mixes.com/profile/$userhandle"
"https://icq.im/$userhandle"
"https://www.ifttt.com/p/$userhandle"
"https://www.instructables.com/member/$userhandle"
"https://$userhandle.itch.io/"
"https://$userhandle.jimdosite.com"
"https://forums.kali.org/member.php?username=$userhandle"
"https://keybase.io/$userhandle"
"https://kik.me/$userhandle"
"https://www.linux.org.ru/people/$userhandle/profile"
"https://launchpad.net/~$userhandle"
"https://leetcode.com/$userhandle"
"https://letterboxd.com/$userhandle"
"https://lichess.org/@/$userhandle"
"https://$userhandle.livejournal.com"
"https://www.liveleak.com/c/$userhandle"
"https://lolchess.gg/profile/na/$userhandle"
"https://www.memrise.com/user/$userhandle/"
"https://www.mixcloud.com/$userhandle/"
"https://www.munzee.com/m/$userhandle"
"https://myanimelist.net/profile/$userhandle"
"https://www.myminifactory.com/users/$userhandle"
"https://myspace.com/$userhandle"
"https://www.native-instruments.com/forum/members?username=$userhandle"
"https://namemc.com/profile/$userhandle"
"https://blog.naver.com/$userhandle"
"https://$userhandle.newgrounds.com"
"https://notabug.org/$userhandle"
"https://www.openstreetmap.org/user/$userhandle"
"https://opensource.com/users/$userhandle"
"https://forums.pcgamer.com/members/?username=$userhandle"
"https://packagist.org/packages/$userhandle/"
"https://pastebin.com/u/$userhandle"
"https://www.patreon.com/$userhandle"
"https://www.periscope.tv/$userhandle/"
"https://www.pinkbike.com/u/$userhandle/"
"https://www.pinterest.com/$userhandle/"
"https://plug.dj/@/$userhandle"
"https://polarsteps.com/$userhandle"
"https://www.producthunt.com/@$userhandle"
"http://promodj.com/$userhandle"
"https://pypi.org/user/$userhandle"
"https://quizlet.com/$userhandle"
"https://raidforums.com/User-$userhandle"
"https://www.reddit.com/user/$userhandle"
"https://repl.it/@$userhandle"
"https://www.reverbnation.com/$userhandle"
"https://rubygems.org/profiles/$userhandle"
"https://www.scribd.com/$userhandle"
"https://$userhandle.slack.com"
"https://slashdot.org/~$userhandle"
"https://slideshare.net/$userhandle"
"https://soundcloud.com/$userhandle"
"https://sourceforge.net/u/$userhandle"
"https://www.sparkpeople.com/mypage.asp?id=$userhandle"
"https://speedrun.com/user/$userhandle"
"https://www.sporcle.com/user/$userhandle/people"
"https://open.spotify.com/user/$userhandle"
"https://robertsspaceindustries.com/citizens/$userhandle"
"https://steamcommunity.com/id/$userhandle"
"https://steamcommunity.com/groups/$userhandle"
"https://steamid.uk/profile/$userhandle"
"https://www.strava.com/athletes/$userhandle"
"https://forum.sublimetext.com/u/$userhandle"
"https://ch.tetr.io/u/$userhandle"
"https://tellonym.me/$userhandle"
"https://tiktok.com/@$userhandle"
"https://www.gotinder.com/@$userhandle"
"http://en.tm-ladder.com/$userhandle_rech.php"
"https://www.tradingview.com/u/$userhandle/"
"https://trello.com/$userhandle"
"https://tripadvisor.com/members/$userhandle"
"https://tryhackme.com/p/$userhandle"
"https://www.twitch.tv/$userhandle"
"https://ultimate-guitar.com/u/$userhandle"
"https://unsplash.com/@$userhandle"
"https://vsco.co/$userhandle"
"https://forum.velomania.ru/member.php?username=$userhandle"
"https://vero.co/$userhandle"
"https://vimeo.com/$userhandle"
"https://virgool.io/@$userhandle"
"https://www.virustotal.com/ui/users/$userhandle/trusted_users"
"https://www.warriorforum.com/members/$userhandle.html"
"https://weheartit.com/$userhandle"
"https://$userhandle.webnode.cz/"
"http://www.wikidot.com/user:info/$userhandle"
"https://www.wikipedia.org/wiki/User:$userhandle"
"https://community.windy.com/user/$userhandle"
"https://profiles.wordpress.org/$userhandle/"
"https://xboxgamertag.com/search/$userhandle"
"https://www.younow.com/$userhandle/"
"https://youpic.com/photographer/$userhandle/"
"https://www.youtube.com/$userhandle"
"https://www.zhihu.com/people/$userhandle"
"https://akniga.org/profile/$userhandle"
"https://allmylinks.com/$userhandle"
"https://aminoapps.com/u/$userhandle"
"http://www.authorstream.com/$userhandle/"
"https://www.couchsurfing.com/people/$userhandle"
"https://www.geocaching.com/p/default.aspx?u=$userhandle"
"https://gfycat.com/@$userhandle"
"https://www.hackster.io/$userhandle"
"https://www.interpals.net/$userhandle"
"http://www.jeuxvideo.com/profil/$userhandle?mode=infos"
"https://last.fm/user/$userhandle"
"https://forum.leasehackr.com/u/$userhandle/summary/"
"https://www.livelib.ru/reader/$userhandle"
"https://mastodon.cloud/@$userhandle"
"https://mastodon.social/@$userhandle"
"https://mastodon.technology/@$userhandle"
"https://mastodon.xyz/@$userhandle"
"https://www.mercadolivre.com.br/perfil/$userhandle"
"https://www.metacritic.com/user/$userhandle"
"https://mstdn.io/@$userhandle"
"https://www.nairaland.com/$userhandle"
"https://note.com/$userhandle"
"https://www.npmjs.com/~$userhandle"
"https://osu.ppy.sh/users/$userhandle"
"https://php.ru/forum/members/?username=$userhandle"
"https://pr0gramm.com/user/$userhandle"
"https://social.tchncs.de/@$userhandle"
"http://uid.me/$userhandle"
)

$userhandle = $TextInput.Text
Add-OutputBoxLine -outfeed "------------------------------------------------------------------------------"
Add-OutputBoxLine -outfeed "Searching Username:$userhandle Against Known Websites List..."
Add-OutputBoxLine -outfeed "------------------------------------------------------------------------------"

foreach ($i in $myArray) {
try{
    $response = Inv`o`ke-`W`ebR`e`qu`e`st -Uri "$i" -ErrorAction Stop
    $StatusCode = $Response.StatusCode
}catch{$StatusCode = $_.Exception.Response.StatusCode.value__}
if ($StatusCode -eq "200"){
        Add-OutputBoxLine -outfeed "Found one: $i$userhandle" 
}if ($StatusCode -eq "404"){}else {}}

})


 
$MainWindow.ShowDialog() | Out-Null
exit 