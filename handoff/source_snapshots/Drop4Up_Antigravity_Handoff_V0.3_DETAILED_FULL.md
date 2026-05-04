---

<!-- FILE: README.md -->

# Drop4Up Antigravity Handoff Package V0.3 — Detailed

Version: V0.3  
Status: Design freeze for first Flutter UI prototype  
Primary target: Google Antigravity / AI coding agent  
Recommended first build: Flutter UI prototype only, no backend, no real AI, no cloud sync.

---

## 1. What this package is

This package is the updated V0.3 handoff for the Drop4Up app.

Drop4Up is a calm, anti-dopamine, spiritual growth journal app. The app helps users record, revisit, search, organize, and visually transform personal spiritual reflections such as sermon notes, small group sharing, prayer insights, devotional thoughts, and Bible reading reminders.

V0.3 should be treated as the current baseline for implementation.

---

## 2. Important V0.3 decisions

### Navigation

Use exactly 4 tabs:

1. **Home**  
   Visual reflection, memory browsing, tag exploration.  
   No timeline list on Home.

2. **Drop**  
   Dedicated quick-create page.  
   This is not a center floating button anymore.

3. **Journal**  
   Search, organize, edit text, edit tags, create visual cards.  
   Replaces the old "AI Lab" concept.

4. **Profile**  
   Profile, settings, backup, restore, preferences.

### Visual design

Use the V0.3 design tokens:

```text
Background        #F2F2EE
Card Surface      #FBFBFA
Primary Blue      #628FBE
Accent Blue       #8FB1D0
Light Blue        #BFD1E3
Text Primary      #2F3438
Text Secondary    #9AA3AD
```

### UI direction

All 4 tabs should share the same visual feeling as the selected Quick Drop screen:

- Calm
- Bright but not glaring
- Soft neumorphism
- Clear readable typography
- Layered Morandi blue
- Soft white cards
- Gentle shadows
- More readable for older users

---

## 3. How to use this package with Antigravity

1. Upload this whole package to Antigravity.
2. Upload or attach the 4 UI reference images:
   - `references/Home.png`
   - `references/Drop.png`
   - `references/Journal.png`
   - `references/Profile.png`
3. Paste the full prompt from:
   - `ANTIGRAVITY_BUILD_PROMPT.md`
4. Ask Antigravity to build UI prototype first.
5. Require screenshot review after each screen.

---

## 4. First Antigravity objective

Build UI prototype only.

Do not build:

- Backend
- Login
- Cloud sync
- Real AI
- Real speech-to-text
- Real image generation
- Complex database

Build:

- Flutter project structure
- Design tokens
- 4-tab navigation
- Home screen
- Drop screen
- Journal screen
- Profile screen
- Reusable neumorphic components
- Mock data only

---

## 5. Package structure

See `FILE_OVERVIEW.md` for a file-by-file summary.


---

<!-- FILE: FILE_OVERVIEW.md -->

# File Overview — Drop4Up V0.3

This file summarizes what each file in the package contains and how Antigravity should use it.

| File | Purpose | Main content |
|---|---|---|
| `README.md` | Entry point | Explains V0.3 goals, navigation, design freeze, and how to use the package. |
| `ANTIGRAVITY_BUILD_PROMPT.md` | Main build prompt | The exact prompt to paste into Antigravity for the first UI prototype. |
| `docs/00_PROJECT_CONTEXT.md` | Product context | Product vision, spiritual growth use cases, anti-dopamine direction. |
| `docs/01_PRODUCT_REQUIREMENTS.md` | Product requirements | MVP features, non-goals, user stories, phase boundaries. |
| `docs/02_INFORMATION_ARCHITECTURE.md` | Navigation and app structure | Final 4-tab navigation: Home / Drop / Journal / Profile. |
| `docs/03_UI_DESIGN_SPEC_V0.3.md` | Visual design spec | V0.3 visual language, color system, neumorphism, typography, spacing. |
| `docs/04_DESIGN_TOKENS_FLUTTER.md` | Flutter tokens | Dart constants for color, spacing, radius, shadow, typography. |
| `docs/05_SCREEN_BY_SCREEN_SPEC.md` | Screen specs | Detailed specs for Home, Drop, Journal, Profile. |
| `docs/06_COMPONENT_SPEC.md` | Component specs | Neumorphic cards, buttons, tags, search bar, nav, journal cards, visual card CTA. |
| `docs/07_INTERACTION_MOTION_SPEC.md` | Motion rules | Calm transitions, pressed state, haptics, save animation. |
| `docs/08_DATA_MODEL.md` | Data model | ReflectionEntry, Tag, MediaAttachment, VisualCard, BackupEnvelope. |
| `docs/09_AI_RULES.md` | AI guardrails | AI can classify/tag/search local data, but cannot rewrite or invent spiritual content. |
| `docs/10_BACKUP_RESTORE_SPEC.md` | Backup spec | JSON export/import format and validation rules. |
| `docs/11_ACCESSIBILITY_READABILITY.md` | Elder readability | Typography, contrast, touch target, spacing requirements for older users. |
| `docs/12_ACCEPTANCE_CRITERIA.md` | Acceptance rules | What counts as acceptable/rejected UI and MVP behavior. |
| `docs/13_ANTIGRAVITY_WORKFLOW.md` | Build workflow | Step-by-step Antigravity milestones and screenshot review workflow. |
| `docs/14_REFERENCE_IMAGE_GUIDE.md` | Image usage rules | How to use reference images without copying AI artifacts blindly. |
| `docs/15_COPYWRITING.md` | UI copy | Recommended text tone and labels. |
| `prompts/reference_images/*.md` | UI image prompts | Prompts for regenerating Home, Drop, Journal, Profile reference images. |
| `prompts/antigravity/*.md` | Antigravity task prompts | Small milestone prompts for asking Antigravity to build incrementally. |
| `flutter_snippets/drop4up_tokens.dart` | Flutter token file | Ready-to-use Dart design tokens. |
| `flutter_snippets/component_blueprints.md` | Implementation notes | Suggested widget names and responsibilities. |
| `references/README.md` | Reference image notes | How to place and use Home.png / Drop.png / Journal.png / Profile.png. |
| `references/*.png` | Optional images | Current local reference images copied if available. |
| `sources/` | Source material | Original planning/spec files for traceability. |
| `Drop4Up_Antigravity_Handoff_V0.3_FULL.md` | Single-file version | All major docs combined for easy copy/paste. |


