<#
	.SYNOPSIS
	The TAB completion for functions and their arguments

	Version: v1.0.2
	Date: 11.06.2023

	Copyright (c) 2024 lowl1f3

	Big thanks directly to farag2

	.DESCRIPTION
	Dot source the script first:
		. .\Functions.ps1 (with a dot at the beginning)
	Start typing any characters contained in the function's name and press the TAB button

	.EXAMPLE
	Gerbera -Functions <tab>
	Gerbera -Functions tele<tab>
	Gerbera -Functions TelegramDesktop, Cursor, Notepad++

	.NOTES
	Use commas to separate functions

	.LINK
	https://github.com/lowl1f3/Gerbera-Script
#>

#Requires -RunAsAdministrator
#Requires -Version 5.1

function Gerbera
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $false)]
		[string[]]
		$Functions
	)

	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}
}

Clear-Host

$Host.UI.RawUI.WindowTitle = "Gerbera Script v1.0.2 | Made with $([char]::ConvertFromUtf32(0x1F497)) by lowl1f3"

Remove-Module -Name Gerbera -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Manifest\Gerbera.psd1 -PassThru -Force

# The mandatory checks. Please, do not comment out this function
Checks

$Parameters = @{
	CommandName   = "Gerbera"
	ParameterName = "Functions"
	ScriptBlock   = {
		param
		(
			$commandName,
			$parameterName,
			$wordToComplete,
			$commandAst,
			$fakeBoundParameters
		)

		# Get functions list with arguments to complete
		$Commands = (Get-Module -Name Gerbera).ExportedCommands.Keys
		foreach ($Command in $Commands)
		{
			$ParameterSets = (Get-Command -Name $Command).Parametersets.Parameters | Where-Object -FilterScript {$null -eq $_.Attributes.AliasNames}

			foreach ($ParameterSet in $ParameterSets.Name)
			{
				$Command | Where-Object -FilterScript {$_ -like "*$wordToComplete*"}

				continue
			}

			# Get functions list without arguments to complete
			Get-Command -Name $Command | Where-Object -FilterScript {$_.Name -like "*$wordToComplete*"}

			continue
		}
	}
}
Register-ArgumentCompleter @Parameters

Write-Information -MessageData "" -InformationAction Continue
Write-Verbose -Message "Gerbera -Functions <tab>" -Verbose
Write-Verbose -Message "Gerbera -Functions tele<tab>" -Verbose
Write-Verbose -Message "Gerbera -Functions TelegramDesktop, Cursor, Notepad++" -Verbose
