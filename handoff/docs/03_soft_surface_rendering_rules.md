# 03 — Soft Surface Rendering Rules

## Goal

Make cards, chips, buttons, and nav look like soft physical surfaces under a top-left light source.

## Shared light model

Use one consistent light model:

```text
Light source: top-left
Highlights: top-left / upper edge
Shadows: bottom-right / lower edge
```

## Color model

Base colors:

- app background: `#F2F2EE`
- raised card: `#FBFBFA`
- blue tactile control: `#628FBE`
- selected chip / quiet accent: `#BFD1E3` with opacity

Never use black shadows. Use warm gray or blue-gray shadows.

## Recommended raised card stack

For large white cards:

1. base fill `#FBFBFA`,
2. subtle top-left white highlight shadow,
3. broader bottom-right warm gray shadow,
4. optional gradient from white top-left to very light gray bottom-right,
5. radius 28–36.

## Recommended inset well stack

For selected chips, search bar, and text field wells:

1. base fill slightly darker than surface or low-opacity light blue,
2. top-left inner gray shadow with `inset: true`,
3. bottom-right inner white highlight with `inset: true`,
4. no harsh border.

## Recommended blue Drop button stack

For the main Drop action:

1. blue base `#628FBE`,
2. gradient top-left lighter, bottom-right slightly deeper,
3. outer bottom-right blue-gray shadow,
4. outer top-left pale highlight,
5. on press: swap into inset shadows.

## Tuning order

When screenshot differs from reference, tune in this order:

1. card/background contrast,
2. shadow opacity,
3. blur radius,
4. offset,
5. surface radius,
6. internal padding,
7. text size/weight.

Do not jump immediately to new widgets or new colors.

## Avoid

- default Material `Card` elevation,
- default `ElevatedButton` styling,
- flat gray rectangles,
- blue shadows on white cards,
- saturated gradients,
- pure white glare,
- tiny low-contrast text.
