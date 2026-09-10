# Performance testing

MinimalClock is designed to be lightweight, but the repository publishes measured numbers rather than assumptions.

## Method

1. Restart Rainmeter so the process begins from a known state.
2. Load only MinimalClock and any normal skins intentionally included in the test.
3. Leave the desktop idle for one minute.
4. Open PowerShell in the repository root.
5. Run:

```powershell
.\tools\measure-performance.ps1 -Seconds 60
```

The script samples the Rainmeter process once per second and records:

- normalized CPU percentage
- working set memory
- private memory

It writes the raw samples to `minimalclock-performance.csv` and prints the averages.

## Recommended comparison

Run the same test three times:

1. Rainmeter running with MinimalClock unloaded.
2. MinimalClock loaded with seconds hidden.
3. MinimalClock loaded with seconds shown.

The difference between the baseline and each clock run is more useful than quoting Rainmeter's total memory use by itself.

## Published v1.0 measurements

Each scenario was sampled for 45 seconds on Windows 11 Home with an AMD Ryzen 5 7500F, 31.6 GB RAM, and 12 logical processors.

| Configuration | Avg CPU | Avg working set | Avg private memory |
| --- | ---: | ---: | ---: |
| Rainmeter baseline | 0.0029% | 57.86 MB | 67.08 MB |
| MinimalClock, seconds off | 0.0086% | 60.03 MB | 67.45 MB |
| MinimalClock, seconds on | 0.0287% | 60.21 MB | 67.53 MB |

Approximate Rainmeter-process overhead versus baseline:

- seconds hidden: +0.0057 percentage points CPU, +2.17 MB working set
- seconds shown: +0.0258 percentage points CPU, +2.35 MB working set

See `PERFORMANCE_RESULTS.md` for the published result summary.

## Notes

CPU readings at this scale are noisy. Close launchers, browsers, game clients, and other monitoring tools if they are causing frequent system activity. Repeat a test if one run looks obviously abnormal.

The published values describe one measurement session on one machine. They are evidence for this build, not universal hardware requirements or guarantees.

## Guided benchmark

Run:

```powershell
.\tools\benchmark-suite.ps1 -Seconds 45
```

The script pauses between three scenarios so the tester can manually set the correct Rainmeter state:

1. Rainmeter running with MinimalClock unloaded
2. MinimalClock loaded with seconds hidden
3. MinimalClock loaded with seconds shown

It outputs raw samples, a summary CSV, and `PERFORMANCE_RESULTS.md`.
