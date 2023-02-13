<#
	.SYNOPSIS
	A PowerShell script for Windows that automates installation and configuration of programs

	Version: v1.0.0
	Date: #TBA#

	Copyright (c) 2023 lowl1f3

	Big thanks directly to farag2

	.NOTES
	Supported Windows 10 & 11 x64 versions

	.LINK GitHub
	https://github.com/lowl1f3/Script

	.LINK Telegram
	https://t.me/lowlif3

	.LINK Discord
	https://discord.com/users/330825971835863042

	.NOTES
	https://github.com/farag2/Office
	https://github.com/farag2/Sophia-Script-for-Windows
	https://github.com/farag2/Utilities/blob/master/Download/Cursor

	.LINK Author
	https://github.com/lowl1f3
#>

function Confirmation
{
	# Startup confirmation
	$Title         = "Have you customized the preset file before running Script?"
	$Message       = ""
	$Options       = "&No", "&Yes"
	$DefaultChoice = 0
	$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

	switch ($Result)
	{
		"0" {
			Invoke-Item -Path "$PSScriptRoot\..\Script.ps1"
			exit
		}
		"1" {
			continue
		}
	}
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Script:DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$Script:DesktopFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop

function Telegram
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id Telegram.TelegramDesktop --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing Telegram..." -Verbose

		# Download the latest Telegram Desktop
		# https://desktop.telegram.org/
		$Parameters = @{
			Uri             = "https://telegram.org/dl/desktop/win64"
			OutFile         = "$DownloadsFolder\TelegramSetup.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\TelegramSetup.exe" -ArgumentList "/VERYSILENT"
	}

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Telegram" -Direction Inbound -Program "$env:APPDATA\Telegram Desktop\Telegram.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Telegram" -Direction Outbound -Program "$env:APPDATA\Telegram Desktop\Telegram.exe" -Action Allow
}

function Spotify
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id Spotify.Spotify --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing Spotify..." -Verbose

		# Download the latest Spotify
		# https://www.spotify.com/download/windows
		$Parameters = @{
			Uri             = "https://download.scdn.co/SpotifySetup.exe"
			OutFile         = "$DownloadsFolder\SpotifySetup.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\SpotifySetup.exe"
	}

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Spotify" -Direction Inbound -Program "$env:APPDATA\Spotify\Spotify.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Spotify" -Direction Outbound -Program "$env:APPDATA\Spotify\Spotify.exe" -Action Allow
}

function Discord
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id Discord.Discord --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing Discord..." -Verbose

		# Download the latest Discord
		# https://discord.com/download
		$Parameters = @{
			Uri             = "https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x86"
			OutFile         = "$DownloadsFolder\DiscordSetup.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\DiscordSetup.exe" -Wait
	}

	# Remove Discord from autostart
	Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name Discord -Force -ErrorAction Ignore

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Discord" -Direction Inbound -Program "$env:LOCALAPPDATA\Discord\Update.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Discord" -Direction Outbound -Program "$env:LOCALAPPDATA\Discord\Update.exe" -Action Allow
}

