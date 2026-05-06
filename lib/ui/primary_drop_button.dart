import 'package:flutter/material.dart';

import 'drop4up_tokens.dart';
import 'soft_surface.dart';

class PrimaryDropButton extends StatefulWidget {
  const PrimaryDropButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon = Icons.water_drop_outlined,
  });

  final String label;
  final VoidCallback onTap;
  final IconData icon;

  @override
  State<PrimaryDropButton> createState() => _PrimaryDropButtonState();
}

class _PrimaryDropButtonState extends State<PrimaryDropButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: Drop4UpTokens.quickDuration,
          curve: Drop4UpTokens.calmCurve,
          scale: _pressed ? 0.985 : 1,
          child: SoftSurface(
            variant: _pressed
                ? SoftSurfaceVariant.pressed
                : SoftSurfaceVariant.raised,
            color: Drop4UpTokens.primaryBlue,
            radius: Drop4UpTokens.pillRadius,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 22, color: Drop4UpTokens.softWhite),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelLarge?.copyWith(
                      color: Drop4UpTokens.softWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
