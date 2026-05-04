# Drop4Up V0.3 Spec Snapshot

Snapshot date: 2026-04-30  
Purpose: This document is a compact but complete handoff snapshot of the current Drop4Up V0.3 product, UI, and Antigravity build direction. It is intended to be copied into another ChatGPT conversation or attached to Google Antigravity as the current source of truth.

---

## 1. One-line product definition

**Drop4Up is a calm, anti-dopamine spiritual growth journal app that helps users quickly capture, organize, revisit, and visually reflect on personal spiritual insights.**

It is not a social app, not a productivity dashboard, not a gamified habit app, and not a chatbot-first product.

---

## 2. Current project goal

The current goal is to define the Drop4Up app features and UI, then produce a design specification and project proposal that can be given to Google Antigravity to build the app.

The immediate development target is:

```text
Build a Flutter UI prototype first.
Do not build backend, login, cloud sync, database, or real AI yet.
Focus on visual correctness, component consistency, and the V0.3 design system.
```

---

## 3. V0.3 design decision summary

V0.3 is the current design baseline.

Important changes from earlier versions:

1. Bottom navigation is now **4 tabs only**.
2. Drop is no longer a centered floating-only action; it is a full dedicated tab/page.
3. AI Lab is renamed/reframed as **Journal**.
4. Home no longer shows a timeline. It focuses on visual reflection and tag exploration.
5. Typography is made slightly clearer for elderly users.
6. Card surfaces are changed to a softer but clearer white.
7. Morandi blue is changed to a more layered and slightly bluer system.

---

## 4. Final V0.3 navigation structure

Use exactly 4 tabs:

```text
Home / Drop / Journal / Profile
```

### 4.1 Home

Purpose: visual reflection and gentle discovery.

Home should include:

- Visual reflection card
- Today’s inspiration / random reflection
- Explore tags
- Gentle memory browsing
- No timeline list
- No dense recent-entry feed

Home should feel like a calm spiritual front page.

### 4.2 Drop

Purpose: quick capture.

Drop should include:

- Full screen quick entry UI
- Large tactile Drop button
- Text input area
- Source chips such as Sermon, Prayer, Devotion, Other
- Optional voice / camera entry icons
- Save Drop button

Drop is the fastest path to create a new record.

### 4.3 Journal

Purpose: search, organize, edit, and create visual cards.

Journal should include:

- Search entries
- Tag filters
- Recent drops / saved entries
- Edit text
- Edit tags
- Favorite / bookmark
- Create visual card

Journal must not look like a chatbot.

### 4.4 Profile

Purpose: settings and data control.

Profile should include:

- Calm personal summary
- Backup JSON
- Restore JSON
- Preferences
- Notifications / reminders if needed, but gentle only
- About Drop4Up

Avoid streaks, rankings, achievement pressure, or social metrics.

---

## 5. V0.3 design tokens — source of truth

These tokens override older versions.

```text
Background        #F2F2EE
Card Surface      #FBFBFA
Primary Blue      #628FBE
Accent Blue       #8FB1D0
Light Blue        #BFD1E3
Text Primary      #2F3438
Text Secondary    #9AA3AD
```

### 5.1 Token meaning

| Token | HEX | Usage |
|---|---:|---|
| Background | `#F2F2EE` | Whole app background; warm neutral creamy gray |
| Card Surface | `#FBFBFA` | Main neumorphic card surface; soft white but not glaring |
| Primary Blue | `#628FBE` | Primary actions, selected tab, main Drop button |
| Accent Blue | `#8FB1D0` | Secondary action, icon accent, visual card accents |
| Light Blue | `#BFD1E3` | Tag background, quiet highlights, gentle tracks |
| Text Primary | `#2F3438` | Main readable text; clearer for older users |
| Text Secondary | `#9AA3AD` | Captions, metadata, inactive icons |

### 5.2 Important color rule

**Card Surface must be `#FBFBFA`, not `#FAFAFA`, not `#FFFFFF`.**

Reason:

- `#FBFBFA` is brighter and clearer than the older card color.
- It improves card/background separation.
- It remains soft and avoids harsh pure white glare.

---

## 6. Typography direction

V0.3 typography should be clearer than earlier versions because the app may be used by elderly users.

Recommended scale:

