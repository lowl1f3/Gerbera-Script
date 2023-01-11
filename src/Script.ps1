<#
	.SYNOPSIS
	Default preset file for "Script"

	Copyright (c) 2022 lowl1f3

	Big thanks directly to farag2

	.DESCRIPTION
	Place the "#" char before function if you don't want to run it
	Remove the "#" char before function if you want to run it

	.EXAMPLE Run the whole script
	.\Script.ps1

	.EXAMPLE Run the script by specifying the module functions as an argument
	.\Script.ps1 -Functions Telegram, GitHub, Steam, etc.

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

#Requires -RunAsAdministrator

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[string[]]
	$Functions
)

Clear-Host

$Host.UI.RawUI.WindowTitle = "Made with $([char]::ConvertFromUtf32(0x1F497)) by lowlif3"

Remove-Module -Name Manifest -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Manifest\Manifest.psd1 -PassThru -Force

<#
	.SYNOPSIS
	Run the script by specifying functions as an argument

	.EXAMPLE
	.\Script.ps1 -Functions Steam, Discord, Telegram, etc.

	.NOTES
	Use commas to separate funtions
#>

if ($Functions)
{
	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}
	exit
}

Confirmation

# Download Telegram
Telegram

# Download Discord
Discord

# Download BetterDiscord
BetterDiscord

# Download BetterDiscord Plugins
BetterDiscordPlugins

# Download BetterDiscord Themes
BetterDiscordThemes

# Download Steam
Steam

# Download Google Chrome Enterprise
GoogleChromeEnterprise

# Download 7-Zip
7Zip

# Download Custom Cursor
CustomCursor

# Download Notepad
Notepad

# Download GitHub Desktop
GitHubDesktop

# Download Visual Studio Code
# VSCode

# Download TeamSpeak 3
TeamSpeak

# Download qBittorent
qBittorent

# Download Office
Office

# Download Adobe Creative Cloud
AdobeCreativeCloud

# Download Java8
Java8

# Download Java19
Java19

# Download WireGuard
WireGuard

# Delete Installation Files
DeleteInstallationFiles

# Launch Sophia Script
SophiaScript
