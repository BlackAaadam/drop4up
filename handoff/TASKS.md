# Drop4Up Codex Task Plan

## Milestone 0 — Baseline decision

- Start from the cleanest branch that compiles.
- Create a new branch:

```bash
git checkout -b codex/v04-inset-shadow-ui-restart
```

- Do not continue from a branch that is visually over-patched and hard to reason about unless it is the only compiling baseline.

## Milestone 1 — Dependency and tokens

- Add `flutter_inset_box_shadow: ^1.0.8`.
- Add `Drop4UpTokens`.
- Ensure `#FBFBFA` is used for card surface.
- Ensure no old palette appears in new files.

Acceptance:

- `flutter pub get` passes.
- `flutter analyze` passes.

## Milestone 2 — Surface engine

Implement:

- `SoftSurface`
- `SoftIconButton`
- `Drop4UpTagChip`
- `PrimaryDropButton`
- `Drop4UpBottomNav`

Acceptance:

- Components compile.
- Pressed/selected/inset state visibly changes the surface.
- No default Material Card/ElevatedButton/Chip visual style is used for core components.

## Milestone 3 — Shell

- Build 4-tab shell.
- Use custom bottom nav.
- Keep screen padding safe for 393×873.

Acceptance:

- Tabs navigate correctly.
- Bottom nav is soft, rounded, and tactile.

## Milestone 4 — Home

- Visual reflection, no timeline.
- Tag exploration.
- Calm footer card.

Acceptance:

- Home looks reflective and not like a productivity dashboard.

## Milestone 5 — Drop

- Quick entry screen.
- Large central tactile Drop button.
- Entry card, text field, source chips, optional mic/camera, Save Drop button.

Acceptance:

- Drop feels fast, safe, quiet, and not form-heavy.

## Milestone 6 — Journal + Profile

- Journal: search, tags, entries, visual card CTA.
- Profile: summary, backup, restore, preferences, about.

Acceptance:

- Journal does not look like chatbot.
- Profile has no gamification.

## Milestone 7 — Screenshot review

- Capture screenshots at 393×873.
- Compare against references.
- Tune only parameters unless architecture is wrong.

Tune order:

1. background/card contrast,
2. card edge highlight,
3. bottom-right shadow softness,
4. radius,
5. text readability,
6. vertical spacing,
7. bottom nav height/position.
