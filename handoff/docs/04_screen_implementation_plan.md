# 04 — Screen Implementation Plan

## Shared shell

Implement a custom `Drop4UpScaffold` that provides:

- background color `#F2F2EE`,
- safe area,
- 24–28 px horizontal padding,
- body slot,
- custom bottom nav,
- bottom padding safe for 393×873.

## Home

Purpose: visual reflection and gentle discovery.

Must include:

- Drop4Up header,
- large reflective title,
- short subtitle,
- visual reflection card,
- explore tags,
- gentle bottom card,
- bottom nav with Home active.

Must not include:

- timeline list,
- productivity metrics,
- streaks,
- social feed,
- loud CTA.

## Drop

Purpose: quick capture.

Must include:

- header,
- headline “Capture your heart.”,
- subtitle “A sentence is enough.”,
- large central tactile Drop button,
- soft ripple/concentric rings,
- entry card with text field,
- source chips: Sermon, Prayer, Devotion, Other,
- optional mic/camera soft icon buttons,
- Save Drop button,
- bottom nav with Drop active.

## Journal

Purpose: search, organize, edit, create visual cards.

Must include:

- title “Journal”,
- subtitle,
- search bar,
- filter button,
- tag filters,
- recent drops,
- entry cards,
- create visual card CTA.

Must not look like chatbot.

## Profile

Purpose: settings and data control.

Must include:

- header,
- calm summary card,
- Backup JSON,
- Restore JSON,
- Preferences,
- About Drop4Up,
- calm footer.

Must avoid:

- streaks,
- rankings,
- performance graphs,
- achievement badges,
- pressure copy.
