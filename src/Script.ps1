<#
	.SYNOPSIS
	Default preset file for "Script"

	Version: v1.0.0
	Date: #TBA#

	Copyright (c) 2023 lowl1f3

	Big thanks directly to farag2

	.DESCRIPTION
	Place the "#" char before function if you don't want to run it
	Remove the "#" char before function if you want to run it

	.EXAMPLE Run the whole script
	.\Script.ps1

	.EXAMPLE Run the script by specifying the module functions as an argument
	.\Script.ps1 -Functions Telegram, GitHubDesktop, Steam, etc.

	.NOTES
	Supported Windows 10 & 11 x64 versions

	.NOTES
	To use the TAB completion for functions dot source the Functions.ps1 script first:
		. .\Function.ps1 (with a dot at the beginning)
	Read more in the Functions.ps1 file

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

#Requires -RunAsAdministrator
#Requires -Version 5.1

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[string[]]
	$Functions
)

Clear-Host

$Host.UI.RawUI.WindowTitle = "Made with $([char]::ConvertFromUtf32(0x1F497)) by lowl1f3"

Remove-Module -Name Manifest -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Manifest\Manifest.psd1 -PassThru -Force

if ($Functions)
{
	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}
	exit
}

## A warning message about whether the preset file was customized
Confirmation

## Mandatory checks before running Script
Checks

## Download Telegram Desktop
TelegramDesktop

## Due to Spotify's recent policy of not being able to be installed with administrator privileges, this function is commented out in the preset file (yet)
#Spotify

## Download Discord
Discord

## Download BetterDiscord with plugins and themes
BetterDiscord

## Download Steam
Steam

## Download Firefox
Firefox

## Download NanaZip
NanaZip

## Apply "Windows 11 Cursors Concept v2.2" Dark Cursor
Cursor

## Download Notepad++
Notepad++

## Download GitHub Desktop
GitHubDesktop

## Download Visual Studio Community
VisualStudioCommunity

## Download Visual Studio Code
VisualStudioCode

## Download TeamSpeak 3 Client
TeamSpeakClient

## Download qBittorrent
qBittorrent

## Download Adobe Creative Cloud
AdobeCreativeCloud

## Download Java 8 (JRE)
Java8.JRE

## Download Java 19 (JDK)
Java19.JDK

## Download WireGuard
WireGuard

## Download Office
Office

## Download and run Sophia Script
SophiaScript

## Delete Installation Files and Shortcuts
DeleteInstallationFiles