| Role | Size | Weight | Color |
|---|---:|---:|---|
| App brand | 20–22px | 600 | Primary Blue or Text Primary |
| Page title | 28–36px | 600 | Text Primary |
| Card title | 18–22px | 600 | Text Primary |
| Body | 15–16px | 400 | Text Primary or dark secondary |
| Caption | 12–13px | 400 | Text Secondary |
| Bottom nav label | 11–12px | 400 | Text Secondary / Primary Blue when active |

### 6.1 Typography rule

Text should be more readable, but the app should still feel calm and premium.

Avoid:

- Very tiny text
- Overly pale gray text
- Dense paragraphs
- Dashboard-style numbers
- Loud bold typography

---

## 7. Visual style

Drop4Up uses soft neumorphism.

### 7.1 Visual keywords

- Calm
- Reflective
- Spiritual
- Emotionally safe
- Warm
- Clean
- Soft
- Premium
- Anti-dopamine

### 7.2 Surface and shadow

Use:

- Top-left light source
- Soft raised cards
- Low-contrast warm shadows
- Soft white highlights
- Large radius
- Gentle separation between background and card

Avoid:

- Harsh shadows
- Flat SaaS dashboard style
- Bright white glare
- Saturated colors
- Red badges
- Confetti
- Gamified progress UI

---

## 8. Component direction

Core components:

```text
Drop4UpScaffold
Drop4UpBottomNav
NeumorphicCard
PrimaryDropButton
TagChip
SearchBar
EntryCard
VisualReflectionCard
ProfileSettingCard
SoftIconButton
```

### 8.1 Bottom navigation

Tabs:

```text
Home | Drop | Journal | Profile
```

Use thin line icons:

- Home: house
- Drop: water drop
- Journal: book
- Profile: person

Selected tab uses Primary Blue `#628FBE`.
Inactive tab uses Text Secondary `#9AA3AD`.

### 8.2 Card style

Cards must use:

```text
Card Surface: #FBFBFA
Border radius: 24–32px
Soft shadow: warm low-opacity bottom-right shadow
Soft highlight: top-left white highlight
```

### 8.3 Tag chips

Tag chips should use:

- Light Blue `#BFD1E3` with low opacity for selected state
- Text Primary / Primary Blue for tag text
- Soft rounded pill shape
- Count bubble optional

---

## 9. Screen-by-screen V0.3 spec

## 9.1 Home.png reference direction

Home is **visual reflection, not timeline**.

Must include:

- Drop4Up brand header
- Large reflective title, for example: “Be still and know He is God.” or “Every drop nourishes your spirit.”
- Short subtitle
- Visual reflection card using soft white card and abstract landscape / water image
- Explore Tags section
- Tag pills
- Gentle bottom card such as “Take a slow breath”
- Bottom nav with Home active

Must not include:

- Long timeline
- Productivity metrics
- Streaks
- Social feed
- Loud call-to-action

## 9.2 Drop.png reference direction

Drop is the main quick-capture page.

Must include:

- Drop4Up header
- Large headline, for example: “Capture your heart.”
- Subtitle, for example: “A sentence is enough.”
- Large central Drop button in Primary Blue `#628FBE`
- Soft concentric ring / ripple feel around Drop button
- Entry card with Card Surface `#FBFBFA`
- Text field: “What’s on your heart?”
- Source chips: Sermon, Prayer, Devotion, Other
- Add optional: mic and camera buttons
- Save Drop button in Primary Blue `#628FBE`
- Bottom nav with Drop active

Must feel:

- Fast
- Safe
- Quiet
- Encouraging
- Not like a form-heavy app

## 9.3 Journal.png reference direction

Journal is for search, organize, edit, and create visual cards.

Must include:

- Page title: “Journal”
- Subtitle: “Search, organize, and revisit your drops.”
- Search bar
- Filter button
- Tag chips / category filters
- Recent Drops section
- Entry cards with title, excerpt, date, tags, edit/favorite icon
- Create visual card CTA
- Bottom nav with Journal active

Important:

- Use exact V0.3 tokens.
- Card Surface must be `#FBFBFA`.
- Text Primary must be `#2F3438`.
- Primary Blue must be `#628FBE`.
- Do not use older colors `#FAFAFA`, `#7C96A8`, or `#6E8FA3`.

Must not look like:

- Chatbot
- AI assistant UI
- Productivity dashboard
- Generic note app

