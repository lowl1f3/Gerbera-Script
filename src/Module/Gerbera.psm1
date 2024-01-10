<#
	.SYNOPSIS
	A PowerShell script for Windows that automates installing and configuring programs

	Version: v1.0.2
	Date: 11.06.2023

	Copyright (c) 2023 lowl1f3

	Big thanks directly to farag2

	.NOTES
	Supported Windows 10 & 11 versions
	Editions: Home/Pro/Enterprise
	Architecture: x64

	.LINK GitHub
	https://github.com/lowl1f3/Gerbera-Script

	.LINK Telegram
	https://t.me/lowlif3

	.LINK Discord
	https://discord.com/users/330825971835863042

	.NOTES
	https://github.com/farag2/Office
	https://github.com/farag2/Sophia-Script-for-Windows
	https://github.com/farag2/Utilities/blob/master/Download/Cursor
	https://github.com/lowl1f3/Firefox

	.LINK Author
	https://github.com/lowl1f3
#>

# A warning message about whether the preset file was customized
function Confirmation
{
	# Startup confirmation
	$Title         = "Have you customized the preset file before running Gerbera Script?"
	$Message       = ""
	$Options       = "&No", "&Yes"
	$DefaultChoice = 0
	$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

	switch ($Result)
	{
		"0"
		{
			Invoke-Item -Path "$PSScriptRoot\..\Gerbera.ps1"
			exit
		}
		"1"
		{
			continue
		}
	}
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Script:DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$Script:DesktopFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop

if ($Host.Version.Major -eq 5)
{
	# Progress bar can significantly impact cmdlet performance
	# https://github.com/PowerShell/PowerShell/issues/2138
	$Script:ProgressPreference = "SilentlyContinue"
}

#region Checks
# Mandatory checks before running Gerbera Script
function Checks
{
	# Check if Windows is x64
	if (-not [System.Environment]::Is64BitOperatingSystem)
	{
		Write-Warning -Message "The Gerbera Script isn't supported by Windows x86"
		break
	}

	# Check the internet connection
	try
	{
		$Parameters = @{
			Uri              = "https://www.google.com"
			Method           = "Head"
			DisableKeepAlive = $true
			UseBasicParsing  = $true
		}
		(Invoke-WebRequest @Parameters).StatusDescription
	}
	catch [System.Net.WebException]
	{
		Write-Warning -Message "No internet connection"
		break
	}

	# Check if winget is installed or up to date
	if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -lt [System.Version]"1.19")
	{
		Write-Verbose -Message "Installing winget..." -Verbose

		# https://github.com/microsoft/winget-cli
		$Parameters = @{
			Uri             = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
			OutFile         = "$DownloadsFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

		Write-Verbose -Message "Install Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle manually" -Verbose
	}

	# Check if Windows Terminal is installed or up to date
	if ([System.Version](Get-AppxPackage -Name Microsoft.WindowsTerminal -ErrorAction Ignore).Version -lt [System.Version]"1.16")
	{
		Write-Verbose -Message "Installing Windows Terminal..." -Verbose

		# Check if the Gerbera Script was started from the Windows Terminal
		if ($env:WT_SESSION)
		{
			# Create a toast notification
			$xml = @"
<toast>
	<visual>
		<binding template="ToastGeneric">
			<text>Please re-run the script after updating Windows Terminal</text>
		</binding>
	</visual>
</toast>
"@

			$XmlDocument = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]::New()
			$XmlDocument.loadXml($xml)
			[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::CreateToastNotifier("Microsoft.WindowsTerminal_8wekyb3d8bbwe!App").Show($XmlDocument)
		}

		# Check Windows build version
		switch ((Get-CimInstance -ClassName CIM_OperatingSystem).BuildNumber)
		{
			{($_ -ge 17763) -and ($_ -le 19048)}
			{
				# Get the latest Windows 10 Terminal
				$Parameters = @{
					Uri             = "https://api.github.com/repos/microsoft/terminal/releases/latest"
					UseBasicParsing = $true
				}
				$terminal = (Invoke-RestMethod @Parameters).assets.name | Select-Object -Index 0

				# https://github.com/microsoft/terminal
				$Parameters = @{
					Uri             = "https://github.com/microsoft/terminal/releases/latest/download/$terminal"
					OutFile         = "$DownloadsFolder\$terminal"
					UseBasicParsing = $true
					Verbose         = $true
				}
				Invoke-WebRequest @Parameters

				Start-Process -FilePath "$DownloadsFolder\$terminal"

				Write-Verbose -Message "Install $terminal manually" -Verbose

				exit
			}
			{$_ -ge 22000}
			{
				# Get the latest Windows 11 Terminal
				$Parameters = @{
					Uri             = "https://api.github.com/repos/microsoft/terminal/releases/latest"
					UseBasicParsing = $true
				}
				$terminal = (Invoke-RestMethod @Parameters).assets.name | Select-Object -Index 2

				# https://github.com/microsoft/terminal
				$Parameters = @{
					Uri             = "https://github.com/microsoft/terminal/releases/latest/download/$terminal"
					OutFile         = "$DownloadsFolder\$terminal"
					UseBasicParsing = $true
					Verbose         = $true
				}
				Invoke-WebRequest @Parameters

				Start-Process -FilePath "$DownloadsFolder\$terminal"

				Write-Verbose -Message "Install $terminal manually" -Verbose

				exit
			}
		}
	}
}
#endregion Checks

# Download Telegram Desktop
function TelegramDesktop
{
	winget install --id Telegram.TelegramDesktop.Beta --exact --accept-source-agreements

	# Add to the Windows Defender Firewall exclusion list
	if (Get-NetFirewallRule -DisplayName "Telegram Desktop" -ErrorAction Ignore)
	{
		Write-Warning -Message "Firewall rule for Telegram Desktop already exists"
	}
	else
	{
		New-NetFirewallRule -DisplayName "Telegram Desktop" -Direction Inbound -Program "$env:APPDATA\Telegram Desktop\Telegram.exe" -Action Allow
		New-NetFirewallRule -DisplayName "Telegram Desktop" -Direction Outbound -Program "$env:APPDATA\Telegram Desktop\Telegram.exe" -Action Allow

		Write-Verbose -Message "Firewall rule for Telegram Desktop created" -Verbose
	}
}

# Download Discord
function Discord
{
	winget install --id Discord.Discord --exact --accept-source-agreements

	# Remove Discord from autostart
	Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name Discord -Force -ErrorAction Ignore

	# Add to the Windows Defender Firewall exclusion list
	if (Get-NetFirewallRule -DisplayName "Discord" -ErrorAction Ignore)
	{
		Write-Warning -Message "Firewall rule for Discord already exists"
	}
	else
	{
		New-NetFirewallRule -DisplayName "Discord" -Direction Inbound -Program "$env:LOCALAPPDATA\Discord\Update.exe" -Action Allow
		New-NetFirewallRule -DisplayName "Discord" -Direction Outbound -Program "$env:LOCALAPPDATA\Discord\Update.exe" -Action Allow

		Write-Verbose -Message "Firewall rule for Discord created" -Verbose
	}
}

# Download BetterDiscord
function BetterDiscord
{
	if (-not (Test-Path -Path "$env:APPDATA\BetterDiscord"))
	{
		Write-Verbose -Message "Installing BetterDiscord..." -Verbose

		# https://github.com/BetterDiscord/Installer
		$Parameters = @{
			Uri             = "https://github.com/BetterDiscord/Installer/releases/latest/download/BetterDiscord-Windows.exe"
			OutFile         = "$DownloadsFolder\BetterDiscordSetup.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Stop-Process -Name Discord -Force -ErrorAction Ignore

		Write-Warning -Message "Close BetterDiscord window manually after installation"

		Start-Process -FilePath "$DownloadsFolder\BetterDiscordSetup.exe" -Wait

		Stop-Process -Name BetterDiscord -Force -ErrorAction Ignore
	}
	else
	{
		Write-Warning -Message "BetterDiscord already installed. If you want to install it again, delete BetterDiscord manually and re-run the function."
	}

	# BetterDiscord plugins
	if (Test-Path -Path "$env:APPDATA\BetterDiscord")
	{
		$Plugins = @(
			# BDFDB
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Library/0BDFDB.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js",

			# BetterAnimations
			# https://github.com/arg0NNY/DiscordPlugins/blob/master/BetterAnimations/BetterAnimations.plugin.js
			"https://raw.githubusercontent.com/arg0NNY/DiscordPlugins/master/BetterAnimations/BetterAnimations.plugin.js",

			# BetterFriendList
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/BetterFriendList/BetterFriendList.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/BetterFriendList/BetterFriendList.plugin.js",

			# BetterGuildTooltip
			# https://github.com/arg0NNY/DiscordPlugins/blob/master/BetterGuildTooltip/BetterGuildTooltip.plugin.js
			"https://raw.githubusercontent.com/arg0NNY/DiscordPlugins/master/BetterGuildTooltip/BetterGuildTooltip.plugin.js",

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

			# ViewProfilePicture
			# https://github.com/Skamt/BDAddons/tree/main/ViewProfilePicture
			"https://raw.githubusercontent.com/Skamt/BDAddons/main/ViewProfilePicture/ViewProfilePicture.plugin.js",

			# ZeresPluginLibrary
			# https://github.com/rauenzi/BDPluginLibrary/blob/master/release/0PluginLibrary.plugin.js
			"https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js"
		)

		Write-Warning -Message "Installing plugins..."

		# Loop
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
		Write-Warning -Message "Can't install plugins. BetterDiscord isn't installed."
	}

	# BetterDiscord themes
	if (Test-Path -Path "$env:APPDATA\BetterDiscord")
	{
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

		Write-Warning -Message "Installing themes..."

		# Loop
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
		Write-Warning -Message "Can't install themes. BetterDiscord isn't installed."
	}
}

# Download Steam
function Steam
{
	winget install --id Valve.Steam --exact --accept-source-agreements

	# Check if Steam is installed
	if (Test-Path -Path "${env:ProgramFiles(x86)}\Steam")
	{
		# Move Steam shortcut from the Steam folder to the main Programs folder
		if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam.lnk"))
		{
			Copy-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force
		}
		# Remove Steam shortcut folders
		Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Steam" -Recurse -Force -ErrorAction Ignore
		Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam" -Recurse -Force -ErrorAction Ignore

		# Remove Steam from autostart
		Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name Steam -Force -ErrorAction Ignore
	}

	# Check if any user folder exist
	if (Test-Path -Path "${env:ProgramFiles(x86)}\Steam\userdata\*")
	{
		Write-Verbose -Message "Configuring Steam..." -Verbose

		# Configure Steam
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
		Write-Warning -Message "Unable to configure Steam. User folder doesn't exist."
	}

	# Add to the Windows Defender Firewall exclusion list
	if (Get-NetFirewallRule -DisplayName "Steam" -ErrorAction Ignore)
	{
		Write-Warning -Message "Firewall rule for Steam already exists"
	}
	else
	{
		New-NetFirewallRule -DisplayName "Steam" -Direction Inbound -Program "${env:ProgramFiles(x86)}\Steam\steam.exe" -Action Allow
		New-NetFirewallRule -DisplayName "Steam" -Direction Outbound -Program "${env:ProgramFiles(x86)}\Steam\steam.exe" -Action Allow

		Write-Verbose -Message "Firewall rule for Steam created" -Verbose
	}
}

# Download Mozilla Firefox
function MozillaFirefox
{
	winget install --id Mozilla.Firefox --exact --accept-source-agreements

	# We need this to ensure that the necessary folders were created
	Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe"
	Stop-Process -Name Firefox -Force -ErrorAction Ignore

	# https://github.com/lowl1f3/Firefox/blob/main/Customize.ps1
	$Parameters = @{
		Uri             = "https://raw.githubusercontent.com/lowl1f3/Firefox/main/Customize.ps1"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters | Invoke-Expression

	# Add to the Windows Defender Firewall exclusion list
	if (Get-NetFirewallRule -DisplayName "Mozilla Firefox" -ErrorAction Ignore)
	{
		Write-Warning -Message "Firewall rule for Mozilla Firefox already exists"
	}
	else
	{
		New-NetFirewallRule -DisplayName "Mozilla Firefox" -Direction Inbound -Program "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -Action Allow
		New-NetFirewallRule -DisplayName "Mozilla Firefox" -Direction Outbound -Program "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -Action Allow

		Write-Verbose -Message "Firewall rule for Mozilla Firefox created" -Verbose
	}
}

# Download NanaZip
function NanaZip
{
	winget install --id M2Team.NanaZip --exact --accept-source-agreements
}

# Apply "Windows 11 Cursors Concept v2.2" Dark Cursor
function Cursor
{
	Write-Verbose -Message "Applying `"Windows 11 Cursors Concept v2.2`" dark cursor..." -Verbose

	# https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356
	# https://github.com/farag2/Utilities/blob/master/Download/Install_Cursor.ps1
	$Parameters = @{
		Uri             = "https://raw.githubusercontent.com/farag2/Utilities/master/Download/Install_Cursor.ps1"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters | Invoke-Expression
}

# Download Notepad++
function Notepad++
{
	winget install --id Notepad++.Notepad++ --exact --accept-source-agreements

	# Check if Notepad++ is installed
	if (Test-Path -Path "$env:ProgramFiles\Notepad++")
	{
		# https://github.com/farag2/Utilities/blob/master/Configure_Apps_And_The_Start_Menu_Shortcuts.ps1#L214
		# Check if Windows localization is ru-RU
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

				Write-Verbose -Message "Applying `"Notepad++_context_menu.ps1`"..." -Verbose

				# We cannot invoke an expression with non-latin words to avoid "??????"
				# https://github.com/farag2/Utilities/blob/master/Notepad%2B%2B_context_menu.ps1
				$Parameters = @{
					Uri             = "https://raw.githubusercontent.com/farag2/Utilities/master/Notepad%2B%2B_context_menu.ps1"
					UseBasicParsing = $true
					Verbose         = $true
				}
				Invoke-WebRequest @Parameters | ConvertTo-BodyWithEncoding | Invoke-Expression
			}
		}
		New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -Name "C:\Program Files\Notepad++\notepad++.exe.FriendlyAppName" -PropertyType String -Value "Notepad++" -Force

		# Extract strings from %SystemRoot%\System32\shell32.dll using its number
		$Signature = @{
			Namespace        = "WinAPI"
			Name             = "GetStr"
			Language         = "CSharp"
			UsingNamespace   = "System.Text"
			MemberDefinition = @"
[DllImport("kernel32.dll", CharSet = CharSet.Auto)]
public static extern IntPtr GetModuleHandle(string lpModuleName);
[DllImport("user32.dll", CharSet = CharSet.Auto)]
internal static extern int LoadString(IntPtr hInstance, uint uID, StringBuilder lpBuffer, int nBufferMax);
public static string GetString(uint strId)
{
	IntPtr intPtr = GetModuleHandle("shell32.dll");
	StringBuilder sb = new StringBuilder(255);
	LoadString(intPtr, strId, sb, sb.Capacity);
	return sb.ToString();
}
"@
		}
		if (-not ("WinAPI.GetStr" -as [type]))
		{
			Add-Type @Signature
		}

		Write-Verbose -Message "Downloading Sophia.ps1..." -Verbose

		# We can dot source .ps1 files only. So we artificially rename .psm1 into .ps1
		# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/src/Sophia_Script_for_Windows_11/Module/Sophia.psm1
		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_11/Module/Sophia.psm1"
			Outfile         = "$env:TEMP\Sophia.ps1"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		# Change the line endings from UNIX LF to Windows (CR LF) for downloaded file to be able to dot source it
		# https://en.wikipedia.org/wiki/Newline#Representation
		(Get-Content -Path "$env:TEMP\Sophia.ps1" -Force) | Set-Content -Path "$env:TEMP\Sophia.ps1" -Encoding UTF8 -Force

		# Dot source the Sophia module to make the function available in the current session
		. "$env:TEMP\Sophia.ps1"

		Write-Verbose -Message "Associating extensions..." -Verbose

		# Register Notepad++, calculate hash, and associate with an extension with the "How do you want to open this" pop-up hidden
		$Extensions = @(
			".cfg", ".ini", ".log",
			".nfo", ".ps1", ".psm1",
			".psd1", ".xml", ".yml",
			".md", ".txt"
		)
		foreach ($Extension in $Extensions)
		{
			Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension $Extension -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
		}

		Write-Verbose -Message "Extentions associated" -Verbose

		Remove-Item -Path "$env:TEMP\Sophia.ps1" -Force -ErrorAction Ignore
	}
}

