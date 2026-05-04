import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'drop4up_tokens.dart';
import 'soft_surface.dart';

class Drop4UpTagChip extends StatelessWidget {
  const Drop4UpTagChip({
    super.key,
    required this.label,
    this.count,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final int? count;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = Drop4UpTokens.textTheme().labelMedium!.copyWith(
          color: selected
              ? Drop4UpTokens.primaryBlue
              : Drop4UpTokens.textPrimary.withOpacity(0.78),
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        );

    return SoftSurface(
      variant: selected ? SoftSurfaceVariant.inset : SoftSurfaceVariant.raised,
      radius: Drop4UpTokens.chipRadius,
      color: selected
          ? Drop4UpTokens.lightBlue.withOpacity(0.40)
          : Drop4UpTokens.cardSurface,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: textStyle),
          if (count != null) ...[
            const SizedBox(width: 7),
            Text(
              '$count',
              style: textStyle.copyWith(
                color: Drop4UpTokens.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
