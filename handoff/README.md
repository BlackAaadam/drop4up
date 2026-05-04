# Drop4Up Codex Handoff Package V0.4 — Inset Shadow Restart

Purpose: restart Drop4Up Flutter UI work in **Codex**, with a cleaner implementation plan and a stronger soft-neumorphic rendering system based on `flutter_inset_box_shadow`.

This package is intended to be placed at the root of the Drop4Up Flutter repository or attached to Codex as a source-of-truth handoff.

---

## What changed vs the Antigravity package

This handoff assumes we are **restarting UI implementation in Codex**, not continuing the previous Antigravity visual patch loop.

Keep the product and V0.3 design decisions, but rebuild the UI architecture cleanly:

- Keep 4 tabs only: `Home / Drop / Journal / Profile`.
- Keep V0.3 tokens exactly.
- Keep Home frozen conceptually: visual reflection, no timeline.
- Keep Drop as a full quick-entry tab.
- Keep Journal as search / organize / edit / visual card, not a chatbot.
- Keep Profile as calm settings / backup / restore.
- Add `flutter_inset_box_shadow` as a required rendering technique for tactile chips, buttons, inputs, and selected states.

---

## How to use this with Codex

1. Copy or unzip this package into your repository root.
2. Copy `AGENTS.md` into the repository root if it is not already there.
3. Open Codex in the project folder.
4. Paste `CODEX_START_PROMPT.md` as the first task.
5. Ask Codex to implement in milestones, not all at once.
6. After each milestone, ask Codex to run `flutter analyze`, run the app, and capture screenshots.

Recommended starting branch:

```bash
git checkout -b codex/v04-inset-shadow-ui-restart
```

If you already have an experimental UI branch, use a new branch from the cleanest compiling baseline, not from the most visually patched branch.

---

## Package contents

```text
Drop4Up_Codex_Handoff_V0.4_InsetShadow/
├── README.md
├── AGENTS.md
├── CODEX_START_PROMPT.md
├── TASKS.md
├── docs/
│   ├── 00_source_of_truth.md
│   ├── 01_codex_restart_strategy.md
│   ├── 02_flutter_inset_box_shadow_guide.md
│   ├── 03_soft_surface_rendering_rules.md
│   ├── 04_screen_implementation_plan.md
│   ├── 05_acceptance_checklist.md
│   ├── 06_branch_and_worktree_guide.md
│   └── 07_common_failure_modes.md
├── prompts/codex/
│   ├── 01_project_setup.md
│   ├── 02_tokens_and_surface_engine.md
│   ├── 03_home_rebuild.md
│   ├── 04_drop_rebuild.md
│   ├── 05_journal_profile_rebuild.md
│   └── 06_screenshot_review.md
├── flutter_snippets/
│   ├── pubspec_additions.yaml
│   └── lib/
│       ├── ui/drop4up_tokens.dart
│       ├── ui/soft_surface.dart
│       ├── ui/soft_icon_button.dart
│       ├── ui/drop4up_tag_chip.dart
│       ├── ui/primary_drop_button.dart
│       ├── ui/drop4up_bottom_nav.dart
│       └── screens/sample_home_surface_preview.dart
├── references/
│   ├── Home.png
│   ├── Drop.png
│   ├── Journal.png
│   └── Profile.png
└── source_snapshots/
    ├── Drop4Up_V0.3_Spec_Snapshot.md
    ├── Drop4Up_Antigravity_Handoff_V0.3_DETAILED_FULL.md
    └── original planning docs
```

---

## Implementation rule of thumb

Do not ask Codex to “make it beautiful.” Ask Codex to:

1. implement tokens,
2. implement reusable tactile surfaces,
3. replace all cards/chips/buttons/nav with those surfaces,
4. screenshot and compare,
5. adjust only measurable parameters: radius, blur, offset, spread, opacity, padding, font size, contrast.

The goal is not Flutter Material polish. The goal is Drop4Up’s own soft physical surface language.