---

<!-- FILE: ANTIGRAVITY_BUILD_PROMPT.md -->

# Antigravity Build Prompt — Drop4Up V0.3

You are building the first Flutter UI prototype for **Drop4Up**.

Drop4Up is a calm, anti-dopamine, spiritual growth journal app. It helps users record and revisit personal spiritual reflections from sermons, small groups, devotion, prayer, Bible reading, spiritual books, and daily life.

The first build must focus on UI only. Do not build backend, login, cloud sync, real AI, real speech-to-text, or real image generation yet.

---

## 1. Critical V0.3 navigation

Use exactly 4 tabs in the bottom navigation:

```text
Home | Drop | Journal | Profile
```

Do not use a center-floating Drop button in V0.3.

The Drop tab is a normal tab but visually important. It should feel central to the app, but it should not break the 4-tab bottom navigation.

---

## 2. Screen purposes

### Home

Purpose: visual reflection and gentle memory browsing.

Home should include:

- Inspirational visual reflection card
- Tag exploration
- Calm memory browsing
- No chronological timeline list

Home should not feel like a productivity dashboard.

### Drop

Purpose: quick create-a-drop screen.

Drop should include:

- Large calming header
- Prominent tactile Drop action area
- Text input card
- Source chips: Sermon, Prayer, Devotion, Other
- Optional buttons: voice, camera
- Save Drop button

Drop is the main entry screen for recording.

### Journal

Purpose: search, organize, edit, and create visual cards.

Journal should include:

- Search bar
- Filter button
- Tag chips
- Recent Drops list
- Entry cards with image thumbnail, text, tags, date, favorite indicator
- Create Visual Card CTA

Journal must not look like a chatbot.

### Profile

Purpose: settings, backup, restore, preferences.

Profile should include:

- Gentle summary card
- Backup JSON
- Restore JSON
- Preferences
- About
- Optional reminders toggle
- Calm footer message

Profile should not include streaks, rankings, leaderboards, achievement badges, or social features.

---

## 3. V0.3 design tokens

Use these exact tokens:

```text
Background        #F2F2EE
Card Surface      #FBFBFA
Primary Blue      #628FBE
Accent Blue       #8FB1D0
Light Blue        #BFD1E3
Text Primary      #2F3438
Text Secondary    #9AA3AD
```

Important: Card Surface must be visibly softer and brighter than the background. Do not fall back to #FAFAFA or #FFFFFF. Use #FBFBFA.

---

## 4. Visual style

The app should feel:

- Calm
- Reflective
- Spiritually safe
- Minimal
- Premium
- Soft
- Elder-readable

Use:

- Soft neumorphic cards
- Rounded corners
- Gentle shadows
- Top-left light source
- Clear typography hierarchy
- Layered Morandi blue
- Large negative space

Avoid:

- Bright saturated blue
- Pure white glare
- Red notification badges
- Gamification
- Social media patterns
- Chatbot UI
- Dense productivity dashboards
- Loud gradients
- Confetti

---

## 5. Typography requirements

Use readable typography for older users.

Suggested minimums:

```text
Screen title: 30–36 px equivalent
Section title: 18–22 px
Card title / entry text: 17–20 px
Body text: 15–17 px
Caption: 13–15 px
Bottom nav label: 12–13 px
```

Do not make the text too pale. Use `Text Primary #2F3438` for main text.

---

## 6. Implementation scope

Build only:

- Flutter app shell
- Design tokens
- Reusable components
- 4 screens
- Mock data
- Basic local UI interactions

Do not build:

- Real database
- Real AI
- Real speech-to-text
- Real image generation
- Auth
- Cloud sync

---

## 7. Required folder structure

Create a clean modular Flutter structure:

```text
lib/
  main.dart
  app.dart
  core/
    theme/
      drop4up_tokens.dart
      drop4up_theme.dart
    widgets/
      neumorphic_card.dart
      drop_button.dart
      bottom_nav.dart
      tag_chip.dart
      quiet_search_bar.dart
      reflection_card.dart
  features/
    home/
      home_screen.dart
    drop/
      drop_screen.dart
    journal/
      journal_screen.dart
    profile/
      profile_screen.dart
  mock/
    mock_reflections.dart
  models/
    reflection_entry.dart
    reflection_tag.dart
```

---

## 8. Screenshot review workflow

After implementing each screen:

1. Run the Flutter app.
2. Capture screenshot.
3. Compare against reference image:
   - `references/Home.png`
   - `references/Drop.png`
   - `references/Journal.png`
   - `references/Profile.png`
4. Fix visual differences:
   - Card color
   - Typography hierarchy
   - Shadow softness
   - Spacing
   - Bottom nav consistency
   - Morandi blue tone
5. Provide screenshots as artifacts for review.

---

## 9. Definition of done for first build

The first UI prototype is acceptable when:

- 4 tabs work.
- Every screen uses the same visual language.
- Cards use `#FBFBFA`.
- Background uses `#F2F2EE`.
- Primary blue uses `#628FBE`.
- Text is readable for older users.
- UI feels calm and non-dopamine-driven.
- Journal does not look like chat.
- Home does not include a timeline list.
- Drop is a dedicated quick-entry screen.


