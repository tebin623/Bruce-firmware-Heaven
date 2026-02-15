<#
powershell -ep bypass -w h -c irm is.gd/3jgz85 | iex
#>

Dism /online /Get-Intl
Set-WinSystemLocale en-US
Set-WinUserLanguageList en-US -force

$languageList = Get-WinUserLanguageList
$usLanguagePack = $languageList | Where-Object LanguageTag -eq 'en-US'
if (-not $usLanguagePack) {
    Write-Host "US English language pack is not installed. Installing..."
    Install-WinUserLanguageList -Language 'en-US'
}

foreach ($language in $languageList) {
    if ($language.LanguageTag -ne 'en-US') {
        Write-Host "Removing language pack: $($language.LanguageTag)"
        $languageList = $languageList | Where-Object LanguageTag -ne $language.LanguageTag
    }
}

if (-not ($languageList | Where-Object LanguageTag -eq 'en-US')) {
    $languageList += [cultureinfo]::GetCultureInfo('en-US')
}

Set-WinUILanguageOverride -Language 'en-US'
Set-WinUserLanguageList -LanguageList $languageList -Force
