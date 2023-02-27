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

if ($Functions)
{
	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}
	exit
}
Confirmation

## Download Telegram
Telegram

## Download Spotify
#Spotify

## Download Discord
Discord

## Download BetterDiscord
BetterDiscord

## Download BetterDiscord Plugins
BetterDiscordPlugins

## Download BetterDiscord Themes
BetterDiscordThemes

## Download Steam
Steam

## Download Google Chrome
GoogleChrome

## Download NanaZip
NanaZip

## Download Custom Cursor
Cursor

## Download Notepad
Notepad

## Download GitHub Desktop
GitHubDesktop

## Download Visual Studio
VisualStudio

## Download Visual Studio Code
VisualStudioCode

## Download TeamSpeak 3
TeamSpeak3

## Download qBittorrent
qBittorrent

## Download Adobe Creative Cloud
AdobeCreativeCloud

## Download Java8
Java8

## Download Java19
Java19

## Download WireGuard
WireGuard

## Download Office
Office

## Download Sophia Script
SophiaScript

## Delete Installation Files and Shortcuts
DeleteInstallationFiles
