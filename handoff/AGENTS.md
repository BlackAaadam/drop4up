# AGENTS.md — Drop4Up Codex Instructions

## Project identity

Drop4Up is a calm, anti-dopamine spiritual growth journal app. It helps users capture, organize, revisit, and visually reflect on personal spiritual insights.

This repository is currently focused on a Flutter UI prototype only.

## Source of truth

Use these documents first:

1. `docs/00_source_of_truth.md`
2. `docs/02_flutter_inset_box_shadow_guide.md`
3. `docs/03_soft_surface_rendering_rules.md`
4. `docs/04_screen_implementation_plan.md`
5. `docs/05_acceptance_checklist.md`
6. `source_snapshots/Drop4Up_V0.3_Spec_Snapshot.md`

Use reference images only as visual direction. If a reference image conflicts with tokens, the tokens win.

## Hard requirements

- Build UI prototype only.
- Do not implement backend, login, cloud sync, real AI, real OCR, real speech-to-text, payments, or production database.
- Use exactly 4 tabs: `Home / Drop / Journal / Profile`.
- Do not add a center floating Drop button.
- Do not add a hidden 5th tab.
- Do not make Journal look like a chatbot.
- Do not use streaks, ranking, red badges, leaderboards, social likes, social comments, or addictive growth loops.
- Preserve user-written spiritual text. AI may organize or suggest tags, but must not rewrite or generate spiritual content.

## Design tokens are mandatory

Use these exact tokens:

```text
Background        #F2F2EE
Card Surface      #FBFBFA
Primary Blue      #628FBE
Accent Blue       #8FB1D0
Light Blue        #BFD1E3
Text Primary      #2F3438
Text Secondary    #9AA3AD
```

Do not use older values such as `#FAFAFA`, `#7C96A8`, or `#6E8FA3`.

## Rendering architecture

Use custom components, not default Material surfaces.

Required component names or equivalents:

- `Drop4UpTokens`
- `SoftSurface`
- `SoftIconButton`
- `Drop4UpTagChip`
- `PrimaryDropButton`
- `Drop4UpBottomNav`
- `Drop4UpScaffold`
- screen widgets for Home, Drop, Journal, Profile

Use `flutter_inset_box_shadow` for inset/tactile effects. Import correctly:

```dart
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
```

This hide/import pattern is required in files that use `BoxDecoration`, `BoxShadow`, or `inset: true`.

## Flutter workflow

After meaningful changes, run:

```bash
flutter pub get
flutter analyze
flutter test
```

If no tests exist, still run `flutter analyze`.

For UI milestones, run the app and capture screenshots at 393×873 logical px first. 360×800 can be tested later, but the first visual target is 393×873.

## Code style

- Keep widgets small and reusable.
- Keep tokens centralized.
- Do not hard-code colors outside the token file except one-off transparent overlays derived from tokens.
- Prefer explicit parameters over hidden magic constants.
- Avoid large one-file UI implementations.
- Use readable names.
- Leave short comments only for non-obvious rendering choices.

## Visual quality bar

Reject output that looks like:

- default Material app,
- flat SaaS dashboard,
- chatbot UI,
- productivity tracker,
- dense note-taking app,
- bright blue / white generic UI.

Accept output only when:

- cards feel softly raised,
- selected chips/buttons feel physically pressed or pillowy,
- top-left highlights and bottom-right shadows are consistent,
- text is readable for older users,
- the app feels calm within the first glance.
