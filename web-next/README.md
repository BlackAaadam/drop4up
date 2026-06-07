# Drop4Up Web Prototype

React / Next.js / Tailwind / shadcn/ui implementation of the Drop4Up local UI prototype.

## Goals

- Higher-fidelity soft tactile web UI.
- Static export that can be deployed to GitHub Pages.
- Local-only browser data using `localStorage`.
- No backend, login, cloud sync, real AI, OCR, speech-to-text, payments, or production database.

## Commands

```bash
npm run dev
npm run lint
npm run test
npm run build
npm run test:e2e
```

For GitHub Pages, the workflow builds with `GITHUB_PAGES=true` so assets are exported under `/drop4up/`.
