import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

import 'drop4up_tokens.dart';

enum Drop4UpTactileSurfaceVariant { raised, primaryRaised, inset, pressed }

class Drop4UpTactileSurface extends StatelessWidget {
  const Drop4UpTactileSurface({
    super.key,
    required this.child,
    this.variant = Drop4UpTactileSurfaceVariant.raised,
    this.color = Drop4UpTokens.cardSurface,
    required this.radius,
    this.padding,
    this.width,
    this.height,
  });

  final Widget child;
  final Drop4UpTactileSurfaceVariant variant;
  final Color color;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  static const _warmContact = Color(0xFF2F3438);
  static const _coolContact = Color(0xFF628FBE);
  static const _innerCompression = Color(0xFF9AA3AD);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Drop4UpTokens.calmDuration,
      curve: Drop4UpTokens.calmCurve,
      width: width,
      height: height,
      padding: padding,
      decoration: _decoration(),
      child: child,
    );
  }

  BoxDecoration _decoration() {
    return switch (variant) {
      Drop4UpTactileSurfaceVariant.raised => BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
        boxShadow: _raisedShadows,
      ),
      Drop4UpTactileSurfaceVariant.primaryRaised => BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
        gradient: _primaryGradient(color),
        boxShadow: _primaryRaisedShadows,
      ),
      Drop4UpTactileSurfaceVariant.inset => BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
        boxShadow: _insetShadows,
      ),
      Drop4UpTactileSurfaceVariant.pressed => BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
        boxShadow: _pressedShadows,
      ),
    };
  }

  static final _raisedShadows = [
    BoxShadow(
      color: _warmContact.withValues(alpha: 0.018),
      offset: const Offset(-0.25, -0.25),
      blurRadius: 1.2,
      spreadRadius: -5.2,
    ),
    BoxShadow(
      color: _warmContact.withValues(alpha: 0.105),
      offset: const Offset(3.2, 5.4),
      blurRadius: 10.5,
      spreadRadius: -5.5,
    ),
    BoxShadow(
      color: _warmContact.withValues(alpha: 0.034),
      offset: const Offset(0, 8.5),
      blurRadius: 16,
      spreadRadius: -14,
    ),
    BoxShadow(
      color: _coolContact.withValues(alpha: 0.044),
      offset: const Offset(3.8, 5.2),
      blurRadius: 11,
      spreadRadius: -10,
    ),
    BoxShadow(
      color: const Color(0xFFFFFFFF).withValues(alpha: 0.52),
      offset: const Offset(1.0, 2.4),
      blurRadius: 3.4,
      spreadRadius: -2.8,
      inset: true,
    ),
    BoxShadow(
      color: const Color(0xFFFFFFFF).withValues(alpha: 0.30),
      offset: const Offset(0.2, 0.75),
      blurRadius: 0.9,
      spreadRadius: -1.0,
      inset: true,
    ),
    BoxShadow(
      color: _innerCompression.withValues(alpha: 0.22),
      offset: const Offset(-1.6, -2.9),
      blurRadius: 3.2,
      spreadRadius: -2.8,
      inset: true,
    ),
  ];

  static final _primaryRaisedShadows = [
    BoxShadow(
      color: const Color(0xFFFFFFFF).withValues(alpha: 0.22),
      offset: const Offset(-0.8, -0.8),
      blurRadius: 2.0,
      spreadRadius: -3.0,
    ),
    BoxShadow(
      color: _warmContact.withValues(alpha: 0.20),
      offset: const Offset(3.4, 7.2),
      blurRadius: 13,
      spreadRadius: -5.0,
    ),
    BoxShadow(
      color: _coolContact.withValues(alpha: 0.18),
      offset: const Offset(5.2, 6.6),
      blurRadius: 13,
      spreadRadius: -8.0,
    ),
    BoxShadow(
      color: const Color(0xFFFFFFFF).withValues(alpha: 0.28),
      offset: const Offset(1.0, 2.4),
      blurRadius: 3.2,
      spreadRadius: -2.4,
      inset: true,
    ),
    BoxShadow(
      color: const Color(0xFFFFFFFF).withValues(alpha: 0.16),
      offset: const Offset(0.2, 0.8),
      blurRadius: 1.0,
      spreadRadius: -0.8,
      inset: true,
    ),
    BoxShadow(
      color: _warmContact.withValues(alpha: 0.20),
      offset: const Offset(-1.6, -3.0),
      blurRadius: 4.6,
      spreadRadius: -2.8,
      inset: true,
    ),
  ];

  static final _insetShadows = [
    BoxShadow(
      color: const Color(0xFFFFFFFF).withValues(alpha: 0.62),
      offset: const Offset(1.6, 1.8),
      blurRadius: 4.2,
      spreadRadius: -3.4,
      inset: true,
    ),
    BoxShadow(
      color: const Color(0xFFFFFFFF).withValues(alpha: 0.18),
      offset: const Offset(0.4, 0.8),
      blurRadius: 1.0,
      spreadRadius: -1.0,
      inset: true,
    ),
    BoxShadow(
      color: _innerCompression.withValues(alpha: 0.26),
      offset: const Offset(-2.0, -2.4),
      blurRadius: 5.0,
      spreadRadius: -3.2,
      inset: true,
    ),
    BoxShadow(
      color: _coolContact.withValues(alpha: 0.08),
      offset: const Offset(-1.4, -2.0),
      blurRadius: 4.0,
      spreadRadius: -3.0,
      inset: true,
    ),
  ];

  static final _pressedShadows = [
    BoxShadow(
      color: const Color(0xFFFFFFFF).withValues(alpha: 0.52),
      offset: const Offset(1.4, 1.7),
      blurRadius: 4.0,
      spreadRadius: -3.2,
      inset: true,
    ),
    BoxShadow(
      color: _innerCompression.withValues(alpha: 0.34),
      offset: const Offset(-2.2, -2.8),
      blurRadius: 5.2,
      spreadRadius: -3.0,
      inset: true,
    ),
    BoxShadow(
      color: _coolContact.withValues(alpha: 0.10),
      offset: const Offset(-1.4, -2.0),
      blurRadius: 4.4,
      spreadRadius: -2.8,
      inset: true,
    ),
    BoxShadow(
      color: _warmContact.withValues(alpha: 0.030),
      offset: const Offset(0, 5.0),
      blurRadius: 10,
      spreadRadius: -8,
    ),
  ];

  static LinearGradient _primaryGradient(Color base) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0, 0.32, 0.70, 1],
      colors: [
        Color.alphaBlend(
          Drop4UpTokens.softWhite.withValues(alpha: 0.26),
          Drop4UpTokens.accentBlue,
        ),
        Color.alphaBlend(Drop4UpTokens.softWhite.withValues(alpha: 0.14), base),
        Color.alphaBlend(
          Drop4UpTokens.accentBlue.withValues(alpha: 0.22),
          base,
        ),
        Color.alphaBlend(_warmContact.withValues(alpha: 0.08), base),
      ],
    );
  }
}
