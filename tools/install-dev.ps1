param(
    [switch]$ResetSettings
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot "MinimalClock"
$documents = [Environment]::GetFolderPath("MyDocuments")
$target = Join-Path $documents "Rainmeter\Skins\MinimalClock"
$settingsPath = Join-Path $target "@Resources\Settings.inc"
$tempSettings = Join-Path $env:TEMP "MinimalClock-Settings.inc"

if (-not (Test-Path $source)) {
    throw "Source skin folder not found: $source"
}

if ((Test-Path $settingsPath) -and -not $ResetSettings) {
    Copy-Item $settingsPath $tempSettings -Force
}

New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item (Join-Path $source "*") $target -Recurse -Force

if ((Test-Path $tempSettings) -and -not $ResetSettings) {
    Copy-Item $tempSettings $settingsPath -Force
    Remove-Item $tempSettings -Force
}

Write-Host "Installed development build to:"
Write-Host $target
Write-Host ""
Write-Host "In Rainmeter, choose Refresh all, then load MinimalClock.ini."
