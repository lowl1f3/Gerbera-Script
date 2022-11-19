<#
	.SYNOPSIS
	A PowerShell script for Windows that automates the installation and configuration of the latest versions of programs
	
	Copyright (c) 2022 lowl1f3
	
	.NOTES
	Supported Windows 10 & 11 versions
	
	.LINK GitHub
	https://github.com/lowl1f3/Script
	
	.LINK Telegram
	https://t.me/lowlif3
	
	.LINK Discord
	https://discord.com/users/330825971835863042
	
	.NOTES
	https://github.com/farag2/Office
	https://github.com/farag2/Sophia-Script-for-Windows
	
	.LINK Author
	https://github.com/lowl1f3
#>

$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
if (-not $IsAdmin)
{
	Start-Process -FilePath powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoProfile -NoLogo -File `"$PSCommandPath`"" -Verb Runas
	exit
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"

Write-Verbose -Message "Installing Telegram..." -Verbose
# Get the latest Telegram Desktop version
# https://github.com/telegramdesktop/tdesktop/releases
$Parameters = @{
	Uri             = "https://api.github.com/repos/telegramdesktop/tdesktop/releases/latest"
	UseBasicParsing = $true
	Verbose         = $true
}
$LatestTelegramTag = (Invoke-RestMethod @Parameters).tag_name.replace("v", "")

# Downloading the latest Telegram Desktop
$Parameters = @{
	Uri             = "https://updates.tdesktop.com/tsetup/tsetup.$($LatestTelegramTag).exe"
	OutFile         = "$DownloadsFolder\TelegramSetup.$($latestTelegramTag).exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\TelegramSetup.$($latestTelegramTag).exe" -ArgumentList "/VERYSILENT" -Wait 

Remove-Item -Path "$DownloadsFolder\TelegramSetup.$($latestTelegramTag).exe" -Force

# Adding to the Windows Defender Firewall exclusion list
New-NetFirewallRule -DisplayName "Telegram" -Direction Inbound -Program "$env:APPDATA\Telegram Desktop\Telegram.exe" -Action Allow
New-NetFirewallRule -DisplayName "Telegram" -Direction Outbound -Program "$env:APPDATA\Telegram Desktop\Telegram.exe" -Action Allow

Write-Verbose -Message "Installing Discord..." -Verbose
# Downloading the latest Discord
# https://discord.com/
$Parameters = @{
	Uri             = "https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x86"
	OutFile         = "$DownloadsFolder\DiscordSetup.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\DiscordSetup.exe"

# Adding to the Windows Defender Firewall exclusion list
New-NetFirewallRule -DisplayName "Discord" -Direction Inbound -Program "$env:APPDATA\Local\Discord\Update.exe" -Action Allow
New-NetFirewallRule -DisplayName "Discord" -Direction Outbound -Program "$env:APPDATA\Local\Discord\Update.exe" -Action Allow

Write-Verbose -Message "Installing Better Discord..." -Verbose
# Downloading the latest BetterDiscord
# https://github.com/BetterDiscord/Installer/releases
$Parameters = @{
	Uri             = "https://api.github.com/repos/BetterDiscord/Installer/releases"
	UseBasicParsing = $true
	Verbose         = $true
}
$LatestBetterDiscordTag = (Invoke-RestMethod @Parameters).tag_name | Select-Object -Index 0

$Parameters = @{
	Uri             = "https://github.com/BetterDiscord/Installer/releases/download/$($LatestBetterDiscordTag)/BetterDiscord-Windows.exe"
	OutFile         = "$DownloadsFolder\BetterDiscordSetup.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Write-Warning "Close Discord process manually after installing BetterDiscord."

Start-Process -FilePath "$DownloadsFolder\BetterDiscordSetup.exe" -Wait

Stop-Process -Name BetterDiscord -Force -ErrorAction Ignore

Remove-Item -Path "$DownloadsFolder\BetterDiscordSetup.exe" -Force
Remove-Item -Path "$DownloadsFolder\DiscordSetup.exe" -Force

Write-Verbose -Message "Installing Better Discord plugins..." -Verbose
# Installing Better Discord plugins
$Plugins = @(
	# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Library/0BDFDB.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js",
	
	# https://github.com/rauenzi/BDPluginLibrary/blob/master/release/0PluginLibrary.plugin.js
	"https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/ReadAllNotificationsButton/ReadAllNotificationsButton.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ReadAllNotificationsButton/ReadAllNotificationsButton.plugin.js",
	
	# https://github.com/rauenzi/BetterDiscordAddons/blob/master/Plugins/DoNotTrack/DoNotTrack.plugin.js
	"https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js",
	
	# https://github.com/rauenzi/BetterDiscordAddons/blob/master/Plugins/HideDisabledEmojis/HideDisabledEmojis.plugin.js
	"https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/HideDisabledEmojis/HideDisabledEmojis.plugin.js",
	
	# https://github.com/oSumAtrIX/BetterDiscordPlugins/blob/master/NitroEmoteAndScreenShareBypass.plugin.js
	"https://raw.githubusercontent.com/oSumAtrIX/BetterDiscordPlugins/master/NitroEmoteAndScreenShareBypass.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/BetterFriendList/BetterFriendList.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/BetterFriendList/BetterFriendList.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/BetterNsfwTag/BetterNsfwTag.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/BetterNsfwTag/BetterNsfwTag.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/BetterSearchPage/BetterSearchPage.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/BetterSearchPage/BetterSearchPage.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/CharCounter/CharCounter.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/CharCounter/CharCounter.plugin.js",
	
	# https://github.com/An00nymushun/DiscordFreeEmojis/blob/master/DiscordFreeEmojis64px.plugin.js
	"https://raw.githubusercontent.com/An00nymushun/DiscordFreeEmojis/master/DiscordFreeEmojis64px.plugin.js",
	
	# https://github.com/Farcrada/DiscordPlugins/blob/master/Double-click-to-edit/DoubleClickToEdit.plugin.js
	"https://raw.githubusercontent.com/Farcrada/DiscordPlugins/master/Double-click-to-edit/DoubleClickToEdit.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/ImageUtilities/ImageUtilities.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ImageUtilities/ImageUtilities.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/PluginRepo/PluginRepo.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/PluginRepo/PluginRepo.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/SplitLargeMessages/SplitLargeMessages.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/SplitLargeMessages/SplitLargeMessages.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/tree/master/Plugins/SpotifyControls/SpotifyControls.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/SpotifyControls/SpotifyControls.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/tree/master/Plugins/StaffTag/StaffTag.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/StaffTag/StaffTag.plugin.js",
	
	# https://github.com/mwittrien/BetterDiscordAddons/tree/master/Plugins/ThemeRepo/ThemeRepo.plugin.js
	"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ThemeRepo/ThemeRepo.plugin.js",
	
	# https://github.com/QWERTxD/BetterDiscordPlugins/blob/main/CallTimeCounter/CallTimeCounter.plugin.js
	"https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/CallTimeCounter/CallTimeCounter.plugin.js",
	
	# https://github.com/bepvte/bd-addons/blob/main/plugins/NoSpotifyPause.plugin.js
	"https://raw.githubusercontent.com/bepvte/bd-addons/main/plugins/NoSpotifyPause.plugin.js",
	
	# https://github.com/l0c4lh057/BetterDiscordStuff/blob/master/Plugins/TypingIndicator/TypingIndicator.plugin.js
	"https://raw.githubusercontent.com/l0c4lh057/BetterDiscordStuff/master/Plugins/TypingIndicator/TypingIndicator.plugin.js",
	
	# https://github.com/QWERTxD/BetterDiscordPlugins/blob/main/TypingUsersAvatars/TypingUsersAvatars.plugin.js
	"https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/TypingUsersAvatars/TypingUsersAvatars.plugin.js",
	
	# https://github.com/TheGreenPig/BetterDiscordPlugins/blob/main/FileViewer/FileViewer.plugin.js
	"https://raw.githubusercontent.com/TheGreenPig/BetterDiscordPlugins/main/FileViewer/FileViewer.plugin.js",
	
	# https://github.com/unknown81311/BetterMediaPlayer/blob/main/BetterMediaPlayer.plugin.js
	"https://raw.githubusercontent.com/unknown81311/BetterMediaPlayer/main/BetterMediaPlayer.plugin.js"	
)
foreach ($Plugin in $Plugins)
{
	if ($(Split-Path -Path $Plugin -Leaf))
	{
		$Parameters = @{
			Uri             = $Plugin
			OutFile         = "$env:APPDATA\BetterDiscord\plugins\$(Split-Path -Path $Plugin -Leaf)"
			UseBasicParsing = $true
			Verbose         = $true
		}
	}
	Invoke-Webrequest @Parameters
}

Write-Verbose -Message "Installing Steam..." -Verbose
# Downloading the latest Steam
# https://store.steampowered.com/about/
$Parameters = @{
	Uri             = "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe"
	OutFile         = "$DownloadsFolder\SteamSetup.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\SteamSetup.exe" -ArgumentList "/S" -Wait

Remove-Item -Path "$DownloadsFolder\SteamSetup.exe" -Force

# Configuring Steam
if (Test-Path -Path "${env:ProgramFiles(x86)}\Steam")
{
	if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam.lnk"))
	{
		Copy-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force
	}
	Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Steam" -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam" -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path "$env:PUBLIC\Desktop\Steam.lnk" -Force -ErrorAction Ignore
	Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name Steam -Force -ErrorAction Ignore
}

# Adding to the Windows Defender Firewall exclusion list
New-NetFirewallRule -DisplayName "Steam" -Direction Inbound -Program "${env:ProgramFiles(x86)}\Common Files\Steam\steam.exe" -Action Allow
New-NetFirewallRule -DisplayName "Steam" -Direction Outbound -Program "${env:ProgramFiles(x86)}\Common Files\Steam\steam.exe" -Action Allow

Write-Verbose -Message "Installing Google Chrome Enterprise..." -Verbose
# Downloading the latest Chrome Enterprise x64
# https://chromeenterprise.google/browser/download
$Parameters = @{
	Uri     = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
	OutFile = "$DownloadsFolder\googlechromestandaloneenterprise64.msi"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\googlechromestandaloneenterprise64.msi" -ArgumentList "/passive" -Wait

Remove-Item -Path "$DownloadsFolder\googlechromestandaloneenterprise64.msi" -Force

# Adding to the Windows Defender Firewall exclusion list
New-NetFirewallRule -DisplayName "Google Chrome" -Direction Inbound -Program "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" -Action Allow
New-NetFirewallRule -DisplayName "Google Chrome" -Direction Outbound -Program "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" -Action Allow

Write-Verbose -Message "Installing 7-Zip..." -Verbose
# Get the latest 7-Zip download URL
$Parameters = @{
	Uri             = "https://sourceforge.net/projects/sevenzip/best_release.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$bestRelease = (Invoke-RestMethod @Parameters).platform_releases.windows.filename.replace("exe", "msi")

# Downloading the latest 7-Zip x64
$Parameters = @{
	Uri             = "https://nchc.dl.sourceforge.net/project/sevenzip$($bestRelease)"
	OutFile         = "$DownloadsFolder\7Zip.msi"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\7Zip.msi" -ArgumentList "/passive" -Wait

Remove-Item -Path "$DownloadsFolder\7Zip.msi" -Force

# Configuring 7Zip
if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip File Manager.lnk"))
{
	Copy-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip\7-Zip File Manager.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip" -Recurse -Force
}

if (-not (Test-Path -Path HKCU:\SOFTWARE\7-Zip\Options))
{
	New-Item -Path HKCU:\SOFTWARE\7-Zip\Options -Force
}
New-ItemProperty -Path HKCU:\SOFTWARE\7-Zip\Options -Name ContextMenu -PropertyType DWord -Value 4192 -Force
New-ItemProperty -Path HKCU:\SOFTWARE\7-Zip\Options -Name MenuIcons -PropertyType DWord -Value 1 -Force

Write-Verbose -Message "Installing custom cursor..." -Verbose
# Installing custom cursor
# https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356
$Parameters = @{
	Uri             = "https://github.com/farag2/Utilities/raw/master/Download/Cursor/dark.zip"
	OutFile         = "$DownloadsFolder\dark.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

if (-not (Test-Path -Path "$env:SystemRoot\Cursors\Windows_11_dark_v2"))
{
	New-Item -Path "$env:SystemRoot\Cursors\Windows_11_dark_v2" -ItemType Directory -Force
}

$Parameters = @{
	Path            = "$DownloadsFolder\dark.zip"
	DestinationPath = "$env:SystemRoot\Cursors\Windows_11_dark_v2"
	Force           = $true
	Verbose         = $true
}
Expand-Archive @Parameters

Remove-Item -Path "$DownloadsFolder\dark.zip" -Force

New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "(default)" -PropertyType String -Value "Windows 11 Cursors Dark v2 by Jepri Creations" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name AppStarting -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\working.ani" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Arrow -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\pointer.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name ContactVisualization -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Crosshair -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\precision.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name CursorBaseSize -PropertyType DWord -Value 32 -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name GestureVisualization -PropertyType DWord -Value 31 -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Hand -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\link.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Help -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\help.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name IBeam -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\beam.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name No -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\unavailable.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name NWPen -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\handwriting.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Person -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\pin.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Pin -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\person.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name precisionhair -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\precision.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "Scheme Source" -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeAll -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\move.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNESW -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\dgn2.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNS -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\vert.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNWSE -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\dgn1.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeWE -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\horz.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name UpArrow -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\alternate.cur" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Wait -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\busy.ani" -Force

if (-not (Test-Path -Path "HKCU:\Control Panel\Cursors\Schemes"))
{
	New-Item -Path "HKCU:\Control Panel\Cursors\Schemes" -Force
}
New-ItemProperty -Path "HKCU:\Control Panel\Cursors\Schemes" -Name "Windows 11 Cursors Dark v2 by Jepri Creations" -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\pointer.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\help.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\working.ani,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\busy.ani,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\precision.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\beam.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\handwriting.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\unavailable.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\vert.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\horz.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\dgn1.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\dgn2.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\move.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\alternate.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\link.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\person.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\pin.cur" -Force

# Reload custom cursor on-the-fly
$Signature = @{
	Namespace        = "WinAPI"
	Name             = "SystemParamInfo"
	Language         = "CSharp"
	MemberDefinition = @"
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
"@
}
if (-not ("WinAPI.SystemParamInfo" -as [type]))
{
	Add-Type @Signature
}
[WinAPI.SystemParamInfo]::SystemParametersInfo(0x0057, 0, $null, 0)

Write-Verbose -Message "Installing Notepad++..." -Verbose
# Get the latest Notepad++
# https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest
$Parameters = @{
	Uri             = "https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest"
	UseBasicParsing = $true
	Verbose         = $true
}
$LatestNotepadPlusPlusTag = (Invoke-RestMethod @Parameters).tag_name | Select-Object -Index 0
$LatestVersion = (Invoke-RestMethod @Parameters).tag_name.replace("v", "") | Select-Object -Index 0

# Downloading the latest Notepad++
# https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/
$Parameters = @{
	Uri             = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/$($LatestNotepadPlusPlusTag)/npp.$($LatestVersion).Installer.x64.exe"
	OutFile         = "$DownloadsFolder\NotepadPlusPlus.$($LatestNotepadPlusPlusTag).exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\NotepadPlusPlus.$($LatestNotepadPlusPlusTag).exe" -ArgumentList "/S" -Wait

Remove-Item -Path "$DownloadsFolder\NotepadPlusPlus.$($LatestNotepadPlusPlusTag).exe" -Force

Write-Warning -Message "Close Notepad++' window manually"
Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe" -Wait

# Configuring Notepad++
if (Test-Path -Path "$env:ProgramFiles\Notepad++")
{
	if (-not (Test-Path -Path "$env:APPDATA\Notepad++\config.xml"))
	{
		Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe"
		Write-Verbose -Message "`"$env:ProgramFiles\Notepad++\notepad++.exe`" doesn't exist. Re-run the script" -Verbose
		break
	}
	Stop-Process -Name notepad++ -Force -ErrorAction Ignore
	$Remove = @(
		"$env:ProgramFiles\Notepad++\change.log",
		"$env:ProgramFiles\Notepad++\LICENSE",
		"$env:ProgramFiles\Notepad++\readme.txt",
		"$env:ProgramFiles\Notepad++\autoCompletion",
		"$env:ProgramFiles\Notepad++\plugins"
		"$env:ProgramFiles\Notepad++\autoCompletion"
	)
	Remove-Item -Path $Remove -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path "$env:ProgramFiles\Notepad++\localization" -Exclude russian.xml -Recurse -Force -ErrorAction Ignore
	if ((Get-WinSystemLocale).Name -eq "ru-RU")
	{
		if ($Host.Version.Major -eq 5)
		{
			New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\CLSID\{B298D29A-A6ED-11DE-BA8C-A68E55D89593}\Settings" -Name Title -PropertyType String -Value "Открыть с помощью &Notepad++" -Force
		}
	}
	New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -Name "C:\Program Files\Notepad++\notepad++.exe.FriendlyAppName" -PropertyType String -Value "Notepad++" -Force
	cmd.exe --% /c ftype txtfile=%ProgramFiles%\Notepad++\notepad++.exe "%1"
	cmd.exe --% /c assoc .cfg=txtfile
	cmd.exe --% /c assoc .ini=txtfile
	cmd.exe --% /c assoc .log=txtfile
	cmd.exe --% /c assoc .nfo=txtfile
	cmd.exe --% /c assoc .ps1=txtfile
	cmd.exe --% /c assoc .xml=txtfile
	cmd.exe --% /c assoc txtfile\DefaultIcon=%ProgramFiles%\Notepad++\notepad++.exe,0
	# It is needed to use -Wait to make Notepad++ apply written settings
	Write-Warning -Message "Close Notepad++' window manually"
	Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe" -ArgumentList "$env:APPDATA\Notepad++\config.xml" -Wait
	[xml]$config = Get-Content -Path "$env:APPDATA\Notepad++\config.xml" -Force
	# Fluent UI: large
	$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "ToolBar"} | ForEach-Object -Process {$_."#text" = "large"}
	# Mute all sounds
	$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "MISC"} | ForEach-Object -Process {$_.muteSounds = "yes"}
	# Show White Space and TAB
	$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "ScintillaPrimaryView"} | ForEach-Object -Process {$_.whiteSpaceShow = "show"}
	# 2 find buttons mode
	$config.NotepadPlus.FindHistory | ForEach-Object -Process {$_.isSearch2ButtonsMode = "yes"}
	# Wrap around
	$config.NotepadPlus.FindHistory | ForEach-Object -Process {$_.wrap = "yes"}
	# Disable creating backups
	$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "Backup"} | ForEach-Object -Process {$_.action = "0"}
	$config.Save("$env:APPDATA\Notepad++\config.xml")
	Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe" -ArgumentList "$env:APPDATA\Notepad++\config.xml" -Wait
	Start-Sleep -Seconds 1
	Stop-Process -Name notepad++ -ErrorAction Ignore
}

Write-Verbose -Message "Installing Visual Stutio Code..." -Verbose
# Downloading the latest Visual Stutio Code
# https://code.visualstudio.com/download
$Parameters = @{
	Uri             = "https://az764295.vo.msecnd.net/stable/8fa188b2b301d36553cbc9ce1b0a146ccb93351f/VSCodeUserSetup-x64-1.73.0.exe"
	OutFile         = "$DownloadsFolder\VisualStutioCode.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\VisualStutioCode.exe" -ArgumentList "/S" -Wait

Remove-Item -Path "$DownloadsFolder\VisualStutioCode.exe" -Force

Write-Verbose -Message "Installing TeamSpeak 3..." -Verbose
# Downloading the latest TeamSpeak 3 x64
# https://www.teamspeak.com/en/downloads/#
$Parameters = @{
	Uri             = "https://files.teamspeak-services.com/releases/client/3.5.6/TeamSpeak3-Client-win64-3.5.6.exe"
	OutFile         = "$DownloadsFolder\TeamSpeakSetup.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\TeamSpeakSetup.exe" -ArgumentList "/S" -Wait

Remove-Item -Path "$DownloadsFolder\TeamSpeakSetup.exe" -Force

# Adding to the Windows Defender Firewall exclusion list
New-NetFirewallRule -DisplayName "TeamSpeak 3" -Direction Inbound -Program "$env:ProgramFiles\TeamSpeak 3 Client\ts3client_win64.exee" -Action Allow
New-NetFirewallRule -DisplayName "TeamSpeak 3" -Direction Outbound -Program "$env:ProgramFiles\TeamSpeak 3 Client\ts3client_win64.exe" -Action Allow

Write-Verbose -Message "Installing qBittorrent..." -Verbose
# Get the latest qBittorrent x64
$Parameters = @{
	Uri             = "https://sourceforge.net/projects/qbittorrent/best_release.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$bestRelease = (Invoke-RestMethod @Parameters).platform_releases.windows.filename

# Downloading the latest approved by maintainer qBittorrent x64
# For example 4.4.3 e.g., not 4.4.3.1 
$Parameters = @{
	Uri             = "https://nchc.dl.sourceforge.net/project/qbittorrent$($bestRelease)"
	OutFile         = "$DownloadsFolder\qBittorrentSetup.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\qBittorrentSetup.exe" -ArgumentList "/S" -Wait

Remove-Item -Path "$DownloadsFolder\qBittorrentSetup.exe" -Force

# Configuring qBittorrent
if (Test-Path -Path "$env:ProgramFiles\qBittorrent")
{
	Stop-Process -Name qBittorrent -Force -ErrorAction Ignore
	if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\qBittorrent.lnk"))
	{
		Copy-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\qBittorrent\qBittorrent.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force
	}
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\qBittorrent" -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path "$env:ProgramFiles\qBittorrent\translations" -Exclude qt_ru.qm, qtbase_ru.qm -Recurse -Force -ErrorAction Ignore
	$Parameters = @{
		Uri             = "https://raw.githubusercontent.com/farag2/Utilities/master/qBittorrent/qBittorrent.ini"
		OutFile         = "$env:APPDATA\qBittorrent\qBittorrent.ini"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	$LatestVersion = (Invoke-RestMethod -Uri "https://api.github.com/repos/jagannatharjun/qbt-theme/releases/latest").assets.browser_download_url
	$Parameters = @{
		Uri             = "https://api.github.com/repos/jagannatharjun/qbt-theme/releases/latest"
		UseBasicParsing = $true
		Verbose         = $true
	}
	$LatestVersion = (Invoke-RestMethod @Parameters).assets.browser_download_url

	$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
	$Parameters = @{
		Uri     = $LatestVersion
		OutFile = "$DownloadsFolder\qbt-theme.zip"
		Verbose = $true
	}
	Invoke-WebRequest @Parameters
	<#
		.SYNOPSIS
		Expand the specific file from ZIP archive. Folder structure will be created recursively
		.Parameter Source
		The source ZIP archive
		.Parameter Destination
		Where to expand file
		.Parameter File
		Assign the file to expand
		.Example
		ExtractZIPFile -Source "D:\Folder\File.zip" -Destination "D:\Folder" -File "Folder1/Folder2/File.txt"
	#>
	function ExtractZIPFile
	{
		[CmdletBinding()]
		param
		(
			[string]
			$Source,
			[string]
			$Destination,
			[string]
			$File
		)
		Add-Type -Assembly System.IO.Compression.FileSystem
		$ZIP = [IO.Compression.ZipFile]::OpenRead($Source)
		$Entries = $ZIP.Entries | Where-Object -FilterScript {$_.FullName -eq $File}
		$Destination = "$Destination\$(Split-Path -Path $File -Parent)"
		if (-not (Test-Path -Path $Destination))
		{
			New-Item -Path $Destination -ItemType Directory -Force
		}
		$Entries | ForEach-Object -Process {[IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$($Destination)\$($_.Name)", $true)}
		$ZIP.Dispose()
	}
	$Parameters = @{
		Source      = "$DownloadsFolder\qbt-theme.zip"
		Destination = "$env:APPDATA\qBittorrent"
		File        = "darkstylesheet.qbtheme"
	}
	ExtractZIPFile @Parameters
	Remove-Item -Path "$DownloadsFolder\qbt-theme.zip" -Force
	# Enable dark theme
	$qbtheme = (Resolve-Path -Path "$env:APPDATA\qBittorrent\darkstylesheet.qbtheme").Path.Replace("\", "/")
	# Save qBittorrent.ini in UTF8-BOM encoding to make it work with non-latin usernames
	(Get-Content -Path "$env:APPDATA\qBittorrent\qBittorrent.ini" -Encoding UTF8) -replace "General\\CustomUIThemePath=", "General\CustomUIThemePath=$qbtheme" | Set-Content -Path "$env:APPDATA\qBittorrent\qBittorrent.ini" -Encoding UTF8 -Force
	# Add to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "qBittorent" -Direction Inbound -Program "$env:ProgramFiles\qBittorrent\qbittorrent.exe" -Action Allow
	New-NetFirewallRule -DisplayName "qBittorent" -Direction Outbound -Program "$env:ProgramFiles\qBittorrent\qbittorrent.exe" -Action Allow
}

Write-Verbose -Message "Installing Office..." -Verbose
# Downloading the latest Office
Start-Process -FilePath powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoProfile -NoLogo -File `"$DownloadsFolder\Script-main\src\Office\Download.ps1`"" -Verb Runas -Wait

# Configuring Office
if (Test-Path -Path "$env:ProgramFiles\Microsoft Office\root")
{
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office Tools" -Recurse -Force -ErrorAction Ignore
}

Write-Verbose -Message "Installing KMS..." -Verbose
# Downloading the KMS
# https://www.mediafire.com/file/fhd1e21ghumvx89/KMS.zip
$Parameters = @{
	Uri             = "https://www.mediafire.com/file/fhd1e21ghumvx89/KMS.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
$URL = ((Invoke-Webrequest @Parameters).Links | Where-Object -FilterScript {$_.id -eq "downloadButton"}).href

$Parameters = @{
	Uri             = $URL
	OutFile         = "$DownloadsFolder\KMS.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

$Parameters = @{
	Path            = "$DownloadsFolder\KMS.zip"
	DestinationPath = "$DownloadsFolder"
	Force           = $true
	Verbose         = $true
}
Expand-Archive @Parameters

# Adding to the Windows Defender exclusion list
Set-MpPreference -ExclusionPath "$DownloadsFolder\KMS\"

Start-Process -FilePath "$DownloadsFolder\KMS\KMSAuto x64.exe" -Wait

Remove-Item -Path "$DownloadsFolder\KMS.zip", "$DownloadsFolder\KMS" -Recurse -Force

Write-Verbose -Message "Installing Adobe Creative Cloud..." -Verbose
# Downloading the latest Adobe Creative Cloud
# https://creativecloud.adobe.com/en/apps/download/creative-cloud
$Parameters = @{
	Uri             = "https://prod-rel-ffc-ccm.oobesaas.adobe.com/adobe-ffc-external/core/v1/wam/download?sapCode=KCCC&productName=Creative%20Cloud&os=win"
	OutFile         = "$DownloadsFolder\CreativeCloudSetUp.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\CreativeCloudSetUp.exe" -ArgumentList "SILENT" -Wait

Remove-Item -Path "$DownloadsFolder\CreativeCloudSetUp.exe" -Force

Write-Verbose -Message "Installing GenP..." -Verbose
# Downloading the Adobe GenP 2.7
# https://www.mediafire.com/file/3lpsrxiz47mlhu2/Adobe-GenP-2.7.zip
$Parameters = @{
	Uri             = "https://www.mediafire.com/file/3lpsrxiz47mlhu2/Adobe-GenP-2.7.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
$URL = ((Invoke-Webrequest @Parameters).Links | Where-Object -FilterScript {$_.id -eq "downloadButton"}).href

$Parameters = @{
	Uri             = $URL
	OutFile         = "$DownloadsFolder\AdobeGenP.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

$Parameters = @{
	Path            = "$DownloadsFolder\AdobeGenP.zip"
	DestinationPath = "$DownloadsFolder\"
	Force           = $true
	Verbose         = $true
}
Expand-Archive @Parameters

# Adding to the Windows Defender exclusion list
Set-MpPreference -ExclusionPath "$DownloadsFolder\Adobe-GenP-2.7\"

Start-Process -FilePath "$DownloadsFolder\Adobe-GenP-2.7\RunMe.exe" -Wait

Remove-Item -Path "$DownloadsFolder\AdobeGenP.zip", "$DownloadsFolder\Adobe-GenP-2.7" -Recurse -Force

Write-Verbose -Message "Installing latest Java 8(JRE) x64..." -Verbose
# Downloading the latest Java 8(JRE) x64
# https://www.java.com/download/ie_manual.jsp
$Parameters = @{
	Uri             = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=247106_10e8cce67c7843478f41411b7003171c"
	OutFile         = "$DownloadsFolder\Java 8(JRE) for Windows x64.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\Java 8(JRE) for Windows x64.exe" -ArgumentList "INSTALL_SILENT=1" -Wait

Remove-Item -Path "$DownloadsFolder\Java 8(JRE) for Windows x64.exe" -Force

# Configuring Java 8(JRE)
New-NetFirewallRule -DisplayName "Java 8(JRE)" -Direction Inbound -Program "$env:ProgramFiles\Java\jdk1.8.0_351\bin\javaw.exe" -Action Allow
New-NetFirewallRule -DisplayName "Java 8(JRE)" -Direction Outbound -Program "$env:ProgramFiles\Java\jdk1.8.0_351\bin\java.exe" -Action Allow

Write-Verbose -Message "Installing latest Java 19(JDK) x64..." -Verbose
# Downloading the latest Java 19(JDK) x64
# https://www.oracle.com/java/technologies/downloads/#jdk19-windows
$Parameters = @{
	Uri             = "https://download.oracle.com/java/19/latest/jdk-19_windows-x64_bin.msi"
	OutFile         = "$DownloadsFolder\Java 19(JDK) for Windows x64.msi"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\Java 19(JDK) for Windows x64.msi" -ArgumentList "/passive" -Wait

Remove-Item -Path "$DownloadsFolder\Java 19(JDK) for Windows x64.msi" -Force

# Configuring Java 19(JDK)
New-NetFirewallRule -DisplayName "Java 19(JDK)" -Direction Inbound -Program "$env:ProgramFiles\Java\jdk-19\bin\javaw.exe" -Action Allow
New-NetFirewallRule -DisplayName "Java 19(JDK)" -Direction Outbound -Program "$env:ProgramFiles\Java\jdk-19\bin\java.exe" -Action Allow

Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Java" -Force -Recurse -ErrorAction Ignore
Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Java Development Kit" -Force -Recurse -ErrorAction Ignore

Write-Verbose -Message "Installing WireGuard..." -Verbose
# Downloading the latest WireGuard
# https://www.wireguard.com/install/
$Parameters = @{
	Uri             = "https://download.wireguard.com/windows-client/wireguard-installer.exe"
	OutFile         = "$DownloadsFolder\WireGuardInstaller.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

Start-Process -FilePath "$DownloadsFolder\WireGuardInstaller.exe" -Wait

Remove-Item -Path "$DownloadsFolder\WireGuardInstaller.exe" -Force

Write-Verbose -Message "Starting Sophia Script..." -Verbose
# Downloading the latest Sophia Script
# https://github.com/farag2/Sophia-Script-for-Windows
Invoke-WebRequest -Uri script.sophi.app -UseBasicParsing | Invoke-Expression

Start-Process -FilePath powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoProfile -NoLogo -File `"$DownloadsFolder\Sophia Script for Windows *\Sophia.ps1`"" -Verb Runas -Wait

Remove-Item -Path "$DownloadsFolder\Sophia Script for Windows *" -Recurse -Force

Read-Host -Prompt "Press Enter to exit."
