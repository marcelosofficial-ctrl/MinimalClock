# Architecture

## Native application

```text
Windows clock
    ↓
Rainmeter Time measures
    ↓
MinimalClock.ini
    ↓
String / image meters
```

Persistent user choices live in `@Resources/Settings.inc`:

```text
Settings.ini
    ↓ !WriteKeyValue
Settings.inc
    ↓ include
MinimalClock.ini
```

The Settings skin is intentionally separate from the main clock. Closing the settings panel therefore has no effect on the clock's update loop.

## Web preview

```text
Date()
  ↓
app.js state
  ↓
DOM
  ↓
styles.css
```

The web preview uses `localStorage` for user preferences. It has no build system and no external dependencies.

## Performance boundaries

The native application performs only local time measures and text rendering. It does not perform network I/O, file polling, browser rendering, or plugin work. Optional measures are disabled when their output is hidden.

## Release boundary

The repository stores source. Rainmeter's Skin Packager creates the distributable `.rmskin` release artifact. User settings should be declared as a variable file during packaging so upgrades can preserve preferences.
