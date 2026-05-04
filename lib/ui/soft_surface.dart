import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'drop4up_tokens.dart';

enum SoftSurfaceVariant {
  raised,
  inset,
  pressed,
}

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
  });

  final Widget child;
  final SoftSurfaceVariant variant;
  final Color color;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);

    return AnimatedContainer(
      duration: Drop4UpTokens.calmDuration,
      curve: Drop4UpTokens.calmCurve,
      width: width,
      height: height,
      padding: padding,
      decoration: _decoration(borderRadius),
      child: child,
    );
  }

  BoxDecoration _decoration(BorderRadius borderRadius) {
    return switch (variant) {
      SoftSurfaceVariant.raised => BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Drop4UpTokens.softWhite.withValues(alpha: 0.88),
            color,
            Color.alphaBlend(
              Drop4UpTokens.coolShadow.withValues(alpha: 0.10),
              color,
            ),
          ],
          stops: const [0, 0.48, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.95),
            offset: const Offset(-8, -8),
            blurRadius: 18,
            spreadRadius: -8,
          ),
          BoxShadow(
            color: Drop4UpTokens.warmShadow.withValues(alpha: 0.80),
            offset: const Offset(12, 14),
            blurRadius: 30,
            spreadRadius: -12,
          ),
          BoxShadow(
            color: Drop4UpTokens.coolShadow.withValues(alpha: 0.26),
            offset: const Offset(4, 6),
            blurRadius: 12,
            spreadRadius: -8,
          ),
        ],
      ),
      SoftSurfaceVariant.inset => BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Drop4UpTokens.warmShadow.withValues(alpha: 0.70),
            offset: const Offset(5, 5),
            blurRadius: 12,
            spreadRadius: -2,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.92),
            offset: const Offset(-5, -5),
            blurRadius: 12,
            spreadRadius: -3,
            inset: true,
          ),
        ],
      ),
      SoftSurfaceVariant.pressed => BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
              Drop4UpTokens.warmShadow.withValues(alpha: 0.14),
              color,
            ),
            color,
            Drop4UpTokens.softWhite.withValues(alpha: 0.74),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Drop4UpTokens.warmShadow.withValues(alpha: 0.58),
            offset: const Offset(4, 4),
            blurRadius: 11,
            spreadRadius: -2,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.88),
            offset: const Offset(-4, -4),
            blurRadius: 12,
            spreadRadius: -3,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.warmShadow.withValues(alpha: 0.18),
            offset: const Offset(3, 4),
            blurRadius: 10,
            spreadRadius: -7,
          ),
        ],
      ),
    };
  }
}
