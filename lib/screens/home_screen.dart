import 'package:flutter/material.dart';

import '../data/reflection_entry.dart';
import '../state/reflection_entries_scope.dart';
import '../ui/drop4up_tag_chip.dart';
import '../ui/drop4up_tokens.dart';
import '../ui/soft_icon_button.dart';
import '../ui/soft_surface.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.onOpenJournalAll,
    this.onOpenJournalTag,
    this.onOpenProfile,
  });

  final VoidCallback? onOpenJournalAll;
  final ValueChanged<String>? onOpenJournalTag;
  final VoidCallback? onOpenProfile;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedTag;
  int _reflectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final entries = ReflectionEntriesScope.of(context).entries;
    final tags = _buildHomeTags(entries);

    if (_selectedTag != null && !tags.any((tag) => tag.label == _selectedTag)) {
      _selectedTag = null;
      _reflectionIndex = 0;
    }
    final reflectionEntries = _buildReflectionEntries(entries, _selectedTag);
    final reflectionPageCount = reflectionEntries.isEmpty
        ? 1
        : reflectionEntries.length > 3
        ? 3
        : reflectionEntries.length;
    if (_reflectionIndex >= reflectionPageCount) {
      _reflectionIndex = 0;
    }
    final selectedEntry = reflectionEntries.isEmpty
        ? null
        : reflectionEntries[_reflectionIndex];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            Text(
              'Drop4Up',
              style: textTheme.titleLarge?.copyWith(
                color: Drop4UpTokens.primaryBlue.withValues(alpha: 0.92),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SoftIconButton(
              icon: Icons.person_outline_rounded,
              label: '個人設定',
              size: 44,
              iconSize: 20,
              onTap: widget.onOpenProfile ?? () {},
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Be still and know\nHe is God',
          style: textTheme.headlineLarge?.copyWith(
            fontSize: 29,
            fontWeight: FontWeight.w400,
            height: 1.14,
            color: Drop4UpTokens.textPrimary.withValues(alpha: 0.92),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '用一點時間回望今天心裡被觸動的地方。',
          style: textTheme.bodyLarge?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Drop4UpTokens.textPrimary.withValues(alpha: 0.64),
          ),
        ),
        const SizedBox(height: 18),
        _ReflectionCard(
          entry: selectedEntry,
          selectedTag: _selectedTag,
          currentPage: _reflectionIndex,
          pageCount: reflectionPageCount,
          onNext: reflectionPageCount <= 1
              ? null
              : () => setState(() {
                  _reflectionIndex =
                      (_reflectionIndex + 1) % reflectionPageCount;
                }),
          onPageSelected: reflectionPageCount <= 1
              ? null
              : (page) => setState(() => _reflectionIndex = page),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Text(
              '探索標籤',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: Drop4UpTokens.textPrimary.withValues(alpha: 0.90),
              ),
            ),
            const Spacer(),
            GestureDetector(
              key: const Key('home_view_all_tags'),
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final selectedTag = _selectedTag;
                if (selectedTag == null) {
                  widget.onOpenJournalAll?.call();
                } else {
                  widget.onOpenJournalTag?.call(selectedTag);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '查看全部',
                  style: textTheme.labelLarge?.copyWith(
                    color: Drop4UpTokens.primaryBlue.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: [
            for (final tag in tags.take(6))
              Drop4UpTagChip(
                key: ValueKey('home_tag_${tag.label}'),
                label: tag.label,
                count: tag.count,
                selected: tag.label == _selectedTag,
                onTap: () {
                  setState(() {
                    _selectedTag = _selectedTag == tag.label ? null : tag.label;
                    _reflectionIndex = 0;
                  });
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  const _ReflectionCard({
    required this.entry,
    required this.selectedTag,
    required this.currentPage,
    required this.pageCount,
    required this.onNext,
    required this.onPageSelected,
  });

  final ReflectionEntry? entry;
  final String? selectedTag;
  final int currentPage;
  final int pageCount;
  final VoidCallback? onNext;
  final ValueChanged<int>? onPageSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SoftSurface(
      variant: SoftSurfaceVariant.prominent,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '今日回望',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Drop4UpTokens.textPrimary.withValues(alpha: 0.92),
                ),
              ),
              const Spacer(),
              GestureDetector(
                key: const Key('home_reflection_next_button'),
                behavior: HitTestBehavior.opaque,
                onTap: onNext,
                child: Icon(
                  Icons.shuffle_rounded,
                  size: 24,
                  color: onNext == null
                      ? Drop4UpTokens.textSecondary.withValues(alpha: 0.42)
                      : Drop4UpTokens.textSecondary.withValues(alpha: 0.82),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SoftReflectionCanvas(entry: entry, selectedTag: selectedTag),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var index = 0; index < pageCount; index++) ...[
                _PageDot(
                  key: ValueKey('home_reflection_dot_$index'),
                  active: index == currentPage,
                  onTap: onPageSelected == null
                      ? null
                      : () => onPageSelected!(index),
                ),
                if (index != pageCount - 1) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SoftReflectionCanvas extends StatelessWidget {
  const _SoftReflectionCanvas({required this.entry, required this.selectedTag});

  final ReflectionEntry? entry;
  final String? selectedTag;

  static const _radius = 26.0;
  static const _fallbackText = '還沒有儲存的紀錄。\n一句也可以，慢慢記下。';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final displayText = entry?.text ?? _fallbackText;
    final meta = entry == null
        ? '今天  ·  安靜'
        : '${_formatEntryDate(entry!.createdAt)}  ·  ${_entryMeta(entry!, selectedTag)}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: SizedBox(
        height: 172,
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
                    displayText,
                    key: const Key('home_reflection_text'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge?.copyWith(
                      color: Drop4UpTokens.textPrimary.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w400,
                      height: 1.26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    meta,
                    key: const Key('home_reflection_meta'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelMedium?.copyWith(
                      color: Drop4UpTokens.textSecondary.withValues(
                        alpha: 0.86,
                      ),
                      fontWeight: FontWeight.w400,
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

class _PageDot extends StatelessWidget {
  const _PageDot({super.key, required this.active, required this.onTap});

  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 18,
        height: 18,
        child: Center(
          child: AnimatedContainer(
            duration: Drop4UpTokens.quickDuration,
            curve: Drop4UpTokens.calmCurve,
            width: active ? 9 : 7,
            height: active ? 9 : 7,
            decoration: ShapeDecoration(
              color: active
                  ? Drop4UpTokens.primaryBlue
                  : Drop4UpTokens.textSecondary.withValues(alpha: 0.36),
              shape: const CircleBorder(),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeTagStat {
  const _HomeTagStat(this.label, this.count);

  final String label;
  final int? count;
}

const _suggestedHomeTags = [
  _HomeTagStat('恩典', null),
  _HomeTagStat('禱告', null),
  _HomeTagStat('平安', null),
  _HomeTagStat('信心', null),
  _HomeTagStat('盼望', null),
  _HomeTagStat('愛', null),
];

List<_HomeTagStat> _buildHomeTags(List<ReflectionEntry> entries) {
  if (entries.isEmpty) {
    return _suggestedHomeTags;
  }

  final counts = <String, int>{};
  for (final entry in entries) {
    if (entry.source.isNotEmpty) {
      counts.update(entry.source, (count) => count + 1, ifAbsent: () => 1);
    }
    for (final tag in entry.tags) {
      if (tag.isEmpty) {
        continue;
      }
      counts.update(tag, (count) => count + 1, ifAbsent: () => 1);
    }
  }

  final stats = [
    for (final MapEntry(:key, :value) in counts.entries)
      _HomeTagStat(key, value),
  ];
  stats.sort((a, b) {
    final countCompare = (b.count ?? 0).compareTo(a.count ?? 0);
    if (countCompare != 0) {
      return countCompare;
    }
    return a.label.compareTo(b.label);
  });
  return stats.take(6).toList();
}

List<ReflectionEntry> _buildReflectionEntries(
  List<ReflectionEntry> entries,
  String? selectedTag,
) {
  if (entries.isEmpty) {
    return const [];
  }

  final candidates = selectedTag == null
      ? entries
      : entries
            .where(
              (entry) =>
                  entry.source == selectedTag ||
                  entry.tags.contains(selectedTag),
            )
            .toList();
  final source = candidates.isEmpty ? entries : candidates;
  final sorted = List<ReflectionEntry>.of(source);
  sorted.sort((a, b) {
    if (a.isFavorite != b.isFavorite) {
      return a.isFavorite ? -1 : 1;
    }
    return b.createdAt.compareTo(a.createdAt);
  });
  return sorted.take(3).toList();
}

String _entryMeta(ReflectionEntry entry, String? selectedTag) {
  if (selectedTag != null &&
      (entry.source == selectedTag || entry.tags.contains(selectedTag))) {
    return selectedTag;
  }
  if (entry.tags.isNotEmpty) {
    return entry.tags.first;
  }
  if (entry.source.isNotEmpty) {
    return entry.source;
  }
  return '回望';
}

String _formatEntryDate(DateTime date) {
  final local = date.toLocal();
  return '${local.year}.${_twoDigits(local.month)}.${_twoDigits(local.day)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
