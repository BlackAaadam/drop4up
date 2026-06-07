# Drop4Up Web Progress

Date: 2026-06-07
Branch: `codex/next-web-ui`

## Completed

- Created standalone `web-next/` React / Next.js / Tailwind / shadcn/ui app.
- Implemented static export support for GitHub Pages.
- Added GitHub Actions workflow for Pages deployment.
- Built a mobile-first 393 x 873 app frame with four tabs only: Home, Drop, Journal, Profile.
- Recreated Drop4Up soft tactile visual language with centralized CSS tokens, raised/inset surfaces, soft icon buttons, tag chips, primary Drop button, and bottom nav.
- Implemented local-only browser data with `localStorage`.
- Implemented Drop creation with exact text preservation, source, tags, custom tags, and date selection.
- Implemented Journal search, hashtag/source matching, filters, view all, edit, favorite, delete, and visual card PNG download.
- Implemented Home reflection card, tag discovery, and Journal filter handoff.
- Implemented Profile summary, backup download, restore from pasted/uploaded JSON, merge/replace restore strategy, preferences, and About dialog.
- Preserved UI prototype constraints: no backend, login, cloud sync, real AI, OCR, speech-to-text, payments, production database, gamification, hidden fifth tab, or center floating Drop button.

## Verification

Passed:

- `npm run lint`
- `npm run test`
- `npm run build`
- `npm run test:e2e`
- `GITHUB_PAGES=true npm run build`

Visual check completed in the in-app browser at `http://localhost:3000/` using a 393 x 873 viewport.

## Deployment Notes

- GitHub Pages workflow builds from `web-next/`.
- Workflow sets `GITHUB_PAGES=true`, which enables `/drop4up/` `basePath` and `assetPrefix`.
- The first public sharing target is a static GitHub Pages URL. Each visitor's data remains local to their own browser.

## Remaining Follow-Up

- Enable GitHub Pages in the repository settings if it is not already enabled.
- After pushing, confirm the Actions run completes and the Pages URL loads under `/drop4up/`.
- Future cloud sync, login, shared data, or cross-device persistence should be handled as a separate backend phase.
