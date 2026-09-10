# Learning notes

## 1. Measures and meters are different jobs

A Rainmeter measure retrieves information. A meter draws information. Keeping those responsibilities separate makes the skin easier to reason about.

## 2. Settings are state, not layout

`@Resources/Settings.inc` stores user choices. `MinimalClock.ini` reads them. The Settings skin edits them. That means the settings UI can change without rewriting the rendering logic.

## 3. Persistence should belong to the application

In v0.5 opacity was changed directly through a Rainmeter command. In v0.8 the selected alpha value is first stored in `Settings.inc`, then reapplied whenever the clock refreshes. One source of truth is easier to debug.

## 4. Small software still benefits from measurement

"Lightweight" is a design goal, not a benchmark result. `tools/measure-performance.ps1` measures the Rainmeter process and compares the clock against a baseline before the README publishes numbers.

## 5. Avoid dependencies that do not earn their cost

The native clock does not need React, Electron, Node, a WebView, or a custom Rainmeter plugin. The separate web preview uses browser APIs directly because its requirements are small.

## 6. Distribution changes design decisions

A local prototype can rely on a font already on one computer. A public project needs a license-clean dependency story. v0.8 uses a Windows system font by default and does not ship the development font.

## Optical alignment is not the same as equal coordinates

Typography rarely looks aligned just because two meters share the same numeric `Y` value. Different font sizes have different ascenders, internal padding, and perceived visual centers. In v0.8.2 the 96 pt hour/minute block was moved upward after testing on the actual desktop, even though the underlying coordinates had been technically consistent.

The practical lesson is to use coordinates as a starting point, then validate the visual result at the target scale. For repeated tuning, named values such as `TimeY` and `SecondsX` are easier to reason about than unexplained numbers spread across several meters.
