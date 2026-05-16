# Drop4Up Current Handoff Plan

Last updated: 2026-05-17

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
- `flutter test`: passed with 60 tests.

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
- Refreshed visual QA evidence with `handoff/screenshots/visual_card_dialog_393x873.png`.
- Completed a narrow visual polish pass for Drop source chips and Profile footer readability.
- Locked Drop draft behavior as intentionally session-only.
- Locked Profile preferences scope to large-text mode only for this prototype phase.
- Completed stage-ready prototype freeze cleanup and created review commit `f8aa53f` (`Freeze Drop4Up UI prototype`).
- Started local-only beta hardening with Drop save-failure feedback that preserves the unsaved draft.
- Added `handoff/BETA_CHECKLIST.md` to track data safety, failure states, manual QA, and artifact policy for internal beta review.

## Remaining Gaps

Product gaps that are intentionally out of scope:

- No backend, login, cloud sync, production database, AI, OCR, speech-to-text, push notifications, payments, social features, streaks, ranks, badges, likes, or comments.

Prototype decisions:

- Drop draft state is intentionally in-session only and does not survive app restart.
- Preferences intentionally include large-text mode only; reduce motion and default Drop source stay backlog candidates.

Prototype gaps still worth considering:

- Latest screenshot artifacts can still be reviewed as part of a final visual-freeze pass.
- The working tree contains accumulated modified/untracked implementation and handoff artifacts; do not delete or reset them without an explicit cleanup request.

## Next Implementation Plan

### Step 1 - Refresh Visual QA Evidence - Done

Goal: close the remaining screenshot gap and make the handoff visually auditable.

Completed:

- Ran the app through a temporary QA entrypoint at 393 x 873 logical pixels.
- Opened Journal, opened an entry, opened the visual card dialog, and captured the dialog.
- Saved the screenshot as `handoff/screenshots/visual_card_dialog_393x873.png`.
- Verified the full dialog, preview card, and action buttons fit without overflow or cramped layout.

Acceptance:

- Existing automated tests still pass.
- Screenshot shows the full dialog without button overflow or cramped card layout.

### Step 2 - Visual Polish Pass - Done

Goal: tune only visible parameters after reviewing current 393 x 873 screenshots.

Completed:

- Compare Home, Drop, Journal, Profile, and visual-card-dialog screenshots against the visual quality bar.
- Tuned Drop source chip density so all five source chips are visible at 393 px without right-edge text clipping.
- Removed the horizontal chip-row fade mask that made partially visible chip text look like overflow.
- Gave the Profile footer a two-line layout so the local-data note remains readable on 393 px.
- Added visual QA screenshots:
  - `handoff/screenshots/step2_drop_polish_393x873.png`
  - `handoff/screenshots/step2_profile_polish_393x873.png`

Acceptance:

- UI remains calm, soft, readable, and non-dashboard-like.
- No text overflows in buttons, chips, dialogs, or bottom navigation.
- `flutter analyze` and `flutter test` pass.

### Step 3 - Decide Drop Draft Persistence - Done

Goal: make an explicit product decision instead of leaving draft behavior ambiguous.

Decision: keep current in-session draft.

- Switching tabs keeps unsaved text, selected source, selected date, and selected/manual tags in the current app session.
- Restarting or recreating the app shell does not restore unsaved Drop draft content.
- No draft repository, draft JSON, persisted schema, or new data model is added.
- Added widget coverage for the session-only decision.

### Step 4 - Preferences Expansion Decision - Done

Goal: keep preferences useful without turning Profile into a settings-heavy app.

Decision: do not expand preferences in this prototype phase.

- Large text remains the only intentional local preference.
- Reduce motion remains a future backlog candidate if animations become distracting.
- Default Drop source remains a future backlog candidate if repeated capture friction appears in user testing.

Acceptance:

- No account, sync, notification, gamification, or analytics settings are added.

### Step 5 - Handoff Cleanup and Review Commit - Done

Goal: make the branch easier to review and capture the freeze package in git.

Completed:

- Reviewed `git status --short` and staged only the planned freeze files.
- Staged tracked code/docs/test changes plus the latest QA screenshots:
  - `handoff/screenshots/visual_card_dialog_393x873.png`
  - `handoff/screenshots/step2_drop_polish_393x873.png`
  - `handoff/screenshots/step2_profile_polish_393x873.png`
- Left `gfxinfo_*.txt`, `handoff/references/logo.png`, `handoff/references/prototype/`, and older/date-picker/taxonomy QA screenshots untracked and untouched.
- Created review commit `f8aa53f` with message `Freeze Drop4Up UI prototype`.
- Confirmed no git remote is configured, so push/PR is not available until a remote is added.

Acceptance:

- Handoff docs match the actual app behavior and test count.
- No unrelated generated files are staged by accident.
- Freeze package is committed and review-ready locally.

### Step 6 - Local-Only Beta Hardening Kickoff - Done

Goal: move the frozen prototype toward an internal local-only beta without changing schemas, navigation, or product scope.

Completed:

- Added a beta checklist covering data safety, UX failure states, manual QA, and artifact policy.
- Kept `ReflectionEntry`, `ReflectionEntryDocument`, and `Drop4UpPreferences` schemas unchanged.
- Kept Drop draft behavior session-only.
- Added visible Drop save-failure guidance for local repository errors.
- Preserved unsaved Drop text after a failed save attempt.
- Added widget coverage for failed Drop saves.
- Left accumulated untracked QA/reference artifacts untouched.

Acceptance:

- Failed local save does not clear user text.
- Failed local save does not write a partial entry.
- User sees a clear failure message in the Drop screen.
- `flutter pub get`, `flutter analyze`, and `flutter test` pass.

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
