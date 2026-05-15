import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

import 'drop4up_tokens.dart';

enum SoftSurfaceVariant { raised, prominent, inset, pressed }

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
        gradient: _raisedGradient(color),
        boxShadow: [
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.54),
            offset: const Offset(-2, -2),
            blurRadius: 5,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Drop4UpTokens.warmShadow.withValues(alpha: 0.40),
            offset: const Offset(0, 10),
            blurRadius: 18,
            spreadRadius: -8,
          ),
          BoxShadow(
            color: Drop4UpTokens.coolShadow.withValues(alpha: 0.14),
            offset: const Offset(3, 8),
            blurRadius: 16,
            spreadRadius: -10,
          ),
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.48),
            offset: const Offset(0, 1.6),
            blurRadius: 3.2,
            spreadRadius: -2.8,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.22),
            offset: const Offset(0, 0.8),
            blurRadius: 1,
            spreadRadius: -1,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.coolShadow.withValues(alpha: 0.13),
            offset: const Offset(0, -1.8),
            blurRadius: 3.6,
            spreadRadius: -2.6,
            inset: true,
          ),
        ],
      ),
      SoftSurfaceVariant.prominent => BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        gradient: _raisedGradient(color),
        boxShadow: [
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.58),
            offset: const Offset(-2.2, -2.2),
            blurRadius: 5.8,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Drop4UpTokens.warmShadow.withValues(alpha: 0.58),
            offset: const Offset(0, 14),
            blurRadius: 24,
            spreadRadius: -7,
          ),
          BoxShadow(
            color: Drop4UpTokens.coolShadow.withValues(alpha: 0.26),
            offset: const Offset(5, 11),
            blurRadius: 20,
            spreadRadius: -9,
          ),
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.58),
            offset: const Offset(0.8, 2.1),
            blurRadius: 3.8,
            spreadRadius: -2.6,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.28),
            offset: const Offset(0, 0.8),
            blurRadius: 1,
            spreadRadius: -1,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.coolShadow.withValues(alpha: 0.28),
            offset: const Offset(-1.4, -2.8),
            blurRadius: 4.8,
            spreadRadius: -2.6,
            inset: true,
          ),
        ],
      ),
      SoftSurfaceVariant.inset => BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        gradient: _insetGradient(color),
        boxShadow: [
          BoxShadow(
            color: Drop4UpTokens.warmShadow.withValues(alpha: 0.46),
            offset: const Offset(3, 3),
            blurRadius: 8,
            spreadRadius: -2.4,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.82),
            offset: const Offset(-3, -3),
            blurRadius: 8,
            spreadRadius: -3,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.primaryBlue.withValues(alpha: 0.08),
            offset: const Offset(0, -1.6),
            blurRadius: 3.4,
            spreadRadius: -2.4,
            inset: true,
          ),
        ],
      ),
      SoftSurfaceVariant.pressed => BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        gradient: _pressedGradient(color),
        boxShadow: [
          BoxShadow(
            color: Drop4UpTokens.warmShadow.withValues(alpha: 0.50),
            offset: const Offset(3, 3),
            blurRadius: 9,
            spreadRadius: -2,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.softWhite.withValues(alpha: 0.78),
            offset: const Offset(-3, -3),
            blurRadius: 10,
            spreadRadius: -3,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.coolShadow.withValues(alpha: 0.10),
            offset: const Offset(0, -1.4),
            blurRadius: 3.4,
            spreadRadius: -2.4,
            inset: true,
          ),
          BoxShadow(
            color: Drop4UpTokens.warmShadow.withValues(alpha: 0.16),
            offset: const Offset(0, 6),
            blurRadius: 12,
            spreadRadius: -9,
          ),
        ],
      ),
    };
  }

  LinearGradient _raisedGradient(Color base) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0, 0.14, 0.48, 0.82, 1],
      colors: [
        Color.alphaBlend(Drop4UpTokens.softWhite.withValues(alpha: 0.64), base),
        Color.alphaBlend(Drop4UpTokens.softWhite.withValues(alpha: 0.22), base),
        base,
        Color.alphaBlend(
          Drop4UpTokens.warmShadow.withValues(alpha: 0.06),
          base,
        ),
        Color.alphaBlend(
          Drop4UpTokens.coolShadow.withValues(alpha: 0.08),
          base,
        ),
      ],
    );
  }

  LinearGradient _insetGradient(Color base) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.alphaBlend(
          Drop4UpTokens.coolShadow.withValues(alpha: 0.08),
          base,
        ),
        base,
        Color.alphaBlend(Drop4UpTokens.softWhite.withValues(alpha: 0.24), base),
      ],
    );
  }

  LinearGradient _pressedGradient(Color base) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.alphaBlend(
          Drop4UpTokens.warmShadow.withValues(alpha: 0.12),
          base,
        ),
        base,
        Color.alphaBlend(Drop4UpTokens.softWhite.withValues(alpha: 0.36), base),
      ],
    );
  }
}