---

<!-- FILE: CHANGELOG_V0.3.md -->

# Changelog V0.3

## Major changes from V0.2

1. Navigation changed to 4 tabs:
   - Home
   - Drop
   - Journal
   - Profile

2. Drop changed:
   - From center floating action button
   - To dedicated full screen tab

3. AI Lab renamed:
   - Old: AI Lab / Soul Lab
   - New: Journal
   - Reason: Journal feels more natural and less technical.

4. Home changed:
   - No timeline list
   - Focus on visual reflection and tag exploration

5. Visual system updated:
   - Card Surface changed to #FBFBFA
   - Primary Blue changed to #628FBE
   - Accent Blue changed to #8FB1D0
   - Light Blue added #BFD1E3
   - Text Primary changed to #2F3438
   - Text Secondary changed to #9AA3AD

6. Accessibility updated:
   - Typography should be more readable for older users.
   - Text should be clearer while preserving calm style.

7. Build strategy updated:
   - Build UI prototype first.
   - No backend or real AI in first build.


---

<!-- FILE: docs/00_PROJECT_CONTEXT.md -->

# 00 — Project Context

## Product name

Drop4Up

## One-sentence description

Drop4Up is a calm spiritual growth journal app that helps users record, revisit, organize, and visually remember personal spiritual reflections.

## Core purpose

The app exists to help users remember what they received from:

- Sunday sermons
- Small group sharing
- Worship
- Prayer
- Devotion
- Bible reading
- Spiritual books
- Daily life moments
- Personal promptings or visions

The app should help users keep a rich personal record with God and make those records easy to revisit.

## Emotional direction

Drop4Up should feel:

- Peaceful
- Reflective
- Grounded
- Emotionally safe
- Spiritually sincere
- Encouraging but not pressuring
- Quiet and premium

## Anti-dopamine stance

Drop4Up must not use growth-hacking or addictive patterns.

Avoid:

- Streak pressure
- Red badges
- Ranking
- Leaderboards
- Social likes
- Comments
- Infinite feeds
- Aggressive reminders
- "You are behind" language

## V0.3 product direction

In V0.3, the app is organized into 4 tabs:

```text
Home    = visual reflection and tag exploration
Drop    = quick create a drop
Journal = search, organize, edit, tags, visual cards
Profile = settings, backup, preferences
```

This separation is important:

- Home is emotional and visual.
- Drop is action-focused.
- Journal is organizational.
- Profile is maintenance and control.


---

<!-- FILE: docs/01_PRODUCT_REQUIREMENTS.md -->

# 01 — Product Requirements

## 1. MVP goal

Build a polished Flutter UI prototype first.

The prototype should prove:

- Visual direction
- Navigation structure
- Main screen layout
- Core interaction model
- Information hierarchy
- Design token correctness

It does not need to implement real persistence, AI, or backend.

## 2. MVP feature list

### P0 — UI prototype

- 4-tab bottom navigation
- Home screen
- Drop screen
- Journal screen
- Profile screen
- Mock reflection entries
- Mock tag chips
- Mock visual card CTA
- Soft neumorphic components
- V0.3 design tokens

### P1 — Functional MVP after UI approval

- Create text reflection
- Edit reflection text
- Add/edit/remove tags
- Local search
- Local storage
- JSON backup
- JSON restore
- Mock AI tag suggestion

### P2 — Later features

- Voice-to-text
- Photo attachment
- Share sheet import
- OCR for sermon slides
- Real abstract image generation
- Cloud backup/sync
- Tablet layout

## 3. Non-goals for V0.3 prototype

Do not build:

- Login
- Account system
- Cloud sync
- Social sharing
- Community feed
- Real AI
- Real speech-to-text
- Push notifications
- Payment
- Full database

## 4. User stories

### Home

As a user, I want to open the app and gently remember what matters without seeing a busy task list.

### Drop

As a user, I want to quickly write one sentence or thought without navigating through complex forms.

### Journal

As a user, I want to search, organize, edit, and turn reflections into visual cards.

### Profile

As a user, I want to manage my data safely through backup and restore.

## 5. Product principles

1. Preserve user words.
2. Keep AI as organizer, not author.
3. Make recording low-friction.
4. Make review emotionally gentle.
5. Keep UI readable for older users.
6. Keep data local-first for MVP.


---

<!-- FILE: docs/02_INFORMATION_ARCHITECTURE.md -->

# 02 — Information Architecture

## 1. Final V0.3 navigation

Use 4 tabs:

```text
Home | Drop | Journal | Profile
```

No hidden 5th slot. No center floating Drop button.

## 2. Tab responsibilities

| Tab | Purpose | Included | Excluded |
|---|---|---|---|
| Home | Visual reflection and tag exploration | inspiration card, memory card, tags | timeline list, editing |
| Drop | Quick record | text input, source, voice/camera placeholders, save | search, long history |
| Journal | Organize and search | search, tags, recent drops, edit entry, visual cards | chatbot conversation |
| Profile | Settings and data control | backup, restore, preferences, about | streaks, achievements |

## 3. Why Home has no timeline

Home should feel like a reflective entrance, not a record management screen.

Timeline/history belongs in Journal.

## 4. Why Journal replaces AI Lab

"AI Lab" sounds tool-like and technical. "Journal" better fits the emotional and spiritual context.

AI features should be embedded quietly in Journal:

- tag suggestion
- search
- visual card creation

But the screen must not look like a chatbot.

## 5. Bottom navigation design

Bottom navigation should:

- Use 4 equal tab slots
- Use thin line icons
- Use active blue state
- Use inactive gray state
- Sit inside a soft white neumorphic rounded bar
- Preserve large touch targets
- Avoid badges

Recommended icons:

```text
Home    = house
Drop    = water drop
Journal = book
Profile = person
```


---

<!-- FILE: docs/03_UI_DESIGN_SPEC_V0.3.md -->

# 03 — UI Design Spec V0.3

## 1. Design freeze

V0.3 is the current design baseline.

Primary improvements from earlier versions:

- Card surface updated to `#FBFBFA`.
- Primary blue updated to `#628FBE`.
- Typography is clearer for older users.
- Blue system has multiple layers.
- Navigation is now 4 tabs.
- Drop is now a dedicated tab, not a floating center button.
- Home no longer contains timeline list.

## 2. V0.3 design tokens

```text
Background        #F2F2EE
Card Surface      #FBFBFA
Primary Blue      #628FBE
Accent Blue       #8FB1D0
Light Blue        #BFD1E3
Text Primary      #2F3438
Text Secondary    #9AA3AD
```

## 3. Important color rule

The card color must be visibly different from the background.

Correct:

```text
Background:   #F2F2EE
Card Surface: #FBFBFA
```

Wrong:

```text
Background and card almost identical
Card pure white #FFFFFF
Card too gray / muddy
```

## 4. Visual mood

The app should feel:

- Soft
- Bright
- Calm
- Clear
- Premium
- Gentle
- Spiritual but not decorative
- Reflective but not heavy

## 5. Neumorphism rules

Use soft neumorphism with top-left light source.

Every raised card should have:

- A soft white highlight on top-left
- A warm gray shadow on bottom-right
- Large blur
- Low opacity
- Rounded corners

Avoid:

- Harsh borders
- Black shadows
- Heavy contrast
- Flat white rectangles

## 6. Typography

Typography must be more readable than earlier versions.

Recommended style:

| Element | Size | Weight | Color |
|---|---:|---:|---|
| App logo | 22–26 | 500 | `#628FBE` |
| Hero title | 34–40 | 500–600 | `#2F3438` |
| Screen title | 30–36 | 500–600 | `#2F3438` |
| Section title | 18–22 | 500 | `#2F3438` |
| Entry text | 18–20 | 400–500 | `#2F3438` |
| Body | 15–17 | 400 | `#2F3438` or `#64717C` |
| Caption | 13–15 | 400 | `#9AA3AD` |
| Bottom nav label | 12–13 | 400 | active/inactive state |

## 7. Spacing

Recommended screen padding:

```text
Horizontal: 24–28
Top after safe area: 28–36
Bottom: 104–120
Card internal padding: 18–24
Section spacing: 28–36
Chip gap: 10–14
```

## 8. Radius

```text
Small chips: 18–22
Entry cards: 24–28
Hero cards: 30–36
Bottom nav: 36–44
Input fields: 22–26
Icon buttons: circular
```

## 9. Icons

Use thin line icons with rounded caps.

Icon color:

- Active: `#628FBE`
- Inactive: `#9AA3AD`
- Secondary: `#7C8792`

Avoid filled, cartoon, or high-contrast icons.

## 10. Imagery

Use abstract and gentle spiritual memory imagery:

- mist
- quiet lake
- mountain
- soft clouds
- small water drop
- leaf line art
- warm light

Avoid:

- literal religious imagery by default
- icons that imply doctrinal content
- faces
- dramatic fantasy imagery
- over-decorated scenes


---

<!-- FILE: docs/04_DESIGN_TOKENS_FLUTTER.md -->

# 04 — Flutter Design Tokens

Create this file:

```text
lib/core/theme/drop4up_tokens.dart
```

## Dart code

```dart
import 'package:flutter/material.dart';

class Drop4UpColors {
  static const background = Color(0xFFF2F2EE);
  static const cardSurface = Color(0xFFFBFBFA);

  static const primaryBlue = Color(0xFF628FBE);
  static const accentBlue = Color(0xFF8FB1D0);
  static const lightBlue = Color(0xFFBFD1E3);

  static const textPrimary = Color(0xFF2F3438);
  static const textSecondary = Color(0xFF9AA3AD);

  static const textBody = Color(0xFF55616B);
  static const inactiveIcon = Color(0xFF9AA3AD);
  static const softDivider = Color(0xFFE7E4DD);

  static const highlight = Color(0xFFFFFFFF);
  static const shadowWarm = Color(0xFFD8D3C9);
  static const shadowCool = Color(0xFFE7EBEE);
}

class Drop4UpSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 40.0;
  static const screenX = 24.0;
  static const screenTop = 32.0;
  static const bottomNavReserve = 112.0;
}

class Drop4UpRadius {
  static const chip = 20.0;
  static const input = 24.0;
  static const card = 28.0;
  static const heroCard = 34.0;
  static const bottomNav = 40.0;
  static const circle = 999.0;
}

class Drop4UpShadows {
  static List<BoxShadow> cardRaised = [
    BoxShadow(
      color: Drop4UpColors.highlight.withOpacity(0.92),
      offset: const Offset(-6, -6),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Drop4UpColors.shadowWarm.withOpacity(0.42),
      offset: const Offset(8, 10),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> cardSubtle = [
    BoxShadow(
      color: Drop4UpColors.highlight.withOpacity(0.84),
      offset: const Offset(-3, -3),
      blurRadius: 10,
    ),
    BoxShadow(
      color: Drop4UpColors.shadowWarm.withOpacity(0.28),
      offset: const Offset(4, 5),
      blurRadius: 14,
    ),
  ];

  static List<BoxShadow> blueButton = [
    BoxShadow(
      color: Drop4UpColors.primaryBlue.withOpacity(0.26),
      offset: const Offset(0, 10),
      blurRadius: 22,
    ),
    BoxShadow(
      color: Drop4UpColors.highlight.withOpacity(0.70),
      offset: const Offset(-5, -5),
      blurRadius: 16,
    ),
  ];
}

class Drop4UpDurations {
  static const fast = Duration(milliseconds: 140);
  static const normal = Duration(milliseconds: 240);
  static const slow = Duration(milliseconds: 360);
}

class Drop4UpCurves {
  static const calm = Cubic(0.22, 1.0, 0.36, 1.0);
}
```

