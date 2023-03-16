Write-Verbose -Message "Script_`"`${{ github.ref_name }}`".zip" -Verbose

New-Item -Path "Script_`"`${{ github.ref_name }}`"" -ItemType Directory -Force

Get-ChildItem -Path src -Force | Copy-Item -Destination "Script_`"`${{ github.ref_name }}`"" -Recurse -Force
$Parameters = @{
    Path             = "Script_`"`${{ github.ref_name }}`""
    DestinationPath  = "Script_`"`${{ github.ref_name }}`".zip"
    CompressionLevel = "Fastest"
    Force            = $true
}
Compress-Archive @Parameters
