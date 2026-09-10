# Changelog

## 1.0.0 - First stable release

- publishes the first stable MinimalClock release
- ships the validated native Rainmeter clock and settings panel
- includes the matching dependency-free HTML/CSS/JavaScript implementation
- includes measured CPU and memory benchmark results
- includes Windows CI validation and local validation tooling
- includes the final release screenshots and packaging documentation
- aligns project, skin, settings, and packaging metadata on version 1.0.0

## 0.9.1 - Presentation and benchmark complete

- adds the final desktop, close-up, and settings screenshots used for the public README
- publishes the measured 45-second performance benchmark and test-system details
- updates the README from release-candidate notes to portfolio-facing project documentation
- keeps the validated v0.8.3 clock composition unchanged
- prepares the project for final `.rmskin` packaging and clean-install testing

## 0.9.0 - Release candidate

- freezes the validated v0.8.3 clock-face composition
- adds a guided three-scenario performance benchmark
- generates CSV and Markdown benchmark output for publishable measurements
- adds project-wide validation tooling
- adds GitHub Actions validation on push and pull request
- adds release screenshot guidance and privacy checks
- updates release metadata to 0.9.0

## 0.8.3

- Raised the primary hour/minute block by 12 px at 100% scale for better optical alignment with the seconds and date groups.
- Increased seconds from 52 px to 54 px.
- Increased the `SEC` label from 23 px to 30 px and moved it lower to better fill the vertical space beneath the seconds.
- Kept the seconds value and label on the exact same horizontal center line.

## 0.8.2 - Optical alignment pass

- Moved the large hour/minute block 8 px upward at 100% scale to optically align it with the seconds and date columns.
- Increased seconds from 46 to 52 for a stronger secondary hierarchy.
- Increased `SEC` from 18 to 23 and returned it to normal weight so it reads larger and taller without becoming visually heavy.
- Kept the seconds value and `SEC` label on the exact same center axis.
- Pulled the key typography coordinates into named internal layout variables to make future visual tuning easier to understand.
- Updated the browser preview to mirror the native typography changes.
- Added a separate install-ready ZIP workflow so the Rainmeter root folder is harder to install at the wrong nesting level.

## 0.8.1 - Runtime hotfix

- Fixed a Rainmeter runtime bug where `@include` was declared outside an INI section, preventing `Settings.inc` from loading correctly.
- Moved settings includes into `[Variables]` in both the clock and Settings skin.
- Increased seconds from 40 to 46 and centered them on the seconds column.
- Increased the `SEC` label from 16 to 18, made it bold, and aligned its center exactly with the seconds value.
- Added a validation script that catches sectionless INI options such as the include bug before release.

## 0.8.0

- made opacity part of persistent project settings
- added current-state summary to the Rainmeter settings panel
- added reset-to-defaults control
- disabled unused seconds / period measures when hidden
- switched the public default to the Windows system font Segoe UI Light
- removed the third-party development font from the distributable source
- added persistent settings to the web preview with localStorage
- added scale and opacity controls to the web preview
- added accessibility state for the seconds toggle
- added PowerShell development installer
- added repeatable CPU / memory benchmark script
- added packaging and release checklists

## 0.5.0

- added 12H / 24H switching
- added seconds show / hide
- added scale and opacity presets
- added White, Warm, and Ice themes
- added native Rainmeter settings panel
- added dependency-free HTML/CSS/JavaScript preview
- added architecture and learning notes

## 0.2.0

- refined seconds typography and spacing
- removed diagnostic positioning behavior

## 0.1.1

- simplified first-run rendering and fixed startup visibility

## 0.1.0

- initial native Rainmeter prototype
