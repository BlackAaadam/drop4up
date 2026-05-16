# Drop4Up App Current Status

Last updated: 2026-05-16

## 1. One-line Status

Drop4Up is currently a Flutter UI prototype with a working 4-tab shell, soft tactile design system, local reflection entry storage, Drop-to-Journal flow, in-session Drop draft handling, Journal management tools, visual card PNG export/share, Profile backup/restore, local preferences, screenshots, and passing automated tests.

It is not yet a production app. Backend, login, cloud sync, real AI, OCR, speech-to-text, payments, push notifications, and production database work are intentionally out of scope for the current phase.

## 2. Completion Level

Current phase: polished Flutter UI prototype.

Estimated state by milestone:

| Area | Status | Notes |
| --- | --- | --- |
| Project setup | Done | Flutter app compiles and runs as a prototype. |
| Tokens | Done | Centralized in `lib/ui/drop4up_tokens.dart`. Required palette is present. |
| Soft surface system | Done | `SoftSurface`, `Drop4UpTactileSurface`, tactile chips/buttons/nav are implemented. |
| 4-tab shell | Done | Exactly `Home / Drop / Journal / Profile`; no center floating Drop button. |
| Home | Functional prototype | Visual reflection card, generated tags, tag selection, carousel-style entry rotation, Journal/Profile handoff. |
| Drop | Functional prototype | Text capture, source chips, manual tags, custom tag dialog, in-session draft retention, local save. |
| Journal | Functional prototype | Search, filters, favorite, edit, delete, visual card preview, PNG export/share. |
| Profile | Functional prototype | Local stats, backup file creation/share, merge/replace restore from file or pasted backup, persisted large-text preference, about. |
| Local persistence | Functional prototype | JSON document storage through repository/controller plus local preferences storage. |
| Automated tests | Passing | `flutter test` passed with 58 tests. |
| Screenshot QA | Present | 393x873 screenshots exist for all main screens. |
| Production readiness | Not started | No auth, backend, real AI/OCR/STT, cloud sync, analytics, payments, release hardening. |

## 3. Implemented App Structure

Main entry:

- `lib/main.dart`
- `Drop4UpPreviewApp`
- `ShellPreviewScreen`

Screens:

- `lib/screens/home_screen.dart`
- `lib/screens/drop_screen.dart`
- `lib/screens/journal_screen.dart`
- `lib/screens/profile_screen.dart`

Shared UI:

- `lib/ui/drop4up_tokens.dart`
- `lib/ui/soft_surface.dart`
- `lib/ui/drop4up_tactile_surface.dart`
- `lib/ui/soft_icon_button.dart`
- `lib/ui/drop4up_tag_chip.dart`
- `lib/ui/primary_drop_button.dart`
- `lib/ui/drop4up_bottom_nav.dart`
- `lib/ui/drop4up_scaffold.dart`
- `lib/ui/reflection_taxonomy.dart`

State and data:

- `lib/state/reflection_entries_controller.dart`
- `lib/state/reflection_entries_scope.dart`
- `lib/state/drop4up_preferences_controller.dart`
- `lib/state/drop4up_preferences_scope.dart`
- `lib/data/reflection_entry.dart`
- `lib/data/reflection_entry_document.dart`
- `lib/data/reflection_entry_repository.dart`
- `lib/data/drop4up_preferences.dart`
- `lib/data/drop4up_preferences_repository.dart`
- `lib/data/profile_backup_file_service.dart`
- `lib/data/visual_card_share_service.dart`

## 4. Design System Status

The required Drop4Up tokens are centralized:

```text
Background        #F2F2EE
Card Surface      #FBFBFA
Primary Blue      #628FBE
Accent Blue       #8FB1D0
Light Blue        #BFD1E3
Text Primary      #2F3438
Text Secondary    #9AA3AD
```

Current visual architecture:

- App background uses the calm warm gray background token.
- Main cards use `#FBFBFA`.
- Primary actions use `#628FBE`.
- Custom tactile surfaces provide raised, inset, pressed, and primary raised states.
- Bottom navigation is custom and tactile with four items only.
- Core app surfaces avoid default Material Card/ElevatedButton/Chip styling.
- The app uses Material only as Flutter foundation/theme infrastructure, while visible UI components are custom.

Important implementation note:

- The active dependency/import is aligned to `flutter_inset_box_shadow`.
- `pubspec.yaml` points to the local path package at `third_party/flutter_inset_box_shadow`.
- Files using inset shadow import `package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart`.

## 5. Navigation Status

Implemented tabs:

1. Home
2. Drop
3. Journal
4. Profile

Confirmed behavior:

