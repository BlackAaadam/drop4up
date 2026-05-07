import 'package:flutter/material.dart';

import '../ui/drop4up_tactile_surface.dart';
import '../ui/drop4up_tokens.dart';
import '../ui/soft_icon_button.dart';
import '../ui/soft_surface.dart';

const _sourceChips = [
  _DropSource('講道', Icons.menu_book_outlined, true),
  _DropSource('禱告', Icons.self_improvement_rounded, false),
  _DropSource('靈修', Icons.wb_twilight_outlined, false),
  _DropSource('其他', Icons.more_horiz_rounded, false),
];

class DropScreen extends StatelessWidget {
  const DropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            Text(
              'Drop4Up',
              style: textTheme.titleLarge?.copyWith(
                color: Drop4UpTokens.primaryBlue,
              ),
            ),
            const Spacer(),
            SoftIconButton(
              icon: Icons.person_outline_rounded,
              label: '個人設定',
              size: 44,
              iconSize: 20,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 118,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '記下一滴\n心裡的回響。',
                      style: textTheme.headlineLarge?.copyWith(
                        fontSize: 30,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '一句話就夠了。',
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 15,
                        color: Drop4UpTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: SizedBox(
                  width: 108,
                  height: 112,
                  child: CustomPaint(painter: _QuietLeafPainter()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _DropEntryCard(),
      ],
    );
  }
}

class _DropEntryCard extends StatelessWidget {
  const _DropEntryCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SoftSurface(
      variant: SoftSurfaceVariant.prominent,
      radius: 30,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '心裡想記下什麼？',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 12),
              SoftIconButton(
                icon: Icons.close_rounded,
                label: '清除',
                size: 40,
                iconSize: 20,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          Drop4UpTactileSurface(
            variant: Drop4UpTactileSurfaceVariant.inset,
            radius: 22,
            height: 92,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            color: Drop4UpTokens.cardSurface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '寫下一句...',
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    color: Drop4UpTokens.textSecondary,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '0/300',
                    style: textTheme.labelMedium?.copyWith(
                      color: Drop4UpTokens.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '來源',
            style: textTheme.bodyMedium?.copyWith(
              color: Drop4UpTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final source in _sourceChips) _SourceChip(source: source),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  '可選附件',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Drop4UpTokens.textSecondary,
                  ),
                ),
              ),
              SoftIconButton(
                icon: Icons.mic_none_rounded,
                label: '語音',
                size: 42,
                iconSize: 21,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              SoftIconButton(
                icon: Icons.photo_camera_outlined,
                label: '相機',
                size: 42,
                iconSize: 21,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 14),
          Drop4UpTactileSurface(
            variant: Drop4UpTactileSurfaceVariant.primaryRaised,
            height: 54,
            radius: 22,
            color: Drop4UpTokens.primaryBlue,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.water_drop_outlined,
                    size: 21,
                    color: Drop4UpTokens.softWhite,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'Save Drop',
                    style: textTheme.titleMedium?.copyWith(
                      color: Drop4UpTokens.softWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuietLeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stem = Paint()
      ..color = Drop4UpTokens.primaryBlue.withValues(alpha: 0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.42, size.height * 0.98)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.70,
        size.width * 0.58,
        size.height * 0.48,
        size.width * 0.40,
        size.height * 0.10,
      );

    canvas.drawPath(path, stem);

    _drawLeaf(
      canvas,
      size,
      Offset(size.width * 0.36, size.height * 0.30),
      -0.8,
    );
    _drawLeaf(canvas, size, Offset(size.width * 0.55, size.height * 0.48), 0.7);
    _drawLeaf(
      canvas,
      size,
      Offset(size.width * 0.34, size.height * 0.62),
      -1.0,
    );

    final drop = Paint()
      ..color = Drop4UpTokens.primaryBlue.withValues(alpha: 0.36)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final dropPath = Path()
      ..moveTo(size.width * 0.78, size.height * 0.64)
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.78,
        size.width * 0.70,
        size.height * 0.88,
        size.width * 0.78,
        size.height * 0.88,
      )
      ..cubicTo(
        size.width * 0.86,
        size.height * 0.88,
        size.width * 0.88,
        size.height * 0.78,
        size.width * 0.78,
        size.height * 0.64,
      );

    canvas.drawPath(dropPath, drop);
  }

  void _drawLeaf(Canvas canvas, Size size, Offset center, double angle) {
    final canvasState = canvas.getSaveCount();
    canvas
      ..save()
      ..translate(center.dx, center.dy)
      ..rotate(angle);

    final leafPaint = Paint()
      ..color = Drop4UpTokens.lightBlue.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    final edgePaint = Paint()
      ..color = Drop4UpTokens.primaryBlue.withValues(alpha: 0.26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final leaf = Path()
      ..moveTo(0, -34)
      ..cubicTo(-24, -18, -22, 20, 0, 34)
      ..cubicTo(22, 20, 24, -18, 0, -34)
      ..close();

    canvas
      ..drawPath(leaf, leafPaint)
      ..drawPath(leaf, edgePaint)
      ..drawLine(const Offset(0, -26), const Offset(0, 24), edgePaint);

    for (final side in [-1, 1]) {
      for (var i = 0; i < 3; i++) {
        final y = -12.0 + i * 11.0;
        canvas.drawLine(
          Offset(0, y),
          Offset(side * (8 + i * 2), y + 8),
          edgePaint,
        );
      }
    }

    canvas.restoreToCount(canvasState);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.source});

  final _DropSource source;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drop4UpTactileSurface(
      variant: source.selected
          ? Drop4UpTactileSurfaceVariant.inset
          : Drop4UpTactileSurfaceVariant.raised,
      color: source.selected
          ? Drop4UpTokens.lightBlue.withValues(alpha: 0.36)
          : Drop4UpTokens.cardSurface,
      radius: Drop4UpTokens.pillRadius,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            source.icon,
            size: 18,
            color: source.selected
                ? Drop4UpTokens.primaryBlue
                : Drop4UpTokens.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            source.label,
            style: textTheme.labelMedium?.copyWith(
              fontSize: 14,
              color: source.selected
                  ? Drop4UpTokens.textPrimary
                  : Drop4UpTokens.textPrimary.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropSource {
  const _DropSource(this.label, this.icon, this.selected);

  final String label;
  final IconData icon;
  final bool selected;
}
