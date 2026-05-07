import 'package:flutter/material.dart';

import 'drop4up_tactile_surface.dart';
import 'drop4up_tokens.dart';

class SoftIconButton extends StatefulWidget {
  const SoftIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.label,
    this.selected = false,
    this.size = Drop4UpTokens.iconButtonSize,
    this.iconSize = 23,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? label;
  final bool selected;
  final double size;
  final double iconSize;

  @override
  State<SoftIconButton> createState() => _SoftIconButtonState();
}

class _SoftIconButtonState extends State<SoftIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final selectedOrPressed = widget.selected || _pressed;

    return Semantics(
      button: true,
      label: widget.label,
      selected: widget.selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: Drop4UpTokens.quickDuration,
          curve: Drop4UpTokens.calmCurve,
          scale: _pressed ? 0.975 : 1,
          child: Drop4UpTactileSurface(
            variant: _pressed
                ? Drop4UpTactileSurfaceVariant.pressed
                : selectedOrPressed
                ? Drop4UpTactileSurfaceVariant.inset
                : Drop4UpTactileSurfaceVariant.raised,
            color: selectedOrPressed
                ? Drop4UpTokens.lightBlue.withValues(alpha: 0.28)
                : Drop4UpTokens.cardSurface,
            radius: widget.size / 2,
            width: widget.size,
            height: widget.size,
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: selectedOrPressed
                  ? Drop4UpTokens.primaryBlue
                  : Drop4UpTokens.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
