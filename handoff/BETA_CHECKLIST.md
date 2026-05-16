# Drop4Up Local-Only Beta Checklist

Last updated: 2026-05-17

## Scope

This checklist tracks the next stage after the prototype freeze: a local-only beta that is stable enough for internal device testing.

In scope:

- Local JSON reflection entry storage.
- Local large-text preference storage.
- Local `.drop4up` backup creation and share.
- Restore from selected `.drop4up` file or pasted JSON.
- Journal search, edit, delete, favorite, and visual card share.
- Visible user feedback for important failure states.
- 393 x 873 and 360 x 800 screenshot QA.

Out of scope:

- Backend, login, account model, cloud sync, real AI, OCR, speech-to-text, payments, social features, gamification, push notifications, and production database work.
- Any migration of `ReflectionEntryDocument`.
- Persisted Drop drafts.
- New Profile preferences beyond large-text mode.

## Data Safety

- [x] Preserve `ReflectionEntry`, `ReflectionEntryDocument`, and `Drop4UpPreferences` schemas.
- [x] Preserve user-written spiritual text exactly, including spacing and line breaks.
- [x] Keep Drop draft state session-only.
- [x] Keep controller rollback behavior for failed entry saves.
- [x] Show visible Drop save failure guidance and keep the unsaved text in the input.
- [x] Cover malformed local JSON repository loads.
- [x] Cover unsupported schema versions.
- [x] Cover missing local entry file as an empty document.
- [x] Cover restore merge strategy without overwriting duplicate local entries.
- [x] Cover restore replace strategy.

## UX Failure States

- [x] Drop empty input validation.
- [x] Drop save failure message with draft preservation.
- [x] Journal empty and no-result states.
- [x] Visual card empty guidance.
- [x] Visual card share failure feedback.
- [x] Profile backup/share failure feedback.
- [x] Profile restore preview before applying data.
- [x] Profile malformed restore rejection.

## Manual Beta QA

Primary 393 x 873 pass:

- [x] Home main screen.
- [x] Drop main screen.
- [x] Journal main screen.
- [x] Profile main screen.
- [x] Visual card dialog.

Secondary 360 x 800 pass:

- [x] Drop main screen.
- [ ] Journal main screen.
- [ ] Profile main screen.

Core local beta flows:

- [x] Save a Drop and confirm it appears in Journal.
- [x] Reload app and confirm saved entry remains.
- [x] Search by text, source, tag, and hashtag.
- [x] Edit entry text/source/tags and confirm reload consistency.
- [x] Favorite entry and confirm reload consistency.
- [x] Delete entry and confirm reload consistency.
- [x] Create and share a backup file.
- [x] Restore by merge.
- [x] Restore by replace-all.
- [x] Open visual card preview and share PNG.

## Artifact Policy

Keep the current untracked local artifacts unless a later cleanup request explicitly includes them:

- `gfxinfo_*.txt`
- `handoff/references/logo.png`
- `handoff/references/prototype/`
- older/date-picker/taxonomy QA screenshots not selected for review

For beta review, stage only intentional tracked code, tests, docs, and selected QA screenshots. Do not stage accumulated local artifacts by accident.

## Standard Verification

Run before creating a beta review commit:

```bash
flutter pub get
flutter analyze
flutter test
```

Expected result for this pass:

- `flutter pub get` passes.
- `flutter analyze` reports no issues.
- `flutter test` passes all tests.