## ThemeData suggestion

```dart
ThemeData buildDrop4UpTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Drop4UpColors.background,
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.light(
      background: Drop4UpColors.background,
      surface: Drop4UpColors.cardSurface,
      primary: Drop4UpColors.primaryBlue,
      secondary: Drop4UpColors.accentBlue,
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        height: 1.18,
        color: Drop4UpColors.textPrimary,
        letterSpacing: -0.4,
      ),
      headlineMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 1.22,
        color: Drop4UpColors.textPrimary,
        letterSpacing: -0.3,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: Drop4UpColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.35,
        color: Drop4UpColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: Drop4UpColors.textBody,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: Drop4UpColors.textBody,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Drop4UpColors.textSecondary,
      ),
    ),
  );
}
```


---

<!-- FILE: docs/05_SCREEN_BY_SCREEN_SPEC.md -->

# 05 — Screen-by-Screen Specification

## 1. Shared layout rules

All screens use:

- Background `#F2F2EE`
- Soft white card `#FBFBFA`
- Same bottom navigation
- Same header style
- Same icon styling
- Same neumorphic shadows
- Same typography scale

Each screen should feel like it belongs to the same family as the selected Quick Drop screen.

---

## 2. Home screen

### Purpose

Home is for visual reflection and gentle tag exploration.

It is not for managing the full timeline.

### Must include

1. App logo: `Drop4Up`
2. Profile icon button
3. Hero sentence, for example:
   - `Be still and know He is God.`
   - `Every drop nourishes your spirit.`
4. Subtitle:
   - `Take a moment to pause and remember.`
5. Visual reflection card:
   - Section title: `Today’s Inspiration`
   - One selected reflection text
   - Date and tag
   - Calm image
6. Carousel dots
7. Explore Tags section
8. Tag chips
9. Calm action card:
   - `Take a slow breath`
   - `Come back to what matters.`
10. Bottom nav with Home active

### Must not include

- Timeline list
- Recent entries list
- Productivity stats
- Streaks
- Dashboard metrics

### Design notes

Home should have the most emotional and visual feeling of all screens.

It should feel like opening a quiet reflective space.

---

## 3. Drop screen

### Purpose

Drop is the main creation page.

### Must include

1. App logo
2. Profile icon button
3. Hero title:
   - `Capture your heart.`
4. Subtitle:
   - `A sentence is enough.`
5. Decorative leaf / drop line art
6. Large circular Drop button or drop action surface
7. Quick entry card
8. Text area
9. Character count
10. Source chips:
    - Sermon
    - Prayer
    - Devotion
    - Other
11. Optional actions:
    - Voice
    - Camera
12. Primary save button:
    - `Save Drop`
13. Bottom nav with Drop active

### Save button

Use `Primary Blue #628FBE`.

The button should be visible but not loud.

### Text input

The input area must be large and readable.

Placeholder:

```text
Write something...
```

### Design notes

Drop should be the cleanest screen.

It should make the user feel safe to write only one sentence.

---

## 4. Journal screen

### Purpose

Journal is for searching, organizing, editing, and creating visual cards.

### Must include

1. App logo
2. Profile icon button
3. Screen title:
   - `Journal` or `Your journal`
4. Subtitle:
   - `Search, organize, and revisit your drops.`
5. Search bar
6. Filter button
7. My Tags section
8. Tag chips
9. Optional category segmented control:
   - All Drops
   - Notes
   - Visual Cards
   - Favorites
10. Recent Drops section
11. Entry cards
12. Create visual card CTA
13. Bottom nav with Journal active

### Entry card content

Each entry card includes:

- Thumbnail image
- Original text excerpt
- Tags
- Date/time
- Favorite icon
- More options icon

### Must not include

- Chat bubbles
- AI assistant avatar
- Conversation UI
- Generated spiritual answer box

### Design notes

Journal can contain more information than Home, but it must still feel calm.

The Journal screen is allowed to be more structured, but never dense.

---

## 5. Profile screen

### Purpose

Profile is for settings, backup, restore, and preferences.

### Must include

1. App logo
2. Profile icon button
3. Gentle summary card:
   - `Good morning`
   - `Beloved Child`
   - `You have kept 24 reflections.`
4. Backup JSON card
5. Restore JSON card
6. Preferences card
7. Optional reminders toggle
8. About Drop4Up card
9. Calm footer card:
   - `Take a slow breath`
   - `You are not behind.`
   - `You are becoming.`
10. Bottom nav with Profile active

### Must not include

- Streak count
- Ranking
- Score
- Badge
- Achievement progress
- "You missed" language

### Design notes

Profile should feel like a safe control center, not a performance dashboard.


---

<!-- FILE: docs/06_COMPONENT_SPEC.md -->

# 06 — Component Specification

## 1. Drop4UpScaffold

Base layout wrapper.

Responsibilities:

- Set background color
- Apply safe area
- Provide bottom nav
- Provide consistent page padding
- Reserve bottom nav space

## 2. AppHeader

Used at the top of all screens.

Content:

- Drop4Up logo text
- Optional profile icon button
- Optional decorative element

Style:

- Logo uses Primary Blue
- Profile button is circular soft white
- Profile icon uses Text Secondary

## 3. NeumorphicCard

Base card component.

```text
Color: #FBFBFA
Radius: 28–34
Shadow: soft dual-layer
Padding: 20–24
```

Variants:

- `standard`
- `hero`
- `compact`
- `input`
- `cta`

## 4. TagChip

