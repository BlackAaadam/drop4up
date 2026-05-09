import 'package:flutter/material.dart';

import '../state/reflection_entries_scope.dart';
import '../ui/drop4up_tactile_surface.dart';
import '../ui/drop4up_tokens.dart';
import '../ui/reflection_taxonomy.dart';
import '../ui/soft_icon_button.dart';
import '../ui/soft_surface.dart';

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

class _DropEntryCard extends StatefulWidget {
  const _DropEntryCard();

  @override
  State<_DropEntryCard> createState() => _DropEntryCardState();
}

class _DropEntryCardState extends State<_DropEntryCard> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  int _selectedSourceIndex = 0;
  final Set<int> _selectedTagIndices = {};
  final List<String> _manualTags = List.of(reflectionSuggestedTags);
  String? _statusText;

  @override
  void dispose() {
    _textController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _saveDrop() async {
    final text = _textController.text;
    if (text.isEmpty) {
      setState(() => _statusText = '先寫下一句。');
      return;
    }

    final selectedTags = [
      for (final index in _selectedTagIndices) _manualTags[index],
    ];

    await ReflectionEntriesScope.read(context).addEntry(
      text: text,
      source: reflectionSourceOptions[_selectedSourceIndex].label,
      tags: selectedTags,
    );

    if (!mounted) {
      return;
    }
    _textController.clear();
    setState(() {
      _selectedTagIndices.clear();
      _statusText = '已儲存在本機。';
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final entriesController = ReflectionEntriesScope.of(context);

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
                onTap: () {
                  _textController.clear();
                  setState(() => _statusText = null);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DropEditorSurface(controller: _textController),
          const SizedBox(height: 12),
          _HorizontalChipRow(
            height: 42,
            spacing: 8,
            endPadding: 34,
            children: [
              for (
                var index = 0;
                index < reflectionSourceOptions.length;
                index++
              )
                _SourceChip(
                  source: reflectionSourceOptions[index],
                  selected: index == _selectedSourceIndex,
                  onTap: () => setState(() => _selectedSourceIndex = index),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _HorizontalChipRow(
            height: 34,
            spacing: 7,
            endPadding: 22,
            children: [
              for (var index = 0; index < _manualTags.length; index++)
                _ManualTagChip(
                  label: '#${_manualTags[index]}',
                  selected: _selectedTagIndices.contains(index),
                  onTap: () {
                    setState(() {
                      if (_selectedTagIndices.contains(index)) {
                        _selectedTagIndices.remove(index);
                      } else {
                        _selectedTagIndices.add(index);
                      }
                    });
                  },
                ),
              _AddTagChip(
                key: const Key('drop_add_tag_button'),
                onTap: _showAddTagDialog,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              SoftIconButton(
                icon: Icons.mic_none_rounded,
                label: '語音',
                size: 44,
                iconSize: 21,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              SoftIconButton(
                icon: Icons.photo_camera_outlined,
                label: '相機',
                size: 44,
                iconSize: 21,
                onTap: () {},
              ),
              const Spacer(),
              GestureDetector(
                key: const Key('save_drop_button'),
                behavior: HitTestBehavior.opaque,
                onTap: entriesController.isSaving ? null : _saveDrop,
                child: Drop4UpTactileSurface(
                  variant: Drop4UpTactileSurfaceVariant.primaryRaised,
                  width: 174,
                  height: 60,
                  radius: 24,
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
                        Flexible(
                          child: Text(
                            entriesController.isSaving ? '儲存中...' : 'Save Drop',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: Drop4UpTokens.softWhite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_statusText != null) ...[
            const SizedBox(height: 10),
            Text(
              _statusText!,
              key: const Key('drop_save_status'),
              style: textTheme.labelMedium?.copyWith(
                color: Drop4UpTokens.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showAddTagDialog() async {
    _tagController.clear();
    final tag = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final textTheme = Theme.of(dialogContext).textTheme;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: SoftSurface(
            variant: SoftSurfaceVariant.prominent,
            radius: 28,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('新增標籤', style: textTheme.titleMedium),
                const SizedBox(height: 12),
                Drop4UpTactileSurface(
                  variant: Drop4UpTactileSurfaceVariant.inset,
                  height: 46,
                  radius: 23,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  color: Drop4UpTokens.cardSurface,
                  child: TextField(
                    key: const Key('drop_add_tag_input'),
                    controller: _tagController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      isCollapsed: true,
                      hintText: '#標籤',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: Drop4UpTokens.textSecondary,
                      ),
                    ),
                    style: textTheme.bodyMedium,
                    cursorColor: Drop4UpTokens.primaryBlue,
                    onSubmitted: (value) {
                      Navigator.of(dialogContext).pop(_normalizeTag(value));
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _DropDialogAction(
                        label: '取消',
                        icon: Icons.close_rounded,
                        muted: true,
                        onTap: () => Navigator.of(dialogContext).pop(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DropDialogAction(
                        key: const Key('drop_add_tag_confirm_button'),
                        label: '加入',
                        icon: Icons.add_rounded,
                        onTap: () => Navigator.of(
                          dialogContext,
                        ).pop(_normalizeTag(_tagController.text)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || tag == null || tag.isEmpty) {
      return;
    }

    setState(() {
      var index = _manualTags.indexOf(tag);
      if (index == -1) {
        _manualTags.add(tag);
        index = _manualTags.length - 1;
      }
      _selectedTagIndices.add(index);
    });
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

class _DropEditorSurface extends StatelessWidget {
  const _DropEditorSurface({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drop4UpTactileSurface(
      variant: Drop4UpTactileSurfaceVariant.pressed,
      radius: 27,
      height: 122,
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 15),
      color: Color.alphaBlend(
        Drop4UpTokens.lightBlue.withValues(alpha: 0.028),
        Drop4UpTokens.cardSurface,
      ),
      child: TextField(
        key: const Key('drop_text_input'),
        controller: controller,
        maxLines: null,
        minLines: null,
        expands: true,
        maxLength: 300,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
          isCollapsed: true,
          hintText: 'Drop something here...',
          hintStyle: textTheme.bodyLarge?.copyWith(
            fontSize: 15.5,
            height: 1.42,
            color: Drop4UpTokens.textSecondary.withValues(alpha: 0.74),
          ),
        ),
        style: textTheme.bodyLarge?.copyWith(
          fontSize: 15.5,
          height: 1.42,
          color: Drop4UpTokens.textPrimary,
        ),
        cursorColor: Drop4UpTokens.primaryBlue,
      ),
    );
  }
}

class _HorizontalChipRow extends StatelessWidget {
  const _HorizontalChipRow({
    required this.children,
    required this.spacing,
    required this.height,
    this.endPadding = 0,
  });

  final List<Widget> children;
  final double spacing;
  final double height;
  final double endPadding;

  @override
  Widget build(BuildContext context) {
    final scrollRow = ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.hardEdge,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < children.length; index++) ...[
                if (index > 0) SizedBox(width: spacing),
                children[index],
              ],
              if (endPadding > 0) SizedBox(width: endPadding),
            ],
          ),
        ),
      ),
    );

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ClipRect(
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) {
            return const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black, Colors.black, Colors.transparent],
              stops: [0, 0.88, 1],
            ).createShader(bounds);
          },
          child: scrollRow,
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.source,
    required this.selected,
    required this.onTap,
  });

  final ReflectionSourceOption source;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final horizontalPadding = selected ? 17.0 : 20.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Drop4UpTactileSurface(
        variant: selected
            ? Drop4UpTactileSurfaceVariant.inset
            : Drop4UpTactileSurfaceVariant.raised,
        color: selected
            ? Drop4UpTokens.lightBlue.withValues(alpha: 0.36)
            : Drop4UpTokens.cardSurface,
        radius: Drop4UpTokens.pillRadius,
        height: 39,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(source.icon, size: 17, color: Drop4UpTokens.primaryBlue),
              const SizedBox(width: 7),
            ],
            Text(
              source.label,
              style: textTheme.labelMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: selected
                    ? Drop4UpTokens.textPrimary
                    : Drop4UpTokens.textPrimary.withValues(alpha: 0.86),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualTagChip extends StatelessWidget {
  const _ManualTagChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Drop4UpTactileSurface(
        variant: selected
            ? Drop4UpTactileSurfaceVariant.inset
            : Drop4UpTactileSurfaceVariant.raised,
        color: selected
            ? Drop4UpTokens.lightBlue.withValues(alpha: 0.24)
            : Drop4UpTokens.cardSurface.withValues(alpha: 0.94),
        radius: Drop4UpTokens.pillRadius,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            fontSize: 12,
            color: selected
                ? Drop4UpTokens.primaryBlue
                : Drop4UpTokens.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _AddTagChip extends StatelessWidget {
  const _AddTagChip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Drop4UpTactileSurface(
        variant: Drop4UpTactileSurfaceVariant.raised,
        color: Drop4UpTokens.cardSurface.withValues(alpha: 0.92),
        radius: Drop4UpTokens.pillRadius,
        width: 32,
        height: 30,
        child: const Icon(
          Icons.add_rounded,
          size: 18,
          color: Drop4UpTokens.textSecondary,
        ),
      ),
    );
  }
}

class _DropDialogAction extends StatelessWidget {
  const _DropDialogAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.muted = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = muted
        ? Drop4UpTokens.textSecondary
        : Drop4UpTokens.primaryBlue;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Drop4UpTactileSurface(
        variant: muted
            ? Drop4UpTactileSurfaceVariant.raised
            : Drop4UpTactileSurfaceVariant.inset,
        radius: 20,
        height: 44,
        color: muted
            ? Drop4UpTokens.cardSurface
            : Drop4UpTokens.lightBlue.withValues(alpha: 0.34),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 7),
            Text(label, style: textTheme.labelLarge?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

String _normalizeTag(String value) {
  final trimmed = value.trim();
  return trimmed.startsWith('#') ? trimmed.substring(1).trim() : trimmed;
}
