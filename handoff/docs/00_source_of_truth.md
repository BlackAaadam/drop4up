# 00 — Source of Truth

## Product definition

Drop4Up is a calm, anti-dopamine spiritual growth journal app that helps users quickly capture, organize, revisit, and visually reflect on personal spiritual insights.

It is not:

- a social app,
- a gamified habit tracker,
- a productivity dashboard,
- a chatbot-first product,
- a content-generation app.

## Current goal

Build a polished Flutter UI prototype first.

Do not build backend, login, cloud sync, database, real AI, OCR, speech-to-text, or push notification systems in this phase.

## Navigation

Use exactly 4 tabs:

```text
Home / Drop / Journal / Profile
```

No center floating Drop button. No hidden 5th slot.

## V0.3 tokens

```text
Background        #F2F2EE
Card Surface      #FBFBFA
Primary Blue      #628FBE
Accent Blue       #8FB1D0
Light Blue        #BFD1E3
Text Primary      #2F3438
Text Secondary    #9AA3AD
```

Hard rule: card surface is `#FBFBFA`, not `#FAFAFA`, not `#FFFFFF`.

## Visual direction

The UI should feel:

- calm,
- reflective,
- spiritually safe,
- warm,
- clean,
- soft,
- premium,
- readable for older users.

## Screen purposes

### Home

Visual reflection and gentle discovery. No timeline list.

### Drop

Quick capture. A sentence is enough.

### Journal

Search, organize, edit, tags, recent drops, create visual cards. Must not look like chatbot.

### Profile

Settings, data control, backup, restore, preferences, about. No streaks or pressure.

## AI guardrail

The user's original spiritual text is sacred user-owned content and must be preserved exactly. AI may suggest tags or organize records, but must not rewrite, invent, or generate spiritual content.
