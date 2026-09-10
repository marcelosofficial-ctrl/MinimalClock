$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Write-Host "Validating MinimalClock..." -ForegroundColor Cyan

& (Join-Path $PSScriptRoot "validate-rainmeter.ps1")
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$required = @(
    "MinimalClock\MinimalClock.ini",
    "MinimalClock\Settings\Settings.ini",
    "MinimalClock\@Resources\Settings.inc",
    "web\index.html",
    "web\styles.css",
    "web\app.js",
    "README.md",
    "LICENSE"
)

foreach ($relative in $required) {
    $path = Join-Path $root $relative
    if (-not (Test-Path $path)) {
        Write-Error "Missing required project file: $relative"
    }
}

$fontFiles = Get-ChildItem -Path $root -Recurse -File -Include *.ttf,*.otf,*.woff,*.woff2 -ErrorAction SilentlyContinue
if ($fontFiles) {
    Write-Error "Font binaries are present in the public source tree. Review redistribution rights before release: $($fontFiles.FullName -join ', ')"
}

if (Get-Command node -ErrorAction SilentlyContinue) {
    & node --check (Join-Path $root "web\app.js")
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Write-Host "JavaScript syntax: PASS"
} else {
    Write-Host "Node.js not installed; JavaScript syntax check skipped." -ForegroundColor Yellow
}

Write-Host "Project validation: PASS" -ForegroundColor Green
