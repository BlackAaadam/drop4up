# Drop4Up Current Handoff Plan

Last updated: 2026-05-16

## Current App Snapshot

Drop4Up is a polished Flutter UI prototype. The current implementation is local-only and intentionally excludes backend, login, cloud sync, real AI, OCR, speech-to-text, payments, production database work, gamification, and social mechanics.

Implemented baseline:

- Exactly four tabs: `Home / Drop / Journal / Profile`.
- Centralized Drop4Up tokens and soft tactile surfaces using `flutter_inset_box_shadow`.
- Local reflection entry JSON persistence.
- Local preferences JSON persistence for large-text mode.
- Profile backup/share and restore from `.drop4up` or pasted JSON.
- Restore merges by default and keeps an explicit replace-all option.
- Journal search, filters, favorite, edit, delete, and exact text preservation.
- Journal visual card preview exports and shares local PNG files through `share_plus`.
- Home routes to Journal by selected source/tag and can rotate through matching entries.
- Home/Drop profile affordances open Profile.
- Drop keeps unsaved text, selected source, selected date, and tags while switching tabs in the current app session.

Latest verification:

- `flutter pub get`: passed.
- `flutter analyze`: passed.
- `flutter test`: passed with 58 tests.

## Recently Completed

- Visual card preview became a real local PNG export/share artifact.
- `VisualCardShareService` writes files under `drop4up_visual_cards/`.
- `Drop4UpPreviewApp` and `ShellPreviewScreen` support injectable visual card share/capture services for widget tests.
- Home/Drop top-right affordances were wired to Profile.
- Large-text preference was persisted locally and applied to the app theme.
- Restore flow gained merge/replace strategy.
- Inset shadow package naming was aligned to `flutter_inset_box_shadow`.
- Home reflection card gained entry rotation.
- Drop gained in-session draft retention across tab changes.

## Remaining Gaps

Product gaps that are intentionally out of scope:

- No backend, login, cloud sync, production database, AI, OCR, speech-to-text, push notifications, payments, social features, streaks, ranks, badges, likes, or comments.

Prototype gaps still worth considering:

- The visual-card-dialog screenshot at 393 x 873 is still missing because browser/CDP screenshot capture previously timed out.
- Drop draft state is in-session only and does not survive app restart.
- Preferences currently include large-text mode only.
- Latest screenshot artifacts should be reviewed against the visual quality bar before declaring the prototype visually frozen.
- The working tree contains accumulated modified/untracked implementation and handoff artifacts; do not delete or reset them without an explicit cleanup request.

## Next Implementation Plan

### Step 1 - Refresh Visual QA Evidence

Goal: close the remaining screenshot gap and make the handoff visually auditable.

Tasks:

- Run the app at 393 x 873 logical pixels.
- Open Journal, create or use an entry, open the visual card dialog, and capture the missing dialog screenshot if the browser path is reliable.
- Save the screenshot under `handoff/screenshots/` with a clear filename.
- If screenshot capture still times out, keep the current documented limitation and do not block functional work.

Acceptance:

- Existing automated tests still pass.
- If a screenshot is captured, it shows the full dialog without button overflow or cramped card layout.

### Step 2 - Visual Polish Pass

Goal: tune only visible parameters after reviewing current 393 x 873 screenshots.

Tasks:

- Compare Home, Drop, Journal, Profile, and visual-card-dialog screenshots against the visual quality bar.
- Tune only spacing, radius, shadow opacity/blur, typography size, or chip/button density.
- Do not rewrite architecture unless a component abstraction is directly causing a visual defect.

Acceptance:

- UI remains calm, soft, readable, and non-dashboard-like.
- No text overflows in buttons, chips, dialogs, or bottom navigation.
- `flutter analyze` and `flutter test` pass.

### Step 3 - Decide Drop Draft Persistence

Goal: make an explicit product decision instead of leaving draft behavior ambiguous.

Option A: keep current in-session draft.

- Update docs to mark this as intentional.
- No new data model is needed.

Option B: persist Drop draft locally.

- Add a small local draft repository.
- Preserve exact draft text, selected source, selected date, and selected/manual tags.
- Clear persisted draft only after successful save.
- Add repository and widget tests.

Recommended default: keep in-session only unless user testing shows restart-surviving drafts are needed.

### Step 4 - Preferences Expansion Decision

Goal: keep preferences useful without turning Profile into a settings-heavy app.

Candidate local-only preferences:

- Large text: already done.
- Reduce motion: possible if animations become distracting.
- Default Drop source: possible if repeated capture friction appears in testing.

Acceptance:

- Any new preference must be local-only, testable, and clearly useful for the calm journal prototype.
- Do not add account, sync, notification, gamification, or analytics settings.

### Step 5 - Handoff Cleanup Before Commit

Goal: make the branch easier to review when the user asks for staging or commit.

Tasks:

- Review `git status --short`.
- Decide which untracked screenshots/reference files belong in handoff.
- Do not delete existing untracked artifacts without explicit instruction.
- Update `handoff/CURRENT_APP_STATUS.md` after any new implementation or screenshot QA.

Acceptance:

- Handoff docs match the actual app behavior and test count.
- No unrelated generated files are staged by accident.

## Standard Verification

Run after meaningful implementation changes:

```bash
flutter pub get
flutter analyze
flutter test
```

Run after docs-only changes:

```bash
flutter analyze
flutter test
```

For UI milestones, also attempt 393 x 873 screenshot QA first.
