# 01 — Codex Restart Strategy

## Why restart in Codex

Previous UI work was heavily iterative. It improved the Home page, but also accumulated visual patches and branch-specific assumptions. For Codex, the cleanest path is to restart the implementation architecture around a few reusable surface components.

## Recommended approach

Treat Codex as an implementation engineer, not a vague designer.

Good task shape:

```text
Implement SoftSurface with raised/inset/pressed variants using flutter_inset_box_shadow.
Replace TagChip and BottomNav with SoftSurface-based components.
Run analyze.
Show changed files.
```

Bad task shape:

```text
Make the app high quality and beautiful.
```

## Branch strategy

Use a fresh branch from the cleanest compiling baseline:

```bash
git checkout -b codex/v04-inset-shadow-ui-restart
```

If choosing between previous branches:

- Prefer the branch that compiles and has the cleanest component structure.
- Do not prefer a branch only because it has the best screenshot if the implementation is messy.
- Preserve useful ideas from old branches as references, not as mandatory code.

## Milestone strategy

Do not ask Codex to build all screens at once.

Order:

1. dependency + tokens,
2. surface engine,
3. shell + bottom nav,
4. Home,
5. Drop,
6. Journal/Profile,
7. screenshots + tuning.

## Review loop

After each visual milestone, ask Codex for:

- changed files,
- screenshot,
- comparison against reference,
- next 3 tuning changes.

Avoid approving large patches without screenshots.