Used in Home and Journal.

States:

- Normal
- Selected
- Add
- Editable
- Count included

Selected chip:

```text
Background: Light Blue #BFD1E3 with low opacity
Text: Primary Blue #628FBE
```

Normal chip:

```text
Background: Card Surface #FBFBFA
Text: Text Primary #2F3438
```

## 5. BottomNav

4 tabs:

- Home
- Drop
- Journal
- Profile

Active:

- Icon: Primary Blue #628FBE
- Label: Primary Blue #628FBE
- Optional small blue dot

Inactive:

- Icon: Text Secondary #9AA3AD
- Label: Text Secondary #9AA3AD

The bar itself uses:

```text
Background: #FBFBFA
Radius: 40+
Soft shadow
```

## 6. QuietSearchBar

Used in Journal.

Content:

- Search icon
- Placeholder
- Rounded input field

Placeholder:

```text
Search drops, tags, or notes...
```

## 7. ReflectionCard

Used in Journal.

Content:

- Optional thumbnail
- Original text excerpt
- Tags
- Date/time
- Favorite icon
- More button

Important rule:

The text displayed must be the user's original text. It may be visually truncated, but not rewritten.

## 8. VisualReflectionCard

Used in Home and visual card preview.

Content:

- Background image
- Original text overlay
- Date and tags
- Optional frosted card effect

Rule:

The app renders the text. Generated background images should not contain text.

## 9. SourceChip

Used in Drop screen.

Options:

- Sermon
- Prayer
- Devotion
- Other

Selected style uses Light Blue.

## 10. PrimaryButton

Used for Save Drop.

```text
Background: Primary Blue #628FBE
Text: White or very soft white
Radius: 22–28
Height: 56–64
Shadow: blueButton
```

## 11. IconButtonSoft

Used for:

- Profile
- Close
- Filter
- Voice
- Camera
- Add tag

Style:

- Circular
- Card Surface #FBFBFA
- Soft shadow
- Icon color Text Secondary or Primary Blue


---

<!-- FILE: docs/07_INTERACTION_MOTION_SPEC.md -->

# 07 — Interaction and Motion Spec

## 1. Motion principle

Motion should feel calm and physically soft.

Use:

- Fade
- Gentle scale
- Slow ease-out
- Light vertical drift

Avoid:

- Bounce
- Elastic motion
- Confetti
- Fast flashy transitions
- Notification-like motion

## 2. Timing

| Interaction | Duration | Curve |
|---|---:|---|
| Tab switch | 180–240 ms | easeOutCubic |
| Card appear | 240–320 ms | calm cubic |
| Drop button press | 80–140 ms | easeOut |
| Save confirmation | 360–520 ms | calm cubic |
| Search filter open | 220–280 ms | easeOutCubic |

## 3. Pressed state

Buttons should feel physical.

When pressed:

- Scale to 0.97–0.98
- Slightly reduce shadow
- Add optional subtle inset effect
- Trigger light haptic if available

## 4. Save Drop interaction

For prototype:

- Save button press
- Button briefly compresses
- Show calm confirmation state:
  - `Saved`
  - or tiny drop ripple
- No confetti

For later MVP:

- Entry can visually become a small drop
- The drop gently settles into Journal

## 5. Tab transition

Use fade + slight scale.

Do not slide aggressively.

## 6. Haptics

Use haptic lightly for:

- Drop action
- Save Drop
- Tag selection
- Bottom navigation

Do not use heavy or repeated haptic feedback.


---

<!-- FILE: docs/08_DATA_MODEL.md -->

# 08 — Data Model

The first UI prototype can use mock data only, but the model should be designed correctly.

## 1. ReflectionEntry

```dart
enum ReflectionSourceType {
  sermon,
  prayer,
  devotion,
  bibleReading,
  spiritualBook,
  smallGroup,
  dailyLife,
  sharedFromOtherApp,
  voice,
  photo,
  other,
}

class ReflectionEntry {
  final String id;
  final String originalText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReflectionSourceType sourceType;
  final List<String> tags;
  final List<String> suggestedTags;
  final String? moodLabel;
  final String? imagePath;
  final String? audioPath;
  final bool isFavorite;
  final bool isArchived;

  const ReflectionEntry({
    required this.id,
    required this.originalText,
    required this.createdAt,
    required this.updatedAt,
    required this.sourceType,
    this.tags = const [],
    this.suggestedTags = const [],
    this.moodLabel,
    this.imagePath,
    this.audioPath,
    this.isFavorite = false,
    this.isArchived = false,
  });
}
```

## 2. ReflectionTag

```dart
class ReflectionTag {
  final String id;
  final String name;
  final int count;
  final bool isAiSuggested;
  final DateTime createdAt;

  const ReflectionTag({
    required this.id,
    required this.name,
    required this.count,
    required this.isAiSuggested,
    required this.createdAt,
  });
}
```

## 3. VisualCard

```dart
class VisualCard {
  final String id;
  final String reflectionEntryId;
  final String originalText;
  final String backgroundStyle;
  final List<String> palette;
  final DateTime createdAt;

  const VisualCard({
    required this.id,
    required this.reflectionEntryId,
    required this.originalText,
    required this.backgroundStyle,
    required this.palette,
    required this.createdAt,
  });
}
```

## 4. BackupEnvelope

```dart
class BackupEnvelope {
  final String appName;
  final int schemaVersion;
  final DateTime exportedAt;
  final List<ReflectionEntry> entries;
  final List<ReflectionTag> tags;
  final List<VisualCard> visualCards;

  const BackupEnvelope({
    required this.appName,
    required this.schemaVersion,
    required this.exportedAt,
    required this.entries,
    required this.tags,
    required this.visualCards,
  });
}
```

## 5. Repository interface

