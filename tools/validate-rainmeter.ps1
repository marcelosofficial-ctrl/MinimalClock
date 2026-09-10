param(
    [string]$SkinRoot = (Join-Path $PSScriptRoot "..\MinimalClock")
)

$ErrorActionPreference = "Stop"
$files = Get-ChildItem -Path $SkinRoot -Recurse -File | Where-Object { $_.Extension -in ".ini", ".inc" }
$errors = [System.Collections.Generic.List[string]]::new()

foreach ($file in $files) {
    $section = $null
    $lineNumber = 0

    foreach ($line in Get-Content -LiteralPath $file.FullName) {
        $lineNumber++
        $trimmed = $line.Trim()

        if (-not $trimmed -or $trimmed.StartsWith(';')) { continue }

        if ($trimmed -match '^\[[^\]]+\]$') {
            $section = $trimmed
            continue
        }

        if ($trimmed -match '^[^=]+=' -and -not $section) {
            $errors.Add("$($file.FullName):$lineNumber option appears before any section: $trimmed")
        }
    }
}

$required = @(
    (Join-Path $SkinRoot "MinimalClock.ini"),
    (Join-Path $SkinRoot "Settings\Settings.ini"),
    (Join-Path $SkinRoot "@Resources\Settings.inc")
)

foreach ($path in $required) {
    if (-not (Test-Path -LiteralPath $path)) {
        $errors.Add("Missing required file: $path")
    }
}

if ($errors.Count -gt 0) {
    Write-Host "MinimalClock validation FAILED" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    exit 1
}

Write-Host "MinimalClock validation passed." -ForegroundColor Green
Write-Host "Checked $($files.Count) Rainmeter INI/include files."
