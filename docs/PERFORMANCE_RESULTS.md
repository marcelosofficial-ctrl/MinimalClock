# Published performance results

Measured on 2026-09-07 using **45 seconds per scenario**.

## Test system

- OS: Microsoft Windows 11 Home
- CPU: AMD Ryzen 5 7500F 6-Core Processor
- RAM: 31.6 GB
- Logical processors: 12

## Results

| Scenario | Avg CPU | Avg working set | Avg private memory |
| --- | ---: | ---: | ---: |
| Rainmeter baseline | 0.0029% | 57.86 MB | 67.08 MB |
| MinimalClock, seconds off | 0.0086% | 60.03 MB | 67.45 MB |
| MinimalClock, seconds on | 0.0287% | 60.21 MB | 67.53 MB |

## Approximate Rainmeter-process delta vs baseline

- Seconds off: **+0.0057 percentage points CPU**, **+2.17 MB working set**
- Seconds on: **+0.0258 percentage points CPU**, **+2.35 MB working set**

These figures describe one measurement session on one machine. They are evidence for this build, not universal hardware requirements or guarantees.

See `docs/PERFORMANCE.md` for the benchmark method and `tools/benchmark-suite.ps1` to reproduce the test locally.