function BetterDiscord
{
	Write-Verbose -Message "Installing BetterDiscord..." -Verbose

	# Download the latest BetterDiscord
	# https://github.com/BetterDiscord/Installer/releases/latest
	$Parameters = @{
		Uri             = "https://api.github.com/repos/BetterDiscord/Installer/releases"
		UseBasicParsing = $true
	}
	$bestRelease = (Invoke-RestMethod @Parameters).tag_name | Select-Object -Index 0

	$Parameters = @{
		Uri             = "https://github.com/BetterDiscord/Installer/releases/download/$($bestRelease)/BetterDiscord-Windows.exe"
		OutFile         = "$DownloadsFolder\BetterDiscordSetup.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Stop-Process -Name Discord -Force -ErrorAction Ignore

	Start-Process -FilePath "$DownloadsFolder\BetterDiscordSetup.exe" -Wait

	Stop-Process -Name BetterDiscord -Force -ErrorAction Ignore
}

function BetterDiscordPlugins
{
	if (Test-Path -Path "$env:APPDATA\BetterDiscord\")
	{
		# Install Better Discord plugins
		$Plugins = @(
			# BDFDB
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Library/0BDFDB.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js",

			# BetterFriendList
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/BetterFriendList/BetterFriendList.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/BetterFriendList/BetterFriendList.plugin.js",

			# BetterMediaPlayer
			# https://github.com/unknown81311/BetterMediaPlayer/blob/main/BetterMediaPlayer.plugin.js
			"https://raw.githubusercontent.com/unknown81311/BetterMediaPlayer/main/BetterMediaPlayer.plugin.js",

			# BetterSearchPage
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/BetterSearchPage/BetterSearchPage.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/BetterSearchPage/BetterSearchPage.plugin.js",

			# CallTimeCounter
			# https://github.com/QWERTxD/BetterDiscordPlugins/blob/main/CallTimeCounter/CallTimeCounter.plugin.js
			"https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/CallTimeCounter/CallTimeCounter.plugin.js",

			# CharCounter
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/CharCounter/CharCounter.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/CharCounter/CharCounter.plugin.js",

			# DoNotTrack
			# https://github.com/rauenzi/BetterDiscordAddons/blob/master/Plugins/DoNotTrack/DoNotTrack.plugin.js
			"https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js",

			# FileViewer
			# https://github.com/TheGreenPig/BetterDiscordPlugins/blob/main/FileViewer/FileViewer.plugin.js
			"https://raw.githubusercontent.com/TheGreenPig/BetterDiscordPlugins/main/FileViewer/FileViewer.plugin.js",

			# ImageUtilities
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/ImageUtilities/ImageUtilities.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ImageUtilities/ImageUtilities.plugin.js",

			# NitroEmoteAndScreenShareBypass
			# https://github.com/oSumAtrIX/BetterDiscordPlugins/blob/master/NitroEmoteAndScreenShareBypass.plugin.js
			"https://raw.githubusercontent.com/oSumAtrIX/BetterDiscordPlugins/master/NitroEmoteAndScreenShareBypass.plugin.js",

			# NoSpotifyPause
			# https://github.com/bepvte/bd-addons/blob/main/plugins/NoSpotifyPause.plugin.js
			"https://raw.githubusercontent.com/bepvte/bd-addons/main/plugins/NoSpotifyPause.plugin.js",

			# PluginRepo
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/PluginRepo/PluginRepo.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/PluginRepo/PluginRepo.plugin.js",

			# ReadAllNotificationsButton
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/ReadAllNotificationsButton/ReadAllNotificationsButton.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ReadAllNotificationsButton/ReadAllNotificationsButton.plugin.js",

			# SplitLargeMessages
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/SplitLargeMessages/SplitLargeMessages.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/SplitLargeMessages/SplitLargeMessages.plugin.js",

			# SpotifyControls
			# https://github.com/mwittrien/BetterDiscordAddons/tree/master/Plugins/SpotifyControls/SpotifyControls.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/SpotifyControls/SpotifyControls.plugin.js",

			# StaffTag
			# https://github.com/mwittrien/BetterDiscordAddons/tree/master/Plugins/StaffTag/StaffTag.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/StaffTag/StaffTag.plugin.js",

			# TypingIndicator
			# https://github.com/l0c4lh057/BetterDiscordStuff/blob/master/Plugins/TypingIndicator/TypingIndicator.plugin.js
			"https://raw.githubusercontent.com/l0c4lh057/BetterDiscordStuff/master/Plugins/TypingIndicator/TypingIndicator.plugin.js",

			# TypingUsersAvatars
			# https://github.com/QWERTxD/BetterDiscordPlugins/blob/main/TypingUsersAvatars/TypingUsersAvatars.plugin.js
			"https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/TypingUsersAvatars/TypingUsersAvatars.plugin.js",

			# ZeresPluginLibrary
			# https://github.com/rauenzi/BDPluginLibrary/blob/master/release/0PluginLibrary.plugin.js
			"https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js"
		)

		Write-Verbose -Message "Installing BetterDiscord plugins..." -Verbose

		foreach ($Plugin in $Plugins)
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message $(Split-Path -Path $Plugin -Leaf) -Verbose

			if ($(Split-Path -Path $Plugin -Leaf))
			{
				$Parameters = @{
					Uri             = $Plugin
					OutFile         = "$env:APPDATA\BetterDiscord\plugins\$(Split-Path -Path $Plugin -Leaf)"
					UseBasicParsing = $true
				}
			}
			Invoke-Webrequest @Parameters
		}
	}
	else
	{
		Write-Verbose -Message "BetterDiscord isn't installed" -Verbose
	}
}

function BetterDiscordThemes
{
	if (Test-Path -Path "$env:APPDATA\BetterDiscord\")
	{
		# Install Better Discord themes
		$Themes = @(
			# EmojiReplace
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Themes/EmojiReplace/EmojiReplace.theme.css
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Themes/EmojiReplace/EmojiReplace.theme.css",

			# RadialStatus
			# https://github.com/DiscordStyles/RadialStatus/blob/deploy/RadialStatus.theme.css
			"https://raw.githubusercontent.com/DiscordStyles/RadialStatus/deploy/RadialStatus.theme.css",

			# SettingsModal
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Themes/SettingsModal/SettingsModal.theme.css
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Themes/SettingsModal/SettingsModal.theme.css"
		)

		Write-Verbose -Message "Installing BetterDiscord themes..." -Verbose

		foreach ($Theme in $Themes)
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message $(Split-Path -Path $Theme -Leaf) -Verbose

			if ($(Split-Path -Path $Theme -Leaf))
			{
				$Parameters = @{
					Uri             = $Theme
					OutFile         = "$env:APPDATA\BetterDiscord\themes\$(Split-Path -Path $Theme -Leaf)"
					UseBasicParsing = $true
				}
			}
			Invoke-Webrequest @Parameters
		}
	}
	else
	{
		Write-Verbose -Message "BetterDiscord isn't installed" -Verbose
	}
}

function Steam
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id Valve.Steam --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing Steam..." -Verbose

		# Download the latest Steam
		# https://store.steampowered.com/about/
		$Parameters = @{
			Uri             = "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe"
			OutFile         = "$DownloadsFolder\SteamSetup.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\SteamSetup.exe" -ArgumentList "/S" -Wait
	}

	# Configuring Steam
	if (Test-Path -Path "${env:ProgramFiles(x86)}\Steam")
	{
		if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam.lnk"))
		{
			Copy-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force
		}

		Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Steam" -Recurse -Force -ErrorAction Ignore
		Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam" -Recurse -Force -ErrorAction Ignore
		Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name Steam -Force -ErrorAction Ignore
	}

	if (Test-Path -Path "${env:ProgramFiles(x86)}\Steam\userdata")
	{
		foreach ($folder in @(Get-ChildItem -Path "${env:ProgramFiles(x86)}\Steam\userdata" -Force -Directory))
		{
			if (Test-Path -Path $folder.FullName)
			{
				(Get-Content -Path "$($folder.PSPath)\config\localconfig.vdf" -Encoding UTF8) | ForEach-Object -Process {
					$_.replace(
						# Do not notify me about additions or changes to my games, new releases, and upcoming releases
						"`"NotifyAvailableGames`"		`"1`"", "`"NotifyAvailableGames`"		`"0`"").replace(
						# Display Steam URL address bar when available
						"`"NavUrlBar`"		`"0`"", "`"NavUrlBar`"		`"1`""
					)
				} | Set-Content -Path "$($folder.PSPath)\config\localconfig.vdf" -Encoding UTF8 -Force

				# Select which Steam window appears when the program starts: Library
				(Get-Content -Path "$($folder.PSPath)\7\remote\sharedconfig.vdf" -Encoding UTF8) | ForEach-Object -Process {
					$_.replace("`"SteamDefaultDialog`"		`"#app_store`"", "`"SteamDefaultDialog`"		`"#app_games`"")
				} | Set-Content -Path "$($folder.PSPath)\7\remote\sharedconfig.vdf" -Encoding UTF8 -Force
			}
		}
	}
	else
	{
		Write-Verbose -Message "Unable to configure Steam. User folder doesn't exist" -Verbose
	}

	# Remove Steam from autostart
	Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name Steam -Force -ErrorAction Ignore

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Steam" -Direction Inbound -Program "${env:ProgramFiles(x86)}\Steam\steam.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Steam" -Direction Outbound -Program "${env:ProgramFiles(x86)}\Steam\steam.exe" -Action Allow
}

function GoogleChrome
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id Google.Chrome --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing Google Chrome..." -Verbose

		# Download the latest Google Chrome x64
		# https://chromeenterprise.google/browser/download
		$Parameters = @{
			Uri     = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
			OutFile = "$DownloadsFolder\googlechromestandaloneenterprise64.msi"
			Verbose = [switch]::Present
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\googlechromestandaloneenterprise64.msi" -ArgumentList "/passive"
	}

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Google Chrome" -Direction Inbound -Program "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Google Chrome" -Direction Outbound -Program "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" -Action Allow
}

