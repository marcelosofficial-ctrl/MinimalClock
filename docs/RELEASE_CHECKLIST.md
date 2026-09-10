# Release checklist

## Functionality

- [ ] Clock loads without Rainmeter log errors
- [ ] 24H mode works
- [ ] 12H mode and AM/PM work
- [ ] Seconds show/hide works
- [ ] Layout closes the seconds gap correctly
- [ ] 80%, 100%, and 125% scale presets work
- [ ] 100%, 80%, and 60% opacity persist after refresh
- [ ] White, Warm, and Ice themes persist after refresh
- [ ] Reset defaults works
- [ ] Position survives Rainmeter restart
- [ ] Rainmeter starts with Windows on a standard installation

## Browser preview

- [ ] Opens directly from `web/index.html`
- [ ] Controls work with mouse and keyboard
- [ ] Preferences survive a reload
- [ ] Mobile-width layout remains usable

## Repository

- [x] README screenshots are current
- [x] Performance table contains real measurements
- [x] Version numbers match
- [x] CHANGELOG updated
- [x] No third-party font binary committed
- [x] License files present
- [ ] `.rmskin` tested on a clean install

## v1.0 release checks

- [ ] Run `tools\validate-project.ps1`
- [x] Run `tools\benchmark-suite.ps1 -Seconds 45`
- [x] Review generated performance results for obvious background-load anomalies
- [x] Capture screenshots using `docs\SCREENSHOTS.md`
- [ ] Test 24H / 12H, seconds on / off, all scale presets, all opacity presets, all themes
- [ ] Test development ZIP installation from a clean `Skins\MinimalClock` folder
- [ ] Create and test the final `.rmskin` with Rainmeter Skin Packager
