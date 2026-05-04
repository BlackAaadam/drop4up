import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'drop4up_tokens.dart';
import 'soft_surface.dart';

class SoftIconButton extends StatefulWidget {
  const SoftIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.isSelected = false,
    this.size = 48,
    this.iconSize = 22,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool isSelected;
  final double size;
  final double iconSize;
  final String? semanticLabel;

  @override
  State<SoftIconButton> createState() => _SoftIconButtonState();
}

class _SoftIconButtonState extends State<SoftIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.isSelected;
    final variant = _pressed || selected
        ? SoftSurfaceVariant.inset
        : SoftSurfaceVariant.raised;
    final color = selected
        ? Drop4UpTokens.lightBlue.withOpacity(0.42)
        : Drop4UpTokens.cardSurface;

    return Semantics(
      button: true,
      selected: selected,
      label: widget.semanticLabel,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap?.call();
        },
        child: SoftSurface(
          width: widget.size,
          height: widget.size,
          radius: widget.size / 2,
          color: color,
          variant: variant,
          child: Center(
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: selected
                  ? Drop4UpTokens.primaryBlue
                  : Drop4UpTokens.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
