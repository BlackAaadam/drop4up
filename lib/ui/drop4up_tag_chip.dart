import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'drop4up_tokens.dart';

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
        child: AnimatedScale(
          duration: Drop4UpTokens.quickDuration,
          curve: Drop4UpTokens.calmCurve,
          scale: _pressed ? 0.985 : 1,
          child: AnimatedContainer(
            duration: Drop4UpTokens.calmDuration,
            curve: Drop4UpTokens.calmCurve,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Drop4UpTokens.pillRadius),
              color: active
                  ? Drop4UpTokens.lightBlue.withValues(alpha: 0.26)
                  : Drop4UpTokens.cardSurface,
              boxShadow: _chipShadows(active: active, pressed: _pressed),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: textTheme.labelLarge?.copyWith(
                    color: active
                        ? Drop4UpTokens.primaryBlue.withValues(alpha: 0.86)
                        : Drop4UpTokens.primaryBlue.withValues(alpha: 0.76),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (widget.count != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    widget.count.toString(),
                    style: textTheme.labelMedium?.copyWith(
                      color: active
                          ? Drop4UpTokens.primaryBlue.withValues(alpha: 0.68)
                          : Drop4UpTokens.accentBlue.withValues(alpha: 0.72),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _chipShadows({required bool active, required bool pressed}) {
    if (pressed) {
      return [
        BoxShadow(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.58),
          offset: const Offset(1.2, 1.6),
          blurRadius: 3.8,
          spreadRadius: -3.0,
          inset: true,
        ),
        BoxShadow(
          color: Drop4UpTokens.textSecondary.withValues(alpha: 0.30),
          offset: const Offset(-1.8, -2.8),
          blurRadius: 4.8,
          spreadRadius: -3.0,
          inset: true,
        ),
        BoxShadow(
          color: Drop4UpTokens.primaryBlue.withValues(alpha: 0.08),
          offset: const Offset(-1.2, -2.0),
          blurRadius: 4.0,
          spreadRadius: -2.8,
          inset: true,
        ),
        BoxShadow(
          color: Drop4UpTokens.textPrimary.withValues(alpha: 0.035),
          offset: const Offset(0, 4.8),
          blurRadius: 9.5,
          spreadRadius: -7.5,
        ),
      ];
    }

    return [
      BoxShadow(
        color: Drop4UpTokens.textPrimary.withValues(alpha: 0.018),
        offset: const Offset(-0.3, -0.3),
        blurRadius: 1.2,
        spreadRadius: -5.4,
      ),
      BoxShadow(
        color: Drop4UpTokens.textPrimary.withValues(
          alpha: active ? 0.095 : 0.12,
        ),
        offset: const Offset(3.4, 5.2),
        blurRadius: 10.8,
        spreadRadius: -5.6,
      ),
      BoxShadow(
        color: Drop4UpTokens.textPrimary.withValues(alpha: 0.040),
        offset: const Offset(0, 8.8),
        blurRadius: 16.0,
        spreadRadius: -14.5,
      ),
      BoxShadow(
        color: Drop4UpTokens.primaryBlue.withValues(
          alpha: active ? 0.08 : 0.055,
        ),
        offset: const Offset(4.2, 5.4),
        blurRadius: 11.5,
        spreadRadius: -10.5,
      ),
      BoxShadow(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.74),
        offset: const Offset(1.0, 2.6),
        blurRadius: 3.0,
        spreadRadius: -2.8,
        inset: true,
      ),
      BoxShadow(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.52),
        offset: const Offset(0.25, 0.7),
        blurRadius: 0.9,
        spreadRadius: -1.0,
        inset: true,
      ),
      BoxShadow(
        color: Drop4UpTokens.textSecondary.withValues(
          alpha: active ? 0.34 : 0.28,
        ),
        offset: const Offset(-1.5, -3.0),
        blurRadius: 2.8,
        spreadRadius: -2.7,
        inset: true,
      ),
    ];
  }
}
