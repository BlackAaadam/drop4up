import 'package:flutter/material.dart';

import '../ui/drop4up_tag_chip.dart';
import '../ui/drop4up_tokens.dart';
import '../ui/soft_icon_button.dart';
import '../ui/soft_surface.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _tags = [
    _HomeTag('恩典', 24, true),
    _HomeTag('禱告', 18, false),
    _HomeTag('平安', 16, false),
    _HomeTag('信心', 14, false),
    _HomeTag('盼望', 12, false),
    _HomeTag('愛', 10, false),
    _HomeTag('信靠', 9, false),
    _HomeTag('智慧', 7, false),
  ];

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
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 26),
        Text(
          '安靜下來，\n記得祂的同在。',
          style: textTheme.headlineLarge?.copyWith(height: 1.18),
        ),
        const SizedBox(height: 12),
        Text(
          '用一點時間回望今天心裡被觸動的地方。',
          style: textTheme.bodyLarge?.copyWith(
            color: Drop4UpTokens.textPrimary.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 24),
        const _ReflectionCard(),
        const SizedBox(height: 24),
        Row(
          children: [
            Text('Explore Tags', style: textTheme.titleMedium),
            const Spacer(),
            Text(
              '查看全部',
              style: textTheme.labelLarge?.copyWith(
                color: Drop4UpTokens.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: [
            for (final tag in _tags)
              Drop4UpTagChip(
                label: tag.label,
                count: tag.count,
                selected: tag.selected,
                onTap: () {},
              ),
          ],
        ),
        const SizedBox(height: 24),
        const _CalmReturnCard(),
      ],
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  const _ReflectionCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SoftSurface(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('今日回望', style: textTheme.titleMedium),
              const Spacer(),
              Icon(
                Icons.shuffle_rounded,
                size: 24,
                color: Drop4UpTokens.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _SoftReflectionCanvas(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PageDot(active: true),
              const SizedBox(width: 8),
              _PageDot(active: false),
              const SizedBox(width: 8),
              _PageDot(active: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalmReturnCard extends StatelessWidget {
  const _CalmReturnCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SoftSurface(
      height: 88,
      radius: 30,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            height: 56,
            child: CustomPaint(painter: _QuietDropPainter()),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('慢慢呼吸', style: textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  '回到真正重要的事。',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Drop4UpTokens.textPrimary.withValues(alpha: 0.64),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 30,
            color: Drop4UpTokens.primaryBlue,
          ),
        ],
      ),
    );
  }
}

class _SoftReflectionCanvas extends StatelessWidget {
  const _SoftReflectionCanvas();

  static const _radius = 26.0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: SizedBox(
        height: 160,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 0.34, 0.72, 1],
                  colors: [
                    Color(0xFFFBFCFB),
                    Color(0xFFF2F6F7),
                    Color(0xFFE9F0F3),
                    Color(0xFFD6E4EE),
                  ],
                ),
              ),
            ),
            CustomPaint(painter: _ReflectionLandscapePainter()),
            const _CanvasEdgeTreatment(),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '祂的平安保守我的心。',
                    style: textTheme.titleLarge?.copyWith(
                      color: Drop4UpTokens.textPrimary,
                      height: 1.26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '2025.04.18  ·  平安',
                    style: textTheme.labelMedium?.copyWith(
                      color: Drop4UpTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CanvasEdgeTreatment extends StatelessWidget {
  const _CanvasEdgeTreatment();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.center,
              colors: [Color(0xAAFFFFFF), Color(0x00FFFFFF)],
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: 30,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Drop4UpTokens.softWhite.withValues(alpha: 0.55),
                  Drop4UpTokens.softWhite.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 28,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Drop4UpTokens.softWhite.withValues(alpha: 0.28),
                  Drop4UpTokens.softWhite.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 34,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Drop4UpTokens.accentBlue.withValues(alpha: 0),
                  Drop4UpTokens.accentBlue.withValues(alpha: 0.12),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          width: 30,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Drop4UpTokens.primaryBlue.withValues(alpha: 0),
                  Drop4UpTokens.primaryBlue.withValues(alpha: 0.08),
                ],
              ),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_SoftReflectionCanvas._radius),
            border: Border.all(
              color: Drop4UpTokens.softWhite.withValues(alpha: 0.46),
              width: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReflectionLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawMist(canvas, size);
    _drawMountains(canvas, size);
    _drawWater(canvas, size);
    _drawBoat(canvas, size);
    _drawDrop(canvas, size);
  }

  void _drawMist(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Drop4UpTokens.softWhite.withValues(alpha: 0.32)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    canvas
      ..drawOval(
        Rect.fromCenter(
          center: Offset(size.width * 0.68, size.height * 0.44),
          width: size.width * 0.62,
          height: 58,
        ),
        paint,
      )
      ..drawOval(
        Rect.fromCenter(
          center: Offset(size.width * 0.34, size.height * 0.62),
          width: size.width * 0.58,
          height: 44,
        ),
        paint,
      );
  }

  void _drawMountains(Canvas canvas, Size size) {
    final far = Paint()
      ..color = Drop4UpTokens.accentBlue.withValues(alpha: 0.11)
      ..style = PaintingStyle.fill;
    final near = Paint()
      ..color = Drop4UpTokens.primaryBlue.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;

    final farPath = Path()
      ..moveTo(0, size.height * 0.78)
      ..lineTo(size.width * 0.22, size.height * 0.57)
      ..lineTo(size.width * 0.40, size.height * 0.70)
      ..lineTo(size.width * 0.58, size.height * 0.49)
      ..lineTo(size.width * 0.80, size.height * 0.70)
      ..lineTo(size.width, size.height * 0.58)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final nearPath = Path()
      ..moveTo(0, size.height * 0.84)
      ..lineTo(size.width * 0.30, size.height * 0.73)
      ..lineTo(size.width * 0.50, size.height * 0.84)
      ..lineTo(size.width * 0.72, size.height * 0.66)
      ..lineTo(size.width, size.height * 0.78)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas
      ..drawPath(farPath, far)
      ..drawPath(nearPath, near);
  }

  void _drawWater(Canvas canvas, Size size) {
    final water = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Drop4UpTokens.lightBlue.withValues(alpha: 0.05),
              Drop4UpTokens.primaryBlue.withValues(alpha: 0.12),
            ],
          ).createShader(
            Rect.fromLTWH(0, size.height * 0.70, size.width, size.height),
          );

    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.70, size.width, size.height * 0.30),
      water,
    );

    final ripple = Paint()
      ..color = Drop4UpTokens.softWhite.withValues(alpha: 0.46)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 4; i++) {
      final y = size.height * (0.76 + i * 0.047);
      canvas.drawLine(
        Offset(size.width * 0.14, y),
        Offset(size.width * (0.78 + i * 0.03), y + 1.4),
        ripple,
      );
    }

    final arcPaint = Paint()
      ..color = Drop4UpTokens.primaryBlue.withValues(alpha: 0.18)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.52, size.height * 0.79),
        width: 56,
        height: 22,
      ),
      0.16,
      2.66,
      false,
      arcPaint,
    );
  }

  void _drawBoat(Canvas canvas, Size size) {
    final boatPaint = Paint()
      ..color = Drop4UpTokens.primaryBlue.withValues(alpha: 0.36)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final base = Offset(size.width * 0.52, size.height * 0.80);
    final boat = Path()
      ..moveTo(base.dx - 24, base.dy)
      ..quadraticBezierTo(base.dx, base.dy + 16, base.dx + 28, base.dy)
      ..moveTo(base.dx - 10, base.dy - 2)
      ..lineTo(base.dx - 3, base.dy - 16);

    canvas.drawPath(boat, boatPaint);
  }

  void _drawDrop(Canvas canvas, Size size) {
    final dropPaint = Paint()
      ..color = Drop4UpTokens.primaryBlue.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final centerX = size.width * 0.88;
    final topY = size.height * 0.64;
    final drop = Path()
      ..moveTo(centerX, topY)
      ..cubicTo(
        centerX - 18,
        topY + 24,
        centerX - 12,
        topY + 42,
        centerX,
        topY + 42,
      )
      ..cubicTo(centerX + 12, topY + 42, centerX + 18, topY + 24, centerX, topY)
      ..close();

    canvas.drawPath(drop, dropPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QuietDropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.44, size.height * 0.78);
    final ripplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Drop4UpTokens.primaryBlue.withValues(alpha: 0.18);

    canvas
      ..drawOval(
        Rect.fromCenter(center: center, width: size.width * 0.88, height: 20),
        ripplePaint,
      )
      ..drawOval(
        Rect.fromCenter(center: center, width: size.width * 0.52, height: 11),
        ripplePaint,
      );

    final drop = Path()
      ..moveTo(size.width * 0.44, 5)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.38,
        size.width * 0.22,
        size.height * 0.62,
        size.width * 0.44,
        size.height * 0.64,
      )
      ..cubicTo(
        size.width * 0.66,
        size.height * 0.62,
        size.width * 0.70,
        size.height * 0.38,
        size.width * 0.44,
        5,
      )
      ..close();

    final dropPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Drop4UpTokens.softWhite.withValues(alpha: 0.92),
          Drop4UpTokens.lightBlue.withValues(alpha: 0.72),
          Drop4UpTokens.primaryBlue.withValues(alpha: 0.44),
        ],
      ).createShader(drop.getBounds());

    canvas.drawPath(drop, dropPaint);

    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Drop4UpTokens.primaryBlue.withValues(alpha: 0.34);
    canvas.drawPath(drop, edgePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 8,
      height: 8,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: active
              ? Drop4UpTokens.primaryBlue
              : Drop4UpTokens.textSecondary.withValues(alpha: 0.36),
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}

class _HomeTag {
  const _HomeTag(this.label, this.count, this.selected);

  final String label;
  final int count;
  final bool selected;
}