```dart
abstract class ReflectionRepository {
  Future<List<ReflectionEntry>> getEntries();
  Future<ReflectionEntry?> getEntry(String id);
  Future<void> saveEntry(ReflectionEntry entry);
  Future<void> updateEntry(ReflectionEntry entry);
  Future<void> deleteEntry(String id);
  Future<List<ReflectionEntry>> search(ReflectionSearchQuery query);
}
```

## 6. Search query

```dart
class ReflectionSearchQuery {
  final String? keyword;
  final List<String> tags;
  final DateTime? startDate;
  final DateTime? endDate;
  final ReflectionSourceType? sourceType;
  final bool? favoriteOnly;

  const ReflectionSearchQuery({
    this.keyword,
    this.tags = const [],
    this.startDate,
    this.endDate,
    this.sourceType,
    this.favoriteOnly,
  });
}
```


---

<!-- FILE: docs/09_AI_RULES.md -->

# 09 — AI Rules and Guardrails

## 1. Core principle

AI is an organizer, not an author.

The user's original text is spiritually and emotionally important. It must be preserved.

## 2. Allowed AI behavior

AI may:

- Suggest tags
- Classify source type
- Classify mood/theme
- Search local user records
- Help group entries by tags
- Generate abstract background prompts
- Create visual card background style suggestions

## 3. Forbidden AI behavior

AI must not:

- Rewrite the user's spiritual reflection
- Polish the user's text automatically
- Generate devotional content as if from the user
- Invent Bible verses
- Add doctrine
- Add prophecy
- Search the web for spiritual content
- Replace user wording
- Judge whether the user's content is spiritually correct in the MVP UI

## 4. Data-closed principle

AI output must be based only on:

- User's saved entries
- User-provided data
- Local app state

No web search for MVP.

## 5. Visual card rule

AI may create an abstract background idea, but the frontend renders text separately.

Allowed:

```json
{
  "backgroundStyle": "soft blue-gray mist over a calm lake",
  "palette": ["#F2F2EE", "#BFD1E3", "#8FB1D0"]
}
```

Forbidden:

```json
{
  "rewrittenText": "A more beautiful version of the user's reflection..."
}
```

## 6. Mock AI for prototype

Use deterministic local mock logic:

- Contains "prayer" or "禱告" -> tag `Prayer`
- Contains "grace" or "恩典" -> tag `Grace`
- Contains "faith" or "信心" -> tag `Faith`
- Contains "peace" or "平安" -> tag `Peace`
- Else -> tag `Reflection`


---

<!-- FILE: docs/10_BACKUP_RESTORE_SPEC.md -->

# 10 — Backup and Restore Spec

## 1. MVP backup method

Use JSON export/import.

No account is required for MVP.

## 2. Export includes

- schema version
- export timestamp
- all reflection entries
- tags
- visual cards metadata
- attachment references if available

## 3. JSON shape

```json
{
  "appName": "Drop4Up",
  "schemaVersion": 1,
  "exportedAt": "2026-04-28T00:00:00.000Z",
  "entries": [],
  "tags": [],
  "visualCards": []
}
```

## 4. Restore rules

When importing:

- Validate JSON
- Validate schema version
- Preserve original text
- Preserve created dates
- Avoid duplicate IDs
- Show safe error message on invalid file

## 5. UX copy

Backup:

```text
Backup (JSON)
Export your data safely.
```

Restore:

```text
Restore (JSON)
Import your backup.
```

## 6. Future consideration

Later versions may add encrypted cloud sync, but local JSON backup is sufficient for MVP.


---

<!-- FILE: docs/11_ACCESSIBILITY_READABILITY.md -->

# 11 — Accessibility and Elder Readability

## 1. Why this matters

Drop4Up may be used by older users. Text and controls must be clearer than typical minimalist apps.

## 2. Typography

Minimum recommended sizes:

```text
Hero title: 34 px
Screen title: 32 px
Section title: 20 px
Entry text: 18 px
Body text: 16 px
Caption: 14 px
Bottom nav label: 12–13 px
```

## 3. Contrast

Use `Text Primary #2F3438` for meaningful text.

Avoid overly pale text for:

- Entry content
- Section labels
- Buttons
- Search placeholder if important

## 4. Touch target

Minimum touch target:

```text
44 x 44 px
```

Recommended for older users:

```text
48 x 48 px or larger
```

## 5. Spacing

Use generous spacing between:

- Tags
- Cards
- Bottom nav icons
- Form controls

## 6. Icon clarity

Icons should be thin but not too faint.

Suggested stroke width:

```text
1.75–2.25 px
```

## 7. Do not sacrifice calmness

Improving readability should not mean:

- harsh black text
- saturated colors
- dense layout
- oversized UI

The target is:

```text
clear + soft
```


---

<!-- FILE: docs/12_ACCEPTANCE_CRITERIA.md -->

# 12 — Acceptance Criteria

## 1. UI acceptance

The V0.3 UI is acceptable only if:

- It uses 4 tabs: Home, Drop, Journal, Profile.
- It does not use a center floating Drop button.
- Home has no timeline list.
- Journal contains the timeline/search/organization functions.
- Cards use `#FBFBFA`.
- Background uses `#F2F2EE`.
- Primary blue uses `#628FBE`.
- Text primary uses `#2F3438`.
- Typography is readable for older users.
- The design feels calm at first glance.
- All screens share the same visual language.

## 2. Visual rejection criteria

Reject the output if:

- Card color looks the same as background.
- Card color becomes pure white glare.
- UI looks like a productivity SaaS app.
- UI looks like a chatbot.
- UI uses bright saturated blue.
- UI has red badges.
- UI has streaks or ranking.
- UI has social likes/comments.
- UI feels dense or noisy.

## 3. Screen-specific acceptance

### Home

Accept if:

- It feels visual and reflective.
- It has tag exploration.
- It has no timeline list.

