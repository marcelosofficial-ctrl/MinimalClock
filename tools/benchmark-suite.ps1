param(
    [int]$Seconds = 45,
    [string]$OutputDirectory = "benchmark-results"
)

$ErrorActionPreference = "Stop"

function Read-RainmeterSample {
    param(
        [string]$Label,
        [int]$DurationSeconds
    )

    $process = Get-Process Rainmeter -ErrorAction Stop | Select-Object -First 1
    $logicalProcessors = [Environment]::ProcessorCount
    $rows = New-Object System.Collections.Generic.List[object]

    $process.Refresh()
    $previousCpu = $process.TotalProcessorTime.TotalSeconds
    $previousTime = Get-Date

    Write-Host ""
    Write-Host "Sampling '$Label' for $DurationSeconds seconds..." -ForegroundColor Cyan

    for ($i = 1; $i -le $DurationSeconds; $i++) {
        Start-Sleep -Seconds 1
        $process.Refresh()

        $now = Get-Date
        $cpuNow = $process.TotalProcessorTime.TotalSeconds
        $elapsed = ($now - $previousTime).TotalSeconds
        $cpuDelta = $cpuNow - $previousCpu
        $cpuPercent = if ($elapsed -gt 0) {
            ($cpuDelta / ($elapsed * $logicalProcessors)) * 100
        } else {
            0
        }

        $rows.Add([pscustomobject]@{
            Scenario = $Label
            Timestamp = $now.ToString("o")
            CpuPercent = [math]::Round($cpuPercent, 4)
            WorkingSetMB = [math]::Round($process.WorkingSet64 / 1MB, 2)
            PrivateMemoryMB = [math]::Round($process.PrivateMemorySize64 / 1MB, 2)
        })

        $previousCpu = $cpuNow
        $previousTime = $now
    }

    $summary = [pscustomobject]@{
        Scenario = $Label
        AverageCpuPercent = [math]::Round(($rows | Measure-Object CpuPercent -Average).Average, 4)
        AverageWorkingSetMB = [math]::Round(($rows | Measure-Object WorkingSetMB -Average).Average, 2)
        AveragePrivateMemoryMB = [math]::Round(($rows | Measure-Object PrivateMemoryMB -Average).Average, 2)
    }

    return [pscustomobject]@{
        Rows = $rows
        Summary = $summary
    }
}

function Wait-ForUser {
    param([string]$Message)
    Write-Host ""
    Write-Host $Message -ForegroundColor Yellow
    [void](Read-Host "Press Enter when ready")
}

if (-not (Get-Process Rainmeter -ErrorAction SilentlyContinue)) {
    throw "Rainmeter is not running. Start Rainmeter before running this benchmark."
}

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null

Write-Host "MinimalClock benchmark suite" -ForegroundColor Green
Write-Host "Each scenario samples the Rainmeter process itself."
Write-Host "For comparable results, close heavy apps and avoid moving/resizing Rainmeter skins during sampling."

$allRows = New-Object System.Collections.Generic.List[object]
$summaries = New-Object System.Collections.Generic.List[object]

Wait-ForUser "STEP 1/3: Unload MinimalClock. Leave Rainmeter itself running."
$baseline = Read-RainmeterSample -Label "Rainmeter baseline" -DurationSeconds $Seconds
$baseline.Rows | ForEach-Object { $allRows.Add($_) }
$summaries.Add($baseline.Summary)

Wait-ForUser "STEP 2/3: Load MinimalClock and set Seconds to HIDE."
$secondsOff = Read-RainmeterSample -Label "MinimalClock seconds off" -DurationSeconds $Seconds
$secondsOff.Rows | ForEach-Object { $allRows.Add($_) }
$summaries.Add($secondsOff.Summary)

Wait-ForUser "STEP 3/3: Keep MinimalClock loaded and set Seconds to SHOW."
$secondsOn = Read-RainmeterSample -Label "MinimalClock seconds on" -DurationSeconds $Seconds
$secondsOn.Rows | ForEach-Object { $allRows.Add($_) }
$summaries.Add($secondsOn.Summary)

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$csvPath = Join-Path $OutputDirectory "samples-$timestamp.csv"
$summaryPath = Join-Path $OutputDirectory "summary-$timestamp.csv"
$markdownPath = Join-Path $OutputDirectory "PERFORMANCE_RESULTS.md"

$allRows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $csvPath
$summaries | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $summaryPath

$base = $baseline.Summary
$off = $secondsOff.Summary
$on = $secondsOn.Summary

$cpuOffDelta = [math]::Round($off.AverageCpuPercent - $base.AverageCpuPercent, 4)
$cpuOnDelta = [math]::Round($on.AverageCpuPercent - $base.AverageCpuPercent, 4)
$wsOffDelta = [math]::Round($off.AverageWorkingSetMB - $base.AverageWorkingSetMB, 2)
$wsOnDelta = [math]::Round($on.AverageWorkingSetMB - $base.AverageWorkingSetMB, 2)

$cpuName = (Get-CimInstance Win32_Processor | Select-Object -First 1 -ExpandProperty Name).Trim()
$osName = (Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty Caption).Trim()
$ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)

$md = @"
# MinimalClock performance results

Measured on $(Get-Date -Format "yyyy-MM-dd") using **$Seconds seconds per scenario**.

## Test system

- OS: $osName
- CPU: $cpuName
- RAM: $ramGB GB
- Logical processors: $([Environment]::ProcessorCount)

## Results

| Scenario | Avg CPU | Avg working set | Avg private memory |
| --- | ---: | ---: | ---: |
| Rainmeter baseline | $($base.AverageCpuPercent)% | $($base.AverageWorkingSetMB) MB | $($base.AveragePrivateMemoryMB) MB |
| MinimalClock, seconds off | $($off.AverageCpuPercent)% | $($off.AverageWorkingSetMB) MB | $($off.AveragePrivateMemoryMB) MB |
| MinimalClock, seconds on | $($on.AverageCpuPercent)% | $($on.AverageWorkingSetMB) MB | $($on.AveragePrivateMemoryMB) MB |

## Approximate Rainmeter-process delta vs baseline

- Seconds off: **$cpuOffDelta percentage points CPU**, **$wsOffDelta MB working set**
- Seconds on: **$cpuOnDelta percentage points CPU**, **$wsOnDelta MB working set**

These figures describe the measured Rainmeter process on one machine and should not be treated as universal hardware requirements.
"@

$md | Set-Content -Encoding UTF8 -Path $markdownPath

Write-Host ""
Write-Host "Benchmark complete." -ForegroundColor Green
Write-Host "Samples: $csvPath"
Write-Host "Summary: $summaryPath"
Write-Host "Markdown: $markdownPath"
Write-Host ""
Write-Host "CPU delta vs baseline:"
Write-Host "  Seconds off: $cpuOffDelta percentage points"
Write-Host "  Seconds on : $cpuOnDelta percentage points"
