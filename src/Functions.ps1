<#
	.SYNOPSIS
	The TAB completion for functions and their arguments

	Version: v1.0.0
	Date: #TBA#

	Copyright (c) 2023 lowl1f3

	.DESCRIPTION
	Dot source the script first: . .\Functions.ps1 (with a dot at the beginning)
	Start typing any characters contained in the function's name and press the TAB button

	.EXAMPLE
	Script -Functions <tab>
	Script -Functions tele<tab>
	Script -Functions Telegram, Cursor, Notepad++

	.NOTES
	Use commas to separate funtions

	.LINK
	https://github.com/lowl1f3/Script
#>

#Requires -RunAsAdministrator
#Requires -Version 5.1

function Script
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

$Host.UI.RawUI.WindowTitle = "Made with $([char]::ConvertFromUtf32(0x1F497)) by lowl1f3"

Remove-Module -Name Manifest -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Manifest\Manifest.psd1 -PassThru -Force

# The mandatory checks. Please, do not comment out this function
Checks

$Parameters = @{
	CommandName   = "Script"
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
		$Commands = (Get-Module -Name Manifest).ExportedCommands.Keys
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
Write-Verbose -Message "Script -Functions <tab>" -Verbose
Write-Verbose -Message "Script -Functions tele<tab>" -Verbose
Write-Verbose -Message "Script -Functions Telegram, Cursor, Notepad++" -Verbose
