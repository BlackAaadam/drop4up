# Codex Prompt 02 — Tokens and surface engine

Implement the Drop4Up surface engine.

Read:

- `docs/02_flutter_inset_box_shadow_guide.md`
- `docs/03_soft_surface_rendering_rules.md`
- `flutter_snippets/lib/ui/soft_surface.dart`
- `flutter_snippets/lib/ui/soft_icon_button.dart`
- `flutter_snippets/lib/ui/drop4up_tag_chip.dart`
- `flutter_snippets/lib/ui/primary_drop_button.dart`
- `flutter_snippets/lib/ui/drop4up_bottom_nav.dart`

Implement or adapt these components into the actual `lib/` folder.

Hard constraints:

- Use `import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;` in files that use inset shadows.
- Use `flutter_inset_box_shadow` for inset states.
- Do not use default Material visual styles for core cards/chips/buttons/nav.
- All colors must come from tokens.

After implementation:

- run `flutter analyze`,
- provide changed files,
- mention any import/dependency issues.
