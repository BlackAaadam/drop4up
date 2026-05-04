# 05 — Acceptance Checklist

## Global UI acceptance

Accept only if:

- Flutter app runs.
- 4 tabs navigate correctly.
- Design token file exists.
- All major surfaces use custom components.
- Background is `#F2F2EE`.
- Cards are visibly `#FBFBFA`.
- Main blue is `#628FBE`.
- Text primary is `#2F3438`.
- Text is readable for older users.
- Cards feel soft but visible.
- Bottom nav is custom and tactile.
- UI feels calm at first glance.

Reject if:

- UI looks like default Material.
- UI looks like a chatbot.
- UI looks like a SaaS dashboard.
- Cards are pure white glare.
- Cards blend into background.
- Bright saturated blue is used.
- Red badges appear.
- Streaks, rankings, likes, or social metrics appear.
- Text is too tiny or too pale.

## Component acceptance

### SoftSurface

- supports raised, inset, and pressed states,
- uses `flutter_inset_box_shadow`,
- centralizes shadow logic,
- allows radius/padding override.

### TagChip

- selected state feels gently inset or pillowy,
- text is readable,
- wraps safely without overflow.

### BottomNav

- 4 items only,
- active state uses Primary Blue,
- inactive uses Text Secondary,
- rounded tactile nav container,
- no center floating Drop button.

### PrimaryDropButton

- feels like a physical blue drop/pill button,
- press state visibly changes to inset,
- haptic feedback is optional but recommended.

## Screenshot acceptance

Primary screenshot size:

```text
393 × 873 logical px
```

Secondary later:

```text
360 × 800 logical px
```

First optimize for 393×873 to avoid endless responsive tuning.
