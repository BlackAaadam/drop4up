# 06 — Branch and Worktree Guide

## Recommended branch

```bash
git checkout -b codex/v04-inset-shadow-ui-restart
```

## When to start from main

Start from `main` if:

- it compiles,
- it has less accumulated UI patch complexity,
- old branches have visual work but messy component structure.

## When to start from `ui/option-d-surface-rework`

Start from `ui/option-d-surface-rework` if:

- it compiles,
- it already contains reusable `SoftSurface`-like components,
- Home work is valuable enough to preserve,
- Codex can refactor without breaking the whole app.

## When to avoid a branch

Avoid a branch if:

- `flutter analyze` is noisy,
- UI components are heavily duplicated,
- colors are hard-coded everywhere,
- the branch relies on one-off layout hacks,
- screenshot looks good but architecture is brittle.

## Codex workflow

Use one milestone per Codex task.

Before large UI work:

```bash
git status
flutter analyze
```

After each milestone:

```bash
flutter analyze
git diff --stat
```

Commit only after a milestone compiles and screenshot is acceptable.

Suggested commits:

```text
ui: add Drop4Up V0.3 tokens and inset surface engine
ui: rebuild bottom nav with soft inset surfaces
ui: rebuild Home screen with V0.3 soft surfaces
ui: implement Drop quick entry screen
ui: implement Journal and Profile prototype screens
```