function NanaZip
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id M2Team.NanaZip --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing NanaZip..." -Verbose

		# Get the latest NanaZip
		$Parameters = @{
			Uri             = "https://api.github.com/repos/M2Team/NanaZip/releases"
			UseBasicParsing = $true
		}
		$bestRelease = (Invoke-RestMethod @Parameters).tag_name | Select-Object -Index 0
		$releaseName = (Invoke-RestMethod @Parameters).assets.name | Select-Object -Index 0

		# Download the latest NanaZip
		# https://github.com/M2Team/NanaZip/releases/latest
		$Parameters = @{
			Uri             = "https://github.com/M2Team/NanaZip/releases/download/$($bestRelease)/$($releaseName)"
			OutFile         = "$DownloadsFolder\$releaseName"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Add-AppxPackage -Path "$DownloadsFolder\$releaseName" -Verbose
	}
}

function Cursor
{
	Write-Verbose -Message "Installing custom Cursor..." -Verbose

	# Download custom Cursor
	# https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356
	$Parameters = @{
		Uri             = "https://raw.githubusercontent.com/farag2/Utilities/master/Download/Cursor/Install_Cursor.ps1"
		OutFile         = "$PSScriptRoot\Install_Cursor.ps1"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	$Path = Join-Path -Path $PSScriptRoot -ChildPath "" -Resolve
	wt --window 0 new-tab --title InstallCursor --startingDirectory $Path powershell -Command "& {.\Install_Cursor.ps1}"
}

function Notepad
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id Notepad++.Notepad++ --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing Notepad++..." -Verbose

		# Get the latest Notepad++
		$Parameters = @{
			Uri             = "https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest"
			UseBasicParsing = $true
		}
		$bestRelease = (Invoke-RestMethod @Parameters).tag_name | Select-Object -Index 0
		$bestReleaseVersion = (Invoke-RestMethod @Parameters).tag_name.replace("v", "") | Select-Object -Index 0

		# Download the latest Notepad++
		# https://github.com/notepad-plus-plus/notepad-plus-plus/releases/latest
		$Parameters = @{
			Uri             = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/$($bestRelease)/npp.$($bestReleaseVersion).Installer.x64.exe"
			OutFile         = "$DownloadsFolder\NotepadPlusPlusSetup.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\NotepadPlusPlusSetup.exe" -ArgumentList "/S" -Wait
	}

	Write-Warning -Message "Close 'Notepad++' window manually"

	Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe" -Wait

	# Configure Notepad++
	# https://github.com/farag2/Utilities/blob/master/Configure_Apps_And_The_Start_Menu_Shortcuts.ps1#L221
	if (Test-Path -Path "$env:ProgramFiles\Notepad++")
	{
		Stop-Process -Name notepad++ -Force -ErrorAction Ignore
		$Remove = @(
			"$env:ProgramFiles\Notepad++\change.log",
			"$env:ProgramFiles\Notepad++\LICENSE",
			"$env:ProgramFiles\Notepad++\readme.txt",
			"$env:ProgramFiles\Notepad++\autoCompletion"
		)
		Remove-Item -Path $Remove -Recurse -Force -ErrorAction Ignore
		Remove-Item -Path "$env:ProgramFiles\Notepad++\localization" -Exclude russian.xml -Recurse -Force -ErrorAction Ignore
	}

	if ((Get-WinSystemLocale).Name -eq "ru-RU")
	{
		if ($Host.Version.Major -eq 5)
		{
			# https://gist.github.com/mklement0/209a9506b8ba32246f95d1cc238d564d
			function ConvertTo-BodyWithEncoding
			{
				[CmdletBinding(PositionalBinding = $false)]
				param
				(
					[Parameter(Mandatory, ValueFromPipeline)]
					[Microsoft.PowerShell.Commands.WebResponseObject]
					$InputObject,

					# The encoding to use; defaults to UTF-8
					[Parameter(Position = 0)]
					$Encoding = [System.Text.Encoding]::Utf8
				)

				begin
				{
					if ($Encoding -isnot [System.Text.Encoding])
					{
						try
						{
							$Encoding = [System.Text.Encoding]::GetEncoding($Encoding)
						}
						catch
						{
							throw
						}
					}
				}

				process
				{
					$Encoding.GetString($InputObject.RawContentStream.ToArray())
				}
			}

			# We cannot invoke an expression with non-latin words to avoid "??????"
			$Parameters = @{
				Uri             = "https://raw.githubusercontent.com/farag2/Utilities/master/Notepad%2B%2B_context_menu.ps1"
				UseBasicParsing = $true
				Verbose         = $true
			}
			Invoke-WebRequest @Parameters | ConvertTo-BodyWithEncoding | Invoke-Expression
		}
	}
	New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -Name "C:\Program Files\Notepad++\notepad++.exe.FriendlyAppName" -PropertyType String -Value "Notepad++" -Force

	$Parameters = @{
		Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_11/Module/Sophia.psm1"
		Outfile         = "$env:TEMP\Sophia.ps1"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	# Change the line endings from UNIX LF to Windows (CR LF) for downlaoded file to be able to dot-source it
	# https://en.wikipedia.org/wiki/Newline#Representation
	(Get-Content -Path "$env:TEMP\Sophia.ps1" -Force) | Set-Content -Path "$env:TEMP\Sophia.ps1" -Encoding UTF8 -Force

	# Dot source the Sophia module to make the function available in the current session
	. "$env:TEMP\Sophia.ps1"

	# Register Notepad++, calculate hash, and associate with an extension with the "How do you want to open this" pop-up hidden
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .cfg -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .ini -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .log -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .nfo -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .ps1 -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .psm1 -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .psd1 -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .xml -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .yml -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"

	Remove-Item -Path "$env:TEMP\Sophia.ps1" -Force

	# It is needed to use -Wait to make Notepad++ apply written settings
	##Write-Warning -Message "Close Notepad++' window manually"
	##Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe" -ArgumentList "$env:APPDATA\Notepad++\config.xml" -Wait

	##[xml]$config = Get-Content -Path "$env:APPDATA\Notepad++\config.xml" -Force
	# Fluent UI: large
	##$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "ToolBar"} | ForEach-Object -Process {$_."#text" = "large"}
	# Mute all sounds
	##$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "MISC"} | ForEach-Object -Process {$_.muteSounds = "yes"}
	# Show White Space and TAB
	##$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "ScintillaPrimaryView"} | ForEach-Object -Process {$_.whiteSpaceShow = "show"}
	# 2 find buttons mode
	##$config.NotepadPlus.FindHistory | ForEach-Object -Process {$_.isSearch2ButtonsMode = "yes"}
	# Wrap around
	##$config.NotepadPlus.FindHistory | ForEach-Object -Process {$_.wrap = "yes"}
	# Disable creating backups
	##$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "Backup"} | ForEach-Object -Process {$_.action = "0"}
	##$config.Save("$env:APPDATA\Notepad++\config.xml")

	##Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe" -ArgumentList "$env:APPDATA\Notepad++\config.xml" -Wait
	##Start-Sleep -Seconds 1
	##Stop-Process -Name notepad++ -ErrorAction Ignore
}

function GitHubDesktop
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id GitHub.GitHubDesktop --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing GitHub Desktop..." -Verbose

		# Download the latest GitHub Desktop
		# https://desktop.github.com/
		$Parameters = @{
			Uri             = "https://central.github.com/deployments/desktop/desktop/latest/win32?format=msi"
			OutFile         = "$DownloadsFolder\GitHubDesktop.msi"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\GitHubDesktop.msi" -ArgumentList "/passive"
	}
}

