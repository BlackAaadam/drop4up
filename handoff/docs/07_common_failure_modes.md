# 07 — Common Failure Modes

## 1. `inset: true` does not compile

Likely cause: wrong import.

Correct:

```dart
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
```

Wrong:

```dart
import 'package:flutter/material.dart';
```

## 2. Codex replaces custom widgets with default Material

Stop and revert. The core UI must use custom surface components.

Forbidden for core surfaces:

- default `Card` elevation,
- default `ElevatedButton`,
- default `NavigationBar`,
- default `Chip` style.

These can still be used internally only if visual styling is fully overridden and does not look like Material defaults.

## 3. Cards look flat

Increase:

- bottom-right shadow blur,
- top-left highlight clarity,
- card/background contrast.

Do not make the shadow black.

## 4. Cards look dirty or heavy

Decrease:

- shadow opacity,
- spread radius,
- gray tint.

Use warmer gray and larger blur.

## 5. Text looks too faint

Use `Text Primary #2F3438` for meaningful text.

Avoid using `Text Secondary #9AA3AD` for important body text.

## 6. Layout overflows on 393×873

Fix in this order:

1. reduce vertical gaps slightly,
2. reduce card internal padding slightly,
3. use flexible spacing,
4. avoid fixed heights unless necessary,
5. allow scroll only where screen content truly exceeds viewport.

Do not shrink text below readability targets.

## 7. UI feels like a productivity dashboard

Remove:

- metrics cards,
- streak language,
- progress rings,
- charts,
- red badges,
- dense recent activity lists.

Add:

- reflection card,
- tag exploration,
- quiet copy,
- negative space.