## 9.4 Profile.png reference direction

Profile is settings and data control.

Must include:

- Drop4Up header
- Personal summary card
- “You have kept 24 reflections” or similar gentle copy
- Backup JSON
- Restore JSON
- Preferences
- Notifications, if used, must say gentle reminder
- About Drop4Up
- Bottom nav with Profile active

Must avoid:

- Streaks
- Ranking
- Performance graphs
- Achievement badges
- Pressure copy

---

## 10. Product features for MVP

MVP should include:

1. Create text drops
2. Store entries locally or with mock repository initially
3. Tag entries
4. Search entries
5. Edit entry text manually
6. Edit tags manually
7. Create visual card preview
8. Backup JSON
9. Restore JSON
10. Soft navigation across 4 tabs

Do not build in first UI prototype:

- Real backend
- Real cloud sync
- User login
- Real AI model
- Real OCR
- Real speech-to-text
- Group sharing

---

## 11. AI rules and guardrails

AI is allowed to:

- Suggest tags
- Search local user records
- Organize entries
- Create abstract background prompts for visual cards
- Generate metadata only

AI is not allowed to:

- Rewrite the user’s spiritual text
- Generate spiritual content as if it came from the user
- Invent Bible verses
- Search the web
- Interpret doctrine
- Add prophecy or claims
- Replace the user’s original wording

Core rule:

```text
The user's original text is sacred user-owned content and must be preserved exactly.
```

The original concept includes a data-closed principle: AI output should be based only on user-entered data and should not search the web or generate independent spiritual content.

---

## 12. Data model snapshot

Suggested core models:

```dart
class ReflectionEntry {
  final String id;
  final String rawText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReflectionSourceType sourceType;
  final List<String> tags;
  final List<String> suggestedTags;
  final String? moodLabel;
  final String? mediaPath;
  final bool isPinned;
  final bool isArchived;
}

enum ReflectionSourceType {
  sermon,
  prayer,
  devotion,
  bibleReading,
  smallGroup,
  spiritualBook,
  dailyLife,
  sharedFromOtherApp,
  photo,
  voice,
  other,
}
```

Backup:

```json
{
  "schemaVersion": 1,
  "exportedAt": "2026-04-30T00:00:00Z",
  "entries": [],
  "tags": [],
  "visualCards": []
}
```

---

## 13. Flutter implementation priority

Antigravity should build in this order:

```text
1. Create Flutter project structure
2. Add V0.3 design tokens
3. Build reusable components
4. Build 4-tab shell
5. Build Home UI
6. Build Drop UI
7. Build Journal UI
8. Build Profile UI
9. Add mock data
10. Capture screenshots and compare to references
```

Do not start with database, backend, or AI.

---

## 14. Recommended Antigravity first prompt

Use this as the first message to Antigravity:

```text
Use this Drop4Up V0.3 Spec Snapshot as the current source of truth.

Build UI prototype only.
Do not build backend, login, cloud sync, database, or real AI yet.

Use exactly 4 tabs:
Home / Drop / Journal / Profile.

Use the V0.3 design tokens exactly:
Background #F2F2EE
Card Surface #FBFBFA
Primary Blue #628FBE
Accent Blue #8FB1D0
Light Blue #BFD1E3
Text Primary #2F3438
Text Secondary #9AA3AD

Build the app in Flutter.
First create the design token file and reusable components.
Then implement the four screens.

Important UI requirements:
- Soft neumorphic design
- Card Surface must be #FBFBFA
- Typography must be readable for older users
- Home should not contain a timeline
- Drop is a full quick entry tab
- Journal replaces AI Lab and must not look like a chatbot
- Profile contains settings, backup, restore, and preferences

After each screen is implemented, provide a screenshot and compare it with the V0.3 reference image.
```

---

## 15. What to carry into the next conversation

Bring this snapshot plus the V0.3 reference images:

```text
Home.png
Drop.png
Journal.png
Profile.png
```

If the reference images contain slightly wrong colors, always use the V0.3 tokens listed in this snapshot as the source of truth.

---

## 16. Current source-of-truth statement

**Drop4Up V0.3 = 4-tab Flutter UI prototype + soft neumorphic V0.3 design tokens + clearer typography + spiritual reflection journal + strict AI guardrails.**

