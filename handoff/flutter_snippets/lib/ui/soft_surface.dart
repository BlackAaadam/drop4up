import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'drop4up_tokens.dart';

enum SoftSurfaceVariant {
  raised,
  inset,
  pressed,
  flat,
}

/// Core Drop4Up tactile surface.
///
/// This is the only place where the soft-neumorphic shadow recipe should live.
/// Cards, chips, buttons, nav items, and input wells should compose this widget
/// instead of recreating shadow stacks in every screen.
class SoftSurface extends StatelessWidget {
  const SoftSurface({
    super.key,
    required this.child,
    this.variant = SoftSurfaceVariant.raised,
    this.color = Drop4UpTokens.cardSurface,
    this.radius = Drop4UpTokens.cardRadius,
    this.padding,
    this.width,
    this.height,
    this.clip = true,
    this.onTap,
  });

  final Widget child;
  final SoftSurfaceVariant variant;
  final Color color;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool clip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final content = AnimatedContainer(
      duration: Drop4UpTokens.calm,
      curve: Drop4UpTokens.calmCurve,
      width: width,
      height: height,
      padding: padding,
      decoration: _decoration(borderRadius),
      child: clip ? ClipRRect(borderRadius: borderRadius, child: child) : child,
    );

    if (onTap == null) return content;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: content,
    );
  }

  BoxDecoration _decoration(BorderRadius borderRadius) {
    switch (variant) {
      case SoftSurfaceVariant.raised:
        return BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Drop4UpTokens.softWhite.withOpacity(0.88),
              color,
              Color.alphaBlend(
                Drop4UpTokens.coolShadow.withOpacity(0.10),
                color,
              ),
            ],
            stops: const [0.0, 0.46, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Drop4UpTokens.softWhite.withOpacity(0.95),
              offset: const Offset(-8, -8),
              blurRadius: 18,
              spreadRadius: -8,
            ),
            BoxShadow(
              color: Drop4UpTokens.warmShadow.withOpacity(0.80),
              offset: const Offset(12, 14),
              blurRadius: 30,
              spreadRadius: -12,
            ),
            BoxShadow(
              color: Drop4UpTokens.coolShadow.withOpacity(0.32),
              offset: const Offset(4, 6),
              blurRadius: 12,
              spreadRadius: -8,
            ),
          ],
        );
      case SoftSurfaceVariant.inset:
        return BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Drop4UpTokens.warmShadow.withOpacity(0.70),
              offset: const Offset(5, 5),
              blurRadius: 12,
              spreadRadius: -2,
              inset: true,
            ),
            BoxShadow(
              color: Drop4UpTokens.softWhite.withOpacity(0.92),
              offset: const Offset(-5, -5),
              blurRadius: 12,
              spreadRadius: -3,
              inset: true,
            ),
          ],
        );
      case SoftSurfaceVariant.pressed:
        return BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.alphaBlend(Drop4UpTokens.warmShadow.withOpacity(0.10), color),
              color,
              Drop4UpTokens.softWhite.withOpacity(0.72),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Drop4UpTokens.warmShadow.withOpacity(0.58),
              offset: const Offset(4, 4),
              blurRadius: 11,
              spreadRadius: -2,
              inset: true,
            ),
            BoxShadow(
              color: Drop4UpTokens.softWhite.withOpacity(0.88),
              offset: const Offset(-4, -4),
              blurRadius: 12,
              spreadRadius: -3,
              inset: true,
            ),
            BoxShadow(
              color: Drop4UpTokens.warmShadow.withOpacity(0.18),
              offset: const Offset(3, 4),
              blurRadius: 10,
              spreadRadius: -7,
            ),
          ],
        );
      case SoftSurfaceVariant.flat:
        return BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        );
    }
  }
}