- Bottom nav switches between all four screens.
- There is no center floating Drop button.
- There is no hidden fifth tab.
- Home can route into Journal with either all entries or a selected tag/source filter.
- Home and Drop top-right profile affordances open the Profile tab.

## 6. Home Screen

Purpose: visual reflection and gentle discovery, not a timeline.

Implemented:

- Brand header and calm headline.
- Soft visual reflection card.
- Reflection card displays the selected/latest matching user entry when available.
- Empty state fallback reflection text exists.
- Tag/source exploration chips are generated from saved entries.
- Selecting a chip changes the Home reflection context.
- The reflection card can rotate through up to three matching entries with a quiet next control and tappable dots.
- The top-right profile/settings icon opens Profile.
- `查看全部` opens Journal.
- If a Home tag is selected, Journal opens with that tag/source filter applied.

Current limits:

- The reflection canvas is a local custom-painted preview, not generated media.

## 7. Drop Screen

Purpose: quick capture. A sentence is enough.

Implemented:

- Large calm heading.
- Custom-painted quiet leaf decoration.
- Soft entry card.
- Text input with pressed/inset tactile surface.
- Source selection chips:
  - 講道
  - 禱告
  - 靈修
  - 閱讀
  - 其他
- Suggested manual tags:
  - 平安
  - 信心
  - 感恩
  - 愛
- Custom tag dialog via plus chip.
- Save Drop button.
- Empty text validation message.
- Saves exact user text into local controller/repository.
- Clears text and selected tags after successful save.
- Keeps unsaved text, selected source, selected date, and tags while switching between tabs in the current app session.
- Top-right profile icon opens Profile.
- Voice and camera buttons show prototype guidance only.

Current limits:

- No real speech-to-text.
- No real camera/OCR.
- No attachment storage.
- Draft handling is in-session only; it is not written to disk.
- Save path is local prototype persistence only.

## 8. Journal Screen

Purpose: search, organize, edit, tags, recent drops, and visual card preview. It does not behave like a chatbot.

Implemented:

- Search input.
- Search matches:
  - exact Traditional Chinese text content,
  - source,
  - tags,
  - hashtag-style searches such as `#平安`.
- Filter dialog:
  - All,
  - Favorites,
  - Source/tag taxonomy filters.
- Active filter chip with clear action.
- Recent Drops list.
- Entry cards show date, text preview, favorite icon, edit affordance, source/tag mini chips.
- Favorite toggling persists.
- Entry detail dialog:
  - edit text,
  - edit source,
  - edit tags,
  - add custom tags,
  - delete entry with confirmation,
  - save updates.
- Delete persists after reload.
- Visual card preview button.
- Visual card preview dialog uses the first visible entry exactly.
- Visual card preview can be captured as a PNG.
- Visual card PNG files are written locally under `drop4up_visual_cards/`.
- Visual card PNG files are shared through `share_plus`.
- Empty visual-card guidance appears when no entry exists.

Current limits:

- No real AI organization or tag suggestion.
- No full-screen detail page.
- No batch edit or advanced archive states.
- Search is simple local substring matching.

## 9. Profile Screen

Purpose: settings, data control, backup, restore, preferences, about. No gamification.

Implemented:

- Local summary card with:
  - total entries,
  - favorites,
  - source count,
  - tag count,
  - latest entry date.
- Main actions:
  - 備份資料
  - 還原資料
  - 偏好設定
  - 關於 Drop4Up
- Backup flow:
  - exports current reflection document,
  - writes `.drop4up` backup file,
  - filename begins with `Drop4Up_Backup_`,
  - invokes share sheet through `share_plus`.
- Restore flow:
  - choose a backup file via `file_selector`,
  - preview selected backup before restore,
  - paste backup JSON manually,
  - malformed backup content is rejected,
  - valid backup merges by default without overwriting duplicate local entries,
  - replace-all restore remains available through an explicit strategy control.
- Preferences:
  - persisted large-text mode,
  - loaded through `Drop4UpPreferencesRepository`,
  - applied to the app theme.
- About sheet explains prototype scope.

Current limits:

- Backup is local/share-based only, not cloud sync.
- No account/profile identity system.

## 10. Data Model and Persistence

Current model: `ReflectionEntry`

Fields:

- `id`
- `text`
- `source`
- `tags`
- `createdAt`
- `updatedAt`
- `isFavorite`

Storage:

- Local JSON document through `ReflectionEntryRepository`.
- Default file name: `reflection_entries.json`.
- Schema wrapper: `ReflectionEntryDocument`.
- Current schema version is validated.
- Malformed JSON and unsupported schema versions fail clearly.
- Saves are optimistic with rollback on failure in `ReflectionEntriesController`.
- Local preferences JSON through `Drop4UpPreferencesRepository`.

