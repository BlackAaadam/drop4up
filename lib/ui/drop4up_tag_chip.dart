import 'package:flutter/material.dart';

import 'drop4up_tokens.dart';
import 'soft_surface.dart';

class Drop4UpTagChip extends StatefulWidget {
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
  State<Drop4UpTagChip> createState() => _Drop4UpTagChipState();
}

class _Drop4UpTagChipState extends State<Drop4UpTagChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final active = widget.selected || _pressed;

    return Semantics(
      button: widget.onTap != null,
      selected: widget.selected,
      label: widget.count == null
          ? widget.label
          : '${widget.label}, ${widget.count} drops',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.onTap == null
            ? null
            : (_) => setState(() => _pressed = true),
        onTapCancel: widget.onTap == null
            ? null
            : () => setState(() => _pressed = false),
        onTapUp: widget.onTap == null
            ? null
            : (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: SoftSurface(
          variant: active
              ? SoftSurfaceVariant.inset
              : SoftSurfaceVariant.raised,
          color: active
              ? Drop4UpTokens.lightBlue.withValues(alpha: 0.34)
              : Drop4UpTokens.cardSurface,
          radius: Drop4UpTokens.pillRadius,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: textTheme.labelLarge?.copyWith(
                  color: active
                      ? Drop4UpTokens.primaryBlue
                      : Drop4UpTokens.textPrimary,
                ),
              ),
              if (widget.count != null) ...[
                const SizedBox(width: 8),
                Text(
                  widget.count.toString(),
                  style: textTheme.labelMedium?.copyWith(
                    color: active
                        ? Drop4UpTokens.primaryBlue.withValues(alpha: 0.78)
                        : Drop4UpTokens.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
