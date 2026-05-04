# Codex Prompt 06 — Screenshot review and tuning

Run the app and capture screenshots for:

- Home
- Drop
- Journal
- Profile

Primary viewport:

```text
393×873 logical px
```

Compare each screenshot with its reference image:

- `references/Home.png`
- `references/Drop.png`
- `references/Journal.png`
- `references/Profile.png`

For each screen, report:

1. color/token mismatch,
2. depth/shadow mismatch,
3. typography mismatch,
4. spacing/layout mismatch,
5. component mismatch.

Then apply one tuning pass only.

Do not rewrite architecture during screenshot tuning unless a component abstraction is clearly wrong.

Tuning priority:

1. card/background contrast,
2. soft surface depth,
3. tactile chips/buttons/nav,
4. text readability,
5. vertical spacing.

After tuning:

- run `flutter analyze`,
- provide before/after summary.