Important guardrail currently covered:

- User-written spiritual text is preserved exactly.
- Tests cover Traditional Chinese text, spaces, and line breaks.

## 11. Tests and Verification

Commands run on 2026-05-16:

```bash
flutter pub get
flutter analyze
flutter test
```

Results:

- `flutter pub get`: passed.
- `flutter analyze`: passed, no issues found.
- `flutter test`: passed, 58 tests.

Test coverage currently includes:

- baseline four-tab navigation,
- Drop save creates entries,
- Drop in-session draft survives tab changes until save,
- saved entries appear in Journal,
- reload loads persisted entries,
- exact Traditional Chinese text preservation,
- selected/manual tag save,
- custom tag add,
- voice/camera placeholder behavior,
- Journal search,
- Journal no-result state,
- hashtag/source/tag filters,
- favorites,
- edit preserving spaces and line breaks,
- edit source and tags,
- delete persistence,
- visual card preview,
- visual card PNG export/share service,
- visual card preview share success and failure states,
- Home reflection entry rotation,
- Home/Drop profile affordances opening Profile,
- repository JSON round-trip and malformed data handling,
- local preferences JSON round-trip and persisted large-text mode,
- profile backup file creation/share,
- merge/replace restore strategy,
- restore from selected `.drop4up` file,
- restore from pasted backup,
- malformed restore rejection.

## 12. Screenshot Artifacts

Latest QA screenshots exist under `handoff/screenshots/`, including:

- `handoff/screenshots/qa_home_393x873.png`
- `handoff/screenshots/qa_drop_393x873.png`
- `handoff/screenshots/qa_journal_393x873.png`
- `handoff/screenshots/qa_profile_393x873.png`
- `handoff/screenshots/drop_qa_393x873.png`
- `handoff/screenshots/drop_qa_360x800.png`
- `handoff/screenshots/drop_taxonomy_393x873.png`
- `handoff/screenshots/journal_taxonomy_393x873.png`
- `handoff/screenshots/profile_main_functions_393x873.png`
- Phase 2/3 interaction screenshots for save, search, favorite, edit, delete, and no-result states.

Primary visual target already represented:

```text
393 x 873 logical px
```

Secondary size represented for Drop:

```text
360 x 800 logical px
```

Screenshot QA note:

- Programmatic verification passed after the visual card PNG export/share work.
- A fresh 393 x 873 screenshot for the visual card dialog has not been added yet because the in-app browser/CDP screenshot capture timed out during manual QA.

## 13. Known Gaps and Risks

Product/function gaps:

- No backend.
- No login/account.
- No cloud sync.
- No production database.
- No real AI.
- No OCR.
- No speech-to-text.
- No push notifications.
- No payments.
- No onboarding.
- No production privacy/security review.

Prototype gaps:

- Drop draft handling is in-session only and is not persisted after app restart.
- Preferences currently include large-text mode only.
- Screenshot QA exists for the main screens, but this file does not include a fresh visual card dialog screenshot after the 2026-05-16 export/share update.

Technical alignment item:

- The app now uses the `flutter_inset_box_shadow` package name through the local path dependency. Keep the local third-party package when running `flutter pub get`.

Repository status note:

- Before this document was added, `git status --short` showed existing untracked screenshot/reference artifacts under `handoff/`.
- Those artifacts appear to be handoff/QA outputs and were not modified by this status document.

## 14. Recommended Next Work

Highest-value next steps:

1. Refresh visual QA evidence, especially the missing 393 x 873 visual-card-dialog screenshot if browser/CDP capture becomes reliable.
2. Review the latest 393 x 873 screenshots against the visual quality bar and tune spacing/shadow/color only where needed.
3. Decide whether Drop draft state should remain in-session only or become a local persisted draft.
4. Decide whether preferences need additional local-only controls beyond large text, such as reduce motion or default Drop source.
5. Clean up handoff/staging only when explicitly requested; preserve existing untracked screenshots/reference artifacts until then.
6. Keep backend, login, AI, OCR, cloud sync, payments, social features, and speech-to-text out of scope unless the prototype phase is explicitly complete.

Recently completed:

- Turned visual card preview into a local PNG export/share artifact.
- Wired Home/Drop profile affordances to Profile.
- Added local persisted large-text preference.
- Added merge/replace restore strategy.
- Aligned inset shadow dependency naming to `flutter_inset_box_shadow`.
- Added Home reflection entry rotation.
- Added in-session Drop draft retention across tab changes.