function VisualStudio
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
	winget install --id Microsoft.VisualStudio.2022.Community --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing Visual Stutio..." -Verbose

		# Download the latest Visual Stutio
		# https://visualstudio.microsoft.com/#vs-section
		$Parameters = @{
			Uri             = "https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=community&channel=Release&version=VS2022&source=VSLandingPage&passive=true&includeRecommended=true&cid=2030"
			OutFile         = "$DownloadsFolder\VisualStutioSetup.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\VisualStutioSetup.exe" -ArgumentList "/silent"
	}
}

function VisualStudioCode
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id Microsoft.VisualStudioCode --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing Visual Stutio Code..." -Verbose

		# Download the latest Visual Stutio Code
		# https://code.visualstudio.com/download
		$Parameters = @{
			Uri             = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
			OutFile         = "$DownloadsFolder\VisualStutioCodeSetup.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Write-Warning -Message "Close 'Visual Studio Code' window manually after installation"

		Start-Process -FilePath "$DownloadsFolder\VisualStutioCodeSetup.exe" -ArgumentList "/silent"
	}
}

function TeamSpeak3
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id TeamSpeakSystems.TeamSpeakClient --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing TeamSpeak 3..." -Verbose

		# Download the latest TeamSpeak 3 x64
		# https://www.teamspeak.com/en/downloads/
		$Parameters = @{
			Uri             = "https://files.teamspeak-services.com/releases/client/3.5.6/TeamSpeak3-Client-win64-3.5.6.exe"
			OutFile         = "$DownloadsFolder\TeamSpeakSetup.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\TeamSpeakSetup.exe" -ArgumentList "/S"
	}

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "TeamSpeak 3" -Direction Inbound -Program "$env:ProgramFiles\TeamSpeak 3 Client\ts3client_win64.exe" -Action Allow
	New-NetFirewallRule -DisplayName "TeamSpeak 3" -Direction Outbound -Program "$env:ProgramFiles\TeamSpeak 3 Client\ts3client_win64.exe" -Action Allow
}

