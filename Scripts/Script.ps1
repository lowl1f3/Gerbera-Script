write-host "${{ github.ref_name }}"

$CurrentVersion = "${{ github.ref_name }}"

Write-Verbose -Message "Script_$CurrentVersion.zip" -Verbose

New-Item -Path "Script_$CurrentVersion" -ItemType Directory -Force

Get-ChildItem -Path src -Force | Copy-Item -Destination "Script_$CurrentVersion" -Recurse -Force
$Parameters = @{
    Path             = "Script_$CurrentVersion"
    DestinationPath  = "Script_$CurrentVersion.zip"
    CompressionLevel = "Fastest"
    Force            = $true
}
Compress-Archive @Parameters