# Download GitHub Desktop
function GitHubDesktop
{
	winget install --id GitHub.GitHubDesktop --exact --accept-source-agreements
}

# Download TeamSpeak 3 Client
function TeamSpeakClient
{
	winget install --id TeamSpeakSystems.TeamSpeakClient --exact --accept-source-agreements

	# Add to the Windows Defender Firewall exclusion list
	if (Get-NetFirewallRule -DisplayName "TeamSpeak 3 Client" -ErrorAction Ignore)
	{
		Write-Warning -Message "Firewall rule for TeamSpeak 3 Client already exists"
	}
	else
	{
		New-NetFirewallRule -DisplayName "TeamSpeak 3 Client" -Direction Inbound -Program "$env:ProgramFiles\TeamSpeak 3 Client\ts3client_win64.exe" -Action Allow
		New-NetFirewallRule -DisplayName "TeamSpeak 3 Client" -Direction Outbound -Program "$env:ProgramFiles\TeamSpeak 3 Client\ts3client_win64.exe" -Action Allow

		Write-Verbose -Message "Firewall rule for TeamSpeak 3 Client created" -Verbose
	}
}

# Download qBittorrent
function qBittorrent
{
	winget install --id qBittorrent.qBittorrent --exact --accept-source-agreements

	# Configure qBittorrent
	if (Test-Path -Path "$env:ProgramFiles\qBittorrent")
	{
		Stop-Process -Name qBittorrent -Force -ErrorAction Ignore

		# Move qBittorrent shortcut from the qBittorrent folder to the main Programs folder
		if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\qBittorrent.lnk"))
		{
			Copy-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\qBittorrent\qBittorrent.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force
		}
		# Remove the qBittorrent folder from the main Programs folder
		Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\qBittorrent" -Recurse -Force -ErrorAction Ignore

		# Create a qBittorrent folder in AppData\Roaming if it doesn't exist
		if (-not (Test-Path -Path "$env:APPDATA\qBittorrent"))
		{
			New-Item -Path "$env:APPDATA\qBittorrent" -ItemType Directory -Force
		}

		# Check if "defaulticons-fluent-dark-no-mica.qbtheme" is already installed
		if (-not (Test-Path -Path "$env:APPDATA\qBittorrent\defaulticons-fluent-dark-no-mica.qbtheme"))
		{
			Write-Verbose -Message "Installing `"defaulticons-fluent-dark-no-mica.qbtheme`"..." -Verbose

			# https://github.com/witalihirsch/qBitTorrent-fluent-theme
			$Parameters = @{
				Uri     = "https://github.com/witalihirsch/qBitTorrent-fluent-theme/releases/latest/download/defaulticons-fluent-dark-no-mica.qbtheme"
				OutFile = "$env:APPDATA\qBittorrent\defaulticons-fluent-dark-no-mica.qbtheme"
				Verbose = $true
			}
			Invoke-WebRequest @Parameters
		}

		Write-Verbose -Message "Installing qBittorrent.ini..." -Verbose

		# https://github.com/farag2/Utilities/blob/master/qBittorrent/qBittorrent.ini
		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/farag2/Utilities/master/qBittorrent/qBittorrent.ini"
			OutFile         = "$env:APPDATA\qBittorrent\qBittorrent.ini"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		# Save qBittorrent.ini in UTF8-BOM encoding to make it work with non-latin usernames
		$qbtheme = (Resolve-Path -Path "$env:APPDATA\qBittorrent\defaulticons-fluent-dark-no-mica.qbtheme").Path.Replace("\", "/")
		(Get-Content -Path "$env:APPDATA\qBittorrent\qBittorrent.ini" -Encoding UTF8) -replace "General\\CustomUIThemePath=", "General\CustomUIThemePath=$qbtheme" | Set-Content -Path "$env:APPDATA\qBittorrent\qBittorrent.ini" -Encoding UTF8 -Force

		# Add to the Windows Defender Firewall exclusion list
		if (Get-NetFirewallRule -DisplayName "qBittorrent" -ErrorAction Ignore)
		{
			Write-Warning -Message "Firewall rule for qBittorrent already exists"
		}
		else
		{
			New-NetFirewallRule -DisplayName "qBittorrent" -Direction Inbound -Program "$env:ProgramFiles\qBittorrent\qbittorrent.exe" -Action Allow
			New-NetFirewallRule -DisplayName "qBittorrent" -Direction Outbound -Program "$env:ProgramFiles\qBittorrent\qbittorrent.exe" -Action Allow

			Write-Verbose -Message "Firewall rule for qBittorrent created" -Verbose
		}
	}
}

# Download Adobe Creative Cloud
function AdobeCreativeCloud
{
	# Check if Adobe Creative Cloud is already installed
	if (-not (Test-Path -Path "$env:ProgramFiles\Adobe\Adobe Creative Cloud\ACC"))
	{
		Write-Verbose -Message "Installing Adobe Creative Cloud..." -Verbose

		# https://creativecloud.adobe.com/en/apps/download/creative-cloud
		$Parameters = @{
			Uri             = "https://prod-rel-ffc-ccm.oobesaas.adobe.com/adobe-ffc-external/core/v1/wam/download?sapCode=KCCC&productName=Creative%20Cloud&os=win"
			OutFile         = "$DownloadsFolder\CreativeCloudSetUp.exe"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters

		Start-Process -FilePath "$DownloadsFolder\CreativeCloudSetUp.exe"
	}
	else
	{
		Write-Warning -Message "Adobe Creative Cloud already installed. If you want to install it again, delete Adobe Creative Cloud manually and re-run the function."
	}
}

# Download Java 8
function Java8.JRE
{
	winget install --id Oracle.JavaRuntimeEnvironment --exact --accept-source-agreements

	# Add to the Windows Defender Firewall exclusion list
	if (Get-NetFirewallRule -DisplayName "Java 8" -ErrorAction Ignore)
	{
		Write-Warning -Message "Firewall rule for Java 8 already exists"
	}
	else
	{
		New-NetFirewallRule -DisplayName "Java 8" -Direction Inbound -Program "$env:ProgramFiles\Java\jre1.8.0_361\bin\javaw.exe" -Action Allow
		New-NetFirewallRule -DisplayName "Java 8" -Direction Outbound -Program "$env:ProgramFiles\Java\jre1.8.0_361\bin\java.exe" -Action Allow

		Write-Verbose -Message "Firewall rule for Java 8 created" -Verbose
	}
}

# Download Java SE Development Kit 20
function Java20.JDK
{
	winget install --id Oracle.JDK.20 --exact --accept-source-agreements

	# Remove Java20(JDK) shortcut folders
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Java" -Force -Recurse -ErrorAction Ignore
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Java Development Kit" -Force -Recurse -ErrorAction Ignore

	# Add to the Windows Defender Firewall exclusion list
	if (Get-NetFirewallRule -DisplayName "Java 20" -ErrorAction Ignore)
	{
		Write-Warning -Message "Firewall rule for Java 20 already exists"
	}
	else
	{
		New-NetFirewallRule -DisplayName "Java 20" -Direction Inbound -Program "$env:ProgramFiles\Java\jdk-20\bin\javaw.exe" -Action Allow
		New-NetFirewallRule -DisplayName "Java 20" -Direction Outbound -Program "$env:ProgramFiles\Java\jdk-20\bin\java.exe" -Action Allow

		Write-Verbose -Message "Firewall rule for Java 20 created" -Verbose
	}
}

# Download WireGuard
function WireGuard
{
	winget install --id WireGuard.WireGuard --exact --accept-source-agreements

	# Add to the Windows Defender Firewall exclusion list
	if (Get-NetFirewallRule -DisplayName "WireGuard" -ErrorAction Ignore)
	{
		Write-Warning -Message "Firewall rule for WireGuard already exists"
	}
	else
	{
		New-NetFirewallRule -DisplayName "WireGuard" -Direction Inbound -Program "$env:ProgramFiles\WireGuard\wireguard.exe" -Action Allow
		New-NetFirewallRule -DisplayName "WireGuard" -Direction Outbound -Program "$env:ProgramFiles\WireGuard\wireguard.exe" -Action Allow

		Write-Verbose -Message "Firewall rule for WireGuard created" -Verbose
	}
}

# Download Office
function Office
{
	# Check if Office is already installed
	if(-not (Test-Path -Path "$env:ProgramFiles\Microsoft Office\root"))
	{
		Write-Verbose -Message "Installing Office..." -Verbose

		# We cannot call "$PSScriptRoot\..\Office\Download.ps1" directly due to we have to assign the Office folder to download Office to
		$Path = Join-Path -Path $PSScriptRoot -ChildPath "..\Office" -Resolve
		wt --window 0 new-tab --title Office --startingDirectory $Path powershell -Command "& {.\Download.ps1}"

		# To ensure that the process has time to appear when we call Get-CimInstance
		Start-Sleep -Seconds 1

		# Сreate a do/until loop to wait for the process to execute
		do
		{
			$PowerShellWindow = Get-CimInstance -ClassName CIM_Process | Where-Object -FilterScript {$_.Name -eq "powershell.exe"} | Where-Object -FilterScript {$_.CommandLine -match "Download.ps1"}
			if ($PowerShellWindow)
			{
				Start-Sleep -Seconds 1
			}
		}
		until (-not $PowerShellWindow)

		Write-Warning -Message "Close Office window manually after installation"

		# Сreate a do/until loop to wait for the process to execute
		do
		{
			if (Wait-Process -Name OfficeC2RClient -ErrorAction Ignore)
			{
				Start-Sleep -Seconds 1
			}
		}
		until (-not (Wait-Process -Name OfficeC2RClient -ErrorAction Ignore))

		Write-Verbose -Message "Office installed" -Verbose

		# Configure Office
		if (Test-Path -Path "$env:ProgramFiles\Microsoft Office\root")
		{
			Write-Verbose -Message "Configuring Office..." -Verbose

			# Remove "Microsoft Office Tools" folder from the main Programs folder
			Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office Tools" -Recurse -Force -ErrorAction Ignore

			& "$PSScriptRoot\..\Office\Configure.ps1"

			Write-Verbose -Message "Office configured" -Verbose
		}
	}
	else
	{
		Write-Warning -Message "Office already installed. If you want to install it again, delete Office manually and re-run the function."
	}
}

# Download and run Sophia Script
function SophiaScript
{
	Write-Verbose -Message "Downloading Sophia Script..." -Verbose

	# We need try/catch to check if the user can download Sophia Script from script.sophi.app
	try
	{
		# https://github.com/farag2/Sophia-Script-for-Windows#how-to-download-sophia-script-via-powershell
		Invoke-WebRequest -Uri script.sophia.team -UseBasicParsing | Invoke-Expression

		Write-Verbose -Message "Starting Sophia Script..." -Verbose

		# We cannot call "$PSScriptRoot\..\Sophia_Script_for_Windows_*_v*\Sophia.ps1" directly
		$Path = Join-Path -Path $DownloadsFolder -ChildPath "Sophia_Script_for_Windows_*_v*" -Resolve
		wt --window 0 new-tab --title "Sophia Script for Windows" --startingDirectory $Path powershell -Command "& {.\Sophia.ps1}"
	}
	catch [System.Net.WebException]
	{
		# Download the latest Sophia Script using Download_Sophia.ps1
		# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/Download_Sophia.ps1
		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/Download_Sophia.ps1"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters | Invoke-Expression

		Write-Verbose -Message "Starting Sophia Script..." -Verbose

		# We cannot call "$PSScriptRoot\..\Sophia_Script_for_Windows_*_v*\Sophia.ps1" directly
		$Path = Join-Path -Path $DownloadsFolder -ChildPath "Sophia_Script_for_Windows_*_v*" -Resolve
		wt --window 0 new-tab --title "Sophia Script for Windows" --startingDirectory $Path powershell -Command "& {.\Sophia.ps1}"
	}
}

# Delete Installation Files and Shortcuts
function DeleteInstallationFiles
{
	$Paths = @(
		"$DownloadsFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle",
		"$DownloadsFolder\$terminal",
		"$DesktopFolder\Telegram.lnk",
		"$env:USERPROFILE\Desktop\Discord.lnk",
		"$DesktopFolder\Discord.lnk",
		"$DownloadsFolder\BetterDiscordSetup.exe",
		"$env:PUBLIC\Desktop\Steam.lnk",
		"$env:PUBLIC\Desktop\Firefox.lnk",
		"$DesktopFolder\GitHub Desktop.lnk",
		"$DownloadsFolder\TeamSpeak 3 Client.lnk",
		"$DownloadsFolder\CreativeCloudSetUp.exe",
		"$env:PUBLIC\Desktop\Adobe Creative Cloud.lnk"
	)
	Remove-Item -Path $Paths -Recurse -Force -ErrorAction Ignore
}
