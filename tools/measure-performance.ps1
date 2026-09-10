param(
    [int]$Seconds = 60,
    [string]$Output = "minimalclock-performance.csv"
)

$process = Get-Process Rainmeter -ErrorAction Stop | Select-Object -First 1
$logicalProcessors = [Environment]::ProcessorCount
$rows = New-Object System.Collections.Generic.List[object]

$process.Refresh()
$previousCpu = $process.TotalProcessorTime.TotalSeconds
$previousTime = Get-Date

Write-Host "Sampling Rainmeter for $Seconds seconds..."

for ($i = 1; $i -le $Seconds; $i++) {
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
        Timestamp = $now.ToString("o")
        CpuPercent = [math]::Round($cpuPercent, 4)
        WorkingSetMB = [math]::Round($process.WorkingSet64 / 1MB, 2)
        PrivateMemoryMB = [math]::Round($process.PrivateMemorySize64 / 1MB, 2)
    })

    $previousCpu = $cpuNow
    $previousTime = $now
}

$rows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $Output

$avgCpu = ($rows | Measure-Object CpuPercent -Average).Average
$avgWorkingSet = ($rows | Measure-Object WorkingSetMB -Average).Average
$avgPrivate = ($rows | Measure-Object PrivateMemoryMB -Average).Average

Write-Host ""
Write-Host ("Average CPU: {0:N4}%" -f $avgCpu)
Write-Host ("Average working set: {0:N2} MB" -f $avgWorkingSet)
Write-Host ("Average private memory: {0:N2} MB" -f $avgPrivate)
Write-Host "Saved samples to $Output"
