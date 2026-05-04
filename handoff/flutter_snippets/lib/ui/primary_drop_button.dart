import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'drop4up_tokens.dart';

class PrimaryDropButton extends StatefulWidget {
  const PrimaryDropButton({
    super.key,
    required this.onTap,
    this.size = 118,
    this.icon = Icons.water_drop_outlined,
  });

  final VoidCallback onTap;
  final double size;
  final IconData icon;

  @override
  State<PrimaryDropButton> createState() => _PrimaryDropButtonState();
}

class _PrimaryDropButtonState extends State<PrimaryDropButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        duration: Drop4UpTokens.fast,
        scale: _pressed ? 0.975 : 1.0,
        child: AnimatedContainer(
          duration: Drop4UpTokens.calm,
          curve: Drop4UpTokens.calmCurve,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _pressed
                  ? const [
                      Color(0xFF5B85AE),
                      Drop4UpTokens.primaryBlue,
                      Color(0xFF7EA6CA),
                    ]
                  : const [
                      Color(0xFF8FB1D0),
                      Drop4UpTokens.primaryBlue,
                      Color(0xFF4F789E),
                    ],
            ),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: Drop4UpTokens.deepBlueShadow.withOpacity(0.42),
                      offset: const Offset(5, 6),
                      blurRadius: 13,
                      spreadRadius: -3,
                      inset: true,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.34),
                      offset: const Offset(-5, -5),
                      blurRadius: 12,
                      spreadRadius: -4,
                      inset: true,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.75),
                      offset: const Offset(-8, -9),
                      blurRadius: 18,
                      spreadRadius: -8,
                    ),
                    BoxShadow(
                      color: Drop4UpTokens.deepBlueShadow.withOpacity(0.36),
                      offset: const Offset(10, 14),
                      blurRadius: 24,
                      spreadRadius: -8,
                    ),
                  ],
          ),
          child: Icon(
            widget.icon,
            color: Colors.white.withOpacity(0.94),
            size: widget.size * 0.44,
          ),
        ),
      ),
    );
  }
}