function qBittorrent
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id qBittorrent.qBittorrent --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing qBittorrent..." -Verbose

		# Get the latest qBittorrent x64
		$Parameters = @{
			Uri             = "https://sourceforge.net/projects/qbittorrent/best_release.json"
			UseBasicParsing = $true
		}
		$bestRelease = (Invoke-RestMethod @Parameters).platform_releases.windows.filename

		# Download the latest approved by maintainer qBittorrent x64
		# https://www.qbittorrent.org/download.php
		# For example 4.4.3 e.g., not 4.4.3.1
		$Parameters = @{
			Uri             = "https://nchc.dl.sourceforge.net/project/qbittorrent$($bestRelease)"
			OutFile         = "$DownloadsFolder\qBittorrentSetup.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\qBittorrentSetup.exe" -ArgumentList "/S" -Wait
	}

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

		if (-not (Test-Path -Path "$env:APPDATA\qBittorrent\"))
		{
			New-Item -Path "$env:APPDATA\qBittorrent\" -ItemType Directory -Force
		}
		# Install the settings file
		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/farag2/Utilities/master/qBittorrent/qBittorrent.ini"
			OutFile         = "$env:APPDATA\qBittorrent\qBittorrent.ini"
			UseBasicParsing = $true
		}
		Invoke-WebRequest @Parameters
		
		# Get the latest qBittorrent dark theme version
		$Parameters = @{
			Uri             = "https://api.github.com/repos/jagannatharjun/qbt-theme/releases/latest"
			UseBasicParsing = $true
		}
		$latestVersion = (Invoke-RestMethod @Parameters).assets.browser_download_url

		# Install dark theme
		$Parameters = @{
			Uri     = $latestVersion
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

		# Enable dark theme
		$qbtheme = (Resolve-Path -Path "$env:APPDATA\qBittorrent\darkstylesheet.qbtheme").Path.Replace("\", "/")

		# Save qBittorrent.ini in UTF8-BOM encoding to make it work with non-latin usernames
		(Get-Content -Path "$env:APPDATA\qBittorrent\qBittorrent.ini" -Encoding UTF8) -replace "General\\CustomUIThemePath=", "General\CustomUIThemePath=$qbtheme" | Set-Content -Path "$env:APPDATA\qBittorrent\qBittorrent.ini" -Encoding UTF8 -Force

		# Adding to the Windows Defender Firewall exclusion list
		New-NetFirewallRule -DisplayName "qBittorrent" -Direction Inbound -Program "$env:ProgramFiles\qBittorrent\qbittorrent.exe" -Action Allow
		New-NetFirewallRule -DisplayName "qBittorrent" -Direction Outbound -Program "$env:ProgramFiles\qBittorrent\qbittorrent.exe" -Action Allow
	}
}

function AdobeCreativeCloud
{
	Write-Verbose -Message "Installing Adobe Creative Cloud..." -Verbose

	# Download the latest Adobe Creative Cloud
	# https://creativecloud.adobe.com/en/apps/download/creative-cloud
	$Parameters = @{
		Uri             = "https://prod-rel-ffc-ccm.oobesaas.adobe.com/adobe-ffc-external/core/v1/wam/download?sapCode=KCCC&productName=Creative%20Cloud&os=win"
		OutFile         = "$DownloadsFolder\CreativeCloudSetUp.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\CreativeCloudSetUp.exe" -ArgumentList "SILENT"
}

function Java8
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id Oracle.JavaRuntimeEnvironment --exact --accept-source-agreements
	}
	else
	{
		# Get the latest Java 8(JRE) x64
		$Parameters = @{
			Uri             = "https://javadl-esd-secure.oracle.com/update/1.8.0/map-m-1.8.0.xml"
			UseBasicParsing = $true
		}
		$Versions = (Invoke-RestMethod @Parameters)."java-update-map".mapping
		$LatestVersion = $Versions.version | Select-Object -Last 1
		$URL = ($Versions | Where-Object -FilterScript {$_.Version -eq $LatestVersion}).url

		$Parameters = @{
			Uri             = $URL
			UseBasicParsing = $true
		}
		$Link = ((Invoke-RestMethod @Parameters)."java-update".information | Where-Object -FilterScript {$_.lang -eq "en"}).url

		# Download the latest approved by maintainer Java 8(JRE) x64
		# https://www.java.com/en/download/
		$Parameters = @{
			Uri             = $Link
			OutFile         = "$DownloadsFolder\Java 8(JRE) x64.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\Java 8(JRE) x64.exe" -ArgumentList "INSTALL_SILENT=1" -Wait
	}

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Java 8(JRE)" -Direction Inbound -Program "$env:ProgramFiles\Java\jre1.8.0_361\bin\javaw.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Java 8(JRE)" -Direction Outbound -Program "$env:ProgramFiles\Java\jre1.8.0_361\bin\java.exe" -Action Allow
}

function Java19
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id Oracle.JDK.19 --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing latest Java 19(JDK) x64..." -Verbose

		# Download the latest Java 19(JDK) x64
		# https://www.oracle.com/java/technologies/downloads/#jdk19-windows
		$Parameters = @{
			Uri             = "https://download.oracle.com/java/19/latest/jdk-19_windows-x64_bin.msi"
			OutFile         = "$DownloadsFolder\Java 19(JDK) x64.msi"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\Java 19(JDK) x64.msi" -ArgumentList "/passive" -Wait
	}

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Java 19(JDK)" -Direction Inbound -Program "$env:ProgramFiles\Java\jdk-19\bin\javaw.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Java 19(JDK)" -Direction Outbound -Program "$env:ProgramFiles\Java\jdk-19\bin\java.exe" -Action Allow

	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Java" -Force -Recurse -ErrorAction Ignore
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Java Development Kit" -Force -Recurse -ErrorAction Ignore
}

