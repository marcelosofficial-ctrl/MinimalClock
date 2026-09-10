# Packaging a release

The public release should be packaged with Rainmeter's own Skin Packager rather than renaming a ZIP file to `.rmskin`.

## Before packaging

- bump the version in both Rainmeter INI files
- run the clock and Settings skin on Windows
- test 12H and 24H modes
- test seconds shown and hidden
- test every scale, opacity, and theme preset
- run the performance benchmark
- verify no unlicensed font file is included
- capture the release screenshot

## Rainmeter Skin Packager

Open Rainmeter Manage and choose **Create .rmskin package...**.

Recommended package settings:

- Name: `MinimalClock`
- Author: `Celo`
- Version: match the release tag
- Root config: `MinimalClock`
- Load after install: `MinimalClock\MinimalClock.ini`
- Minimum Rainmeter: `4.5`
- Variable file: `MinimalClock\@Resources\Settings.inc`

Adding the variable file tells the installer which user settings should be preserved when an existing installation is updated.

After packaging, test the `.rmskin` on a clean Rainmeter install before attaching it to a GitHub release.