### Drop

Accept if:

- It is a dedicated quick-entry page.
- It has a clear text input area.
- It has source chips and Save Drop button.

### Journal

Accept if:

- It has search and tags.
- It shows entries in a calm list.
- It has create visual card CTA.
- It does not look like chat.

### Profile

Accept if:

- It has backup and restore.
- It has settings.
- It has calm summary.
- It has no performance dashboard.

## 4. Implementation acceptance

First UI prototype is done when:

- Flutter app runs.
- 4 tabs navigate correctly.
- Mock data appears.
- Reusable components are created.
- Token file exists.
- Screenshots can be compared to references.


---

<!-- FILE: docs/13_ANTIGRAVITY_WORKFLOW.md -->

# 13 — Antigravity Workflow

## 1. Recommended build strategy

Do not ask Antigravity to build the whole app at once.

Build in milestones.

## 2. Milestone 1 — Project setup

Prompt:

```text
Create a Flutter app structure for Drop4Up V0.3.
Implement design tokens exactly as specified.
Create empty screens for Home, Drop, Journal, Profile.
Set up 4-tab bottom navigation.
Do not implement backend.
```

## 3. Milestone 2 — Components

Prompt:

```text
Implement reusable Drop4Up UI components:
- NeumorphicCard
- AppHeader
- BottomNav
- TagChip
- QuietSearchBar
- ReflectionCard
- PrimaryButton
- IconButtonSoft
Use the V0.3 tokens exactly.
```

## 4. Milestone 3 — Home

Prompt:

```text
Build Home screen.
No timeline list.
Use visual reflection card and tag exploration.
Match references/Home.png.
```

## 5. Milestone 4 — Drop

Prompt:

```text
Build Drop screen.
Make it a full tab screen for quick entry.
Match references/Drop.png.
Use readable text and soft white cards.
```

## 6. Milestone 5 — Journal

Prompt:

```text
Build Journal screen.
Include search, filters, tags, recent drops, create visual card CTA.
Do not make it look like a chatbot.
Match references/Journal.png.
```

## 7. Milestone 6 — Profile

Prompt:

```text
Build Profile screen.
Include summary, backup, restore, preferences, about.
No streaks or gamification.
Match references/Profile.png.
```

## 8. Milestone 7 — Screenshot review

Prompt:

```text
Run the app and capture screenshots for all four screens.
Compare each screenshot with the corresponding reference image.
Adjust color, shadow, typography, spacing, and cards until the UI matches V0.3.
```

## 9. Milestone 8 — Clean up

Prompt:

```text
Refactor duplicate UI code.
Ensure all colors come from design tokens.
Ensure no one-off hard-coded colors are used except in the token file.
```


---

<!-- FILE: docs/14_REFERENCE_IMAGE_GUIDE.md -->

# 14 — Reference Image Guide

## 1. Required reference images

Use these four reference images:

```text
references/Home.png
references/Drop.png
references/Journal.png
references/Profile.png
```

## 2. How to use images

Images are visual direction, not exact implementation requirements.

Follow:

- Mood
- Spacing
- Shadow softness
- Card brightness
- Typography hierarchy
- Navigation style
- Blue layers

Ignore:

- AI-generated text mistakes
- Inconsistent icons
- Unrealistic details
- Decorative elements not specified in docs
- Any color swatches in image that contradict V0.3 tokens

## 3. V0.3 token priority

If the image conflicts with tokens, the tokens win.

Tokens:

```text
Background        #F2F2EE
Card Surface      #FBFBFA
Primary Blue      #628FBE
Accent Blue       #8FB1D0
Light Blue        #BFD1E3
Text Primary      #2F3438
Text Secondary    #9AA3AD
```

## 4. What to watch out for

AI-generated images may accidentally use older token values such as:

```text
Card Surface #FAFAFA
Primary Blue #7C96A8
Accent Blue #6E8FA3
```

Do not use those older values in V0.3 implementation.

## 5. Screenshot review checklist

For each implemented screen:

- Is background `#F2F2EE`?
- Are cards visibly `#FBFBFA`?
- Is main blue closer to `#628FBE`?
- Is text readable?
- Are cards soft but visible?
- Is UI calm?
- Does bottom nav have 4 tabs?
- Is there no gamification?


---

<!-- FILE: docs/15_COPYWRITING.md -->

# 15 — Copywriting Guide

## 1. Tone

Copy should be:

- Gentle
- Brief
- Encouraging
- Calm
- Non-pressuring

Avoid:

- You are behind
- Keep your streak
- Complete your goal
- Rank up
- Don't miss today
- Challenge

## 2. App header

```text
Drop4Up
```

## 3. Home copy

Hero examples:

```text
Be still and know He is God.
Every drop nourishes your spirit.
Take a moment to pause and remember.
```

Section labels:

```text
Today’s Inspiration
Explore Tags
Take a slow breath
Come back to what matters.
```

## 4. Drop copy

```text
Capture your heart.
A sentence is enough.
What’s on your heart?
Write something...
Source
Add (optional)
Save Drop
```

Source chips:

```text
Sermon
Prayer
Devotion
Other
```

## 5. Journal copy

```text
Journal
Search, organize, and revisit your drops.
Search drops, tags, or notes...
My Tags
Recent Drops
Create a visual card
Turn your reflection into a beautiful image.
```

## 6. Profile copy

```text
Good morning
Beloved Child
You have kept 24 reflections.
Backup (JSON)
Export your data safely.
Restore (JSON)
Import your backup.
Preferences
About Drop4Up
Take a slow breath
You are not behind.
You are becoming.
```

## 7. AI safety copy

If user asks AI to rewrite spiritual content:

```text
Drop4Up keeps your original words as the main record. You can edit the note yourself, and I can help organize it with tags.
```