function WireGuard
{
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
	{
		winget install --id WireGuard.WireGuard --exact --accept-source-agreements
	}
	else
	{
		Write-Verbose -Message "Installing WireGuard..." -Verbose

		# Download the latest WireGuard
		# https://www.wireguard.com/install/
		$Parameters = @{
			Uri             = "https://download.wireguard.com/windows-client/wireguard-installer.exe"
			OutFile         = "$DownloadsFolder\WireGuardInstaller.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\WireGuardInstaller.exe" -Wait

		Stop-Process -Name WireGuard -Force -ErrorAction Ignore
	}

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Wire Guard" -Direction Inbound -Program "$env:ProgramFiles\WireGuard\wireguard.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Wire Guard" -Direction Outbound -Program "$env:ProgramFiles\WireGuard\wireguard.exe" -Action Allow
}

function Office
{
	Write-Verbose -Message "Installing Office..." -Verbose

	# Download the latest Office
	$Path = Join-Path -Path $PSScriptRoot -ChildPath "..\Office" -Resolve
	wt --window 0 new-tab --title Office --startingDirectory $Path powershell -Command "& {.\Download.ps1}"

	# Configuring Office
	if (Test-Path -Path "$env:ProgramFiles\Microsoft Office\root")
	{
		Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office Tools" -Recurse -Force -ErrorAction Ignore
	}
}

function SophiaScript
{
	Write-Verbose -Message "Downloading Sophia Script..." -Verbose

	try
	{
		Invoke-WebRequest -Uri script.sophi.app -UseBasicParsing | Invoke-Expression

		Start-Sleep -Seconds 5

		Write-Verbose -Message "Starting Sophia Script..." -Verbose

		$Path = Join-Path -Path $PSScriptRoot -ChildPath "..\Sophia_Script_for_Windows_*_v*" -Resolve
		wt --window 0 new-tab --title SophiaScript --startingDirectory $Path powershell -Command "& {.\Sophia.ps1}"
	}
	catch [System.Net.WebException]
	{
		# Download the latest Sophia Script
		# https://github.com/farag2/Sophia-Script-for-Windows
		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/Download_Sophia.ps1"
			OutFile         = "$PSScriptRoot\Download_Sophia.ps1"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		$Path = Join-Path -Path $PSScriptRoot -ChildPath "" -Resolve
		wt --window 0 new-tab --title DownloadSophia --startingDirectory $Path powershell -Command "& {.\Download_Sophia.ps1}"

		Start-Sleep -Seconds 5

		Write-Verbose -Message "Starting Sophia Script..." -Verbose

		$Path = Join-Path -Path $PSScriptRoot -ChildPath "Sophia_Script_for_Windows_*_v*" -Resolve
		wt --window 0 new-tab --title SophiaScript --startingDirectory $Path powershell -Command "& {.\Sophia.ps1}"
	}
}

# Remove installation files and shortcuts from Desktop
function DeleteInstallationFiles
{
	$Paths = @(
		"$DownloadsFolder\TelegramSetup.exe",
		"$DesktopFolder\Telegram.lnk",
		"$DownloadsFolder\DiscordSetup.exe",
		"$env:USERPROFILE\Desktop\Discord.lnk",
		"$DownloadsFolder\BetterDiscordSetup.exe",
		"$DownloadsFolder\SteamSetup.exe",
		"$env:PUBLIC\Desktop\Steam.lnk",
		"$DownloadsFolder\googlechromestandaloneenterprise64.msi",
		"$env:PUBLIC\Desktop\Google Chrome.lnk",
		"$DownloadsFolder\$releaseName",
		"$DownloadsFolder\dark.zip",
		"$PSScriptRoot\Install_Cursor.ps1",
		"$DownloadsFolder\NotepadPlusPlusSetup.exe",
		"$DownloadsFolder\GitHubDesktop.msi",
		"$DesktopFolder\GitHub Desktop.lnk",
		"$DownloadsFolder\VisualStutioCodeSetup.exe",
		"$DownloadsFolder\TeamSpeakSetup.exe",
		"$env:PUBLIC\Desktop\TeamSpeak 3 Client.lnk",
		"$DownloadsFolder\qBittorrentSetup.exe",
		"$DownloadsFolder\qbt-theme.zip",
		"$DownloadsFolder\CreativeCloudSetUp.exe",
		"$env:PUBLIC\Desktop\Adobe Creative Cloud.lnk",
		"$DownloadsFolder\Java 8(JRE) x64.exe",
		"$DownloadsFolder\Java 19(JDK) x64.msi",
		"$DownloadsFolder\WireGuardInstaller.exe",
		"$PSScriptRoot\Download_Sophia.ps1"
	)
	Remove-Item -Path $Paths -Recurse -Force -ErrorAction Ignore
}
