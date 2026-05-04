# Paste this into Codex as the first task

You are working on Drop4Up, a Flutter UI prototype for a calm anti-dopamine spiritual growth journal app.

Read these files first:

- `AGENTS.md`
- `docs/00_source_of_truth.md`
- `docs/02_flutter_inset_box_shadow_guide.md`
- `docs/03_soft_surface_rendering_rules.md`
- `docs/04_screen_implementation_plan.md`
- `docs/05_acceptance_checklist.md`
- `source_snapshots/Drop4Up_V0.3_Spec_Snapshot.md`

Goal: restart the Flutter UI implementation cleanly using the V0.3 design system and `flutter_inset_box_shadow`.

Important constraints:

- UI prototype only.
- Do not build backend, login, cloud sync, database, real AI, OCR, or speech-to-text.
- Use exactly 4 tabs: Home / Drop / Journal / Profile.
- Use V0.3 tokens exactly:
  - Background #F2F2EE
  - Card Surface #FBFBFA
  - Primary Blue #628FBE
  - Accent Blue #8FB1D0
  - Light Blue #BFD1E3
  - Text Primary #2F3438
  - Text Secondary #9AA3AD
- Add `flutter_inset_box_shadow` and use it for tactile inset/pressed/selected surfaces.
- Do not replace custom surfaces with default Material `Card`, `ElevatedButton`, `NavigationBar`, or `Chip` styling.
- Build reusable components first: `Drop4UpTokens`, `SoftSurface`, `SoftIconButton`, `Drop4UpTagChip`, `PrimaryDropButton`, `Drop4UpBottomNav`.

First milestone:

1. Inspect the current repo structure and tell me which files you will modify.
2. Add/verify the dependency in `pubspec.yaml`.
3. Create the token file and surface engine.
4. Build a small preview screen or wire one screen with the new surface engine.
5. Run `flutter pub get` and `flutter analyze`.
6. Show a concise summary of changed files and any compile/analyze issues.

Do not implement all four screens in one huge patch. Work milestone by milestone.
