# 02 — flutter_inset_box_shadow Guide

## Why this package is used

Flutter's standard `BoxShadow` does not support `inset`. Drop4Up needs inset shadows for tactile chips, buttons, selected tabs, text input wells, and pressed states.

Use `flutter_inset_box_shadow` to extend `BoxDecoration` and `BoxShadow` with `inset: true`.

## Dependency

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_inset_box_shadow: ^1.0.8
```

Run:

```bash
flutter pub get
```

## Required import pattern

In files that use `BoxDecoration`, `BoxShadow`, or `inset: true`, use this import pattern:

```dart
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
```

Do **not** write this in those files:

```dart
import 'package:flutter/material.dart';
```

If you forget to hide the Flutter native `BoxDecoration` and `BoxShadow`, `inset: true` will not compile.

## Surface states

Use three visual states:

### Raised

For cards, nav container, inactive icon buttons.

- bottom-right shadow,
- top-left white highlight,
- subtle top-left gradient.

### Inset

For selected chips, selected nav item, input wells.

- top-left inner dark shadow,
- bottom-right inner light highlight,
- no large outside lift.

### Pressed

For press interactions.

- reduce outside shadow,
- add inset shadows,
- slightly darken or compress visual surface.

## Important caveat

If the dependency fails because of SDK compatibility in the current Flutter project, do not silently remove the effect. Instead:

1. report the exact `flutter pub get` error,
2. test whether the current Flutter/Dart version accepts `^1.0.8`,
3. if needed, vendor a local patched copy or replace with a Dart-3-compatible inset-shadow package while keeping the same component API,
4. preserve `SoftSurface` as the single abstraction so the app code does not care which underlying package is used.

## Files that should use this package

- `soft_surface.dart`
- `soft_icon_button.dart`
- `drop4up_tag_chip.dart`
- `primary_drop_button.dart`
- `drop4up_bottom_nav.dart`
- any custom input well component

## Files that should not need this package

- data models,
- repositories,
- text-only constants,
- business logic.
