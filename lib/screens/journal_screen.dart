import 'package:flutter/material.dart';

import '../data/reflection_entry.dart';
import '../state/reflection_entries_scope.dart';
import '../ui/drop4up_tactile_surface.dart';
import '../ui/drop4up_tag_chip.dart';
import '../ui/drop4up_tokens.dart';
import '../ui/soft_icon_button.dart';
import '../ui/soft_surface.dart';

const _journalTags = [
  _JournalTag('全部', true),
  _JournalTag('禱告', false),
  _JournalTag('平安', false),
  _JournalTag('講道', false),
];

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final entriesController = ReflectionEntriesScope.of(context);
    final allEntries = entriesController.entries;
    final visibleEntries = _query.isEmpty
        ? allEntries
        : allEntries.where((entry) => entry.text.contains(_query)).toList();

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
              icon: Icons.tune_rounded,
              label: '篩選',
              size: 44,
              iconSize: 20,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Journal',
          style: textTheme.headlineLarge?.copyWith(fontSize: 32, height: 1.08),
        ),
        const SizedBox(height: 6),
        Text(
          '搜尋、整理，安靜回看每一滴。',
          style: textTheme.bodyLarge?.copyWith(
            fontSize: 15,
            color: Drop4UpTokens.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        _SearchRow(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in _journalTags)
              Drop4UpTagChip(
                label: tag.label,
                selected: tag.selected,
                onTap: () {},
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text('Recent Drops', style: textTheme.titleMedium),
            const Spacer(),
            Text(
              '查看全部',
              style: textTheme.labelLarge?.copyWith(
                color: Drop4UpTokens.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        if (!entriesController.isLoaded)
          const _JournalStateCard(message: '正在載入 drops...')
        else if (allEntries.isEmpty)
          const _JournalStateCard(message: '還沒有儲存的 drops。')
        else if (visibleEntries.isEmpty)
          const _JournalStateCard(message: '找不到符合的 drops。')
        else
          for (final entry in visibleEntries) ...[
            _JournalEntryCard(entry: entry),
            if (entry != visibleEntries.last) const SizedBox(height: 9),
          ],
        const SizedBox(height: 11),
        const _CreateVisualCardButton(),
      ],
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Drop4UpTactileSurface(
            variant: Drop4UpTactileSurfaceVariant.inset,
            height: 44,
            radius: 23,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 21,
                  color: Drop4UpTokens.textSecondary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: TextField(
                    key: const Key('journal_search_input'),
                    controller: controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      isCollapsed: true,
                      hintText: '搜尋 drops',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: Drop4UpTokens.textSecondary,
                      ),
                    ),
                    style: textTheme.bodyMedium,
                    cursorColor: Drop4UpTokens.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        SoftIconButton(
          icon: Icons.filter_list_rounded,
          label: '篩選',
          size: 44,
          iconSize: 21,
          onTap: () {},
        ),
      ],
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  const _JournalEntryCard({required this.entry});

  final ReflectionEntry entry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      key: ValueKey('journal_entry_${entry.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: () => _showEntryDetail(context, entry),
      child: SoftSurface(
        variant: SoftSurfaceVariant.prominent,
        radius: 26,
        padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _formatEntryDate(entry.createdAt),
                  style: textTheme.labelMedium?.copyWith(
                    color: Drop4UpTokens.textSecondary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  key: ValueKey('favorite_${entry.id}'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => ReflectionEntriesScope.read(
                    context,
                  ).toggleFavorite(entry.id),
                  child: Icon(
                    entry.isFavorite
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 20,
                    color: entry.isFavorite
                        ? Drop4UpTokens.primaryBlue
                        : Drop4UpTokens.textSecondary,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.edit_outlined,
                  size: 19,
                  color: Drop4UpTokens.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              entry.text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(height: 1.32),
            ),
            if (entry.tags.isNotEmpty) ...[
              const SizedBox(height: 7),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [for (final tag in entry.tags) _MiniTag(label: tag)],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> _showEntryDetail(
  BuildContext context,
  ReflectionEntry entry,
) async {
  final controller = ReflectionEntriesScope.read(context);
  final textController = TextEditingController(text: entry.text);
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final textTheme = Theme.of(dialogContext).textTheme;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: SoftSurface(
          variant: SoftSurfaceVariant.prominent,
          radius: 30,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('編輯 Drop', style: textTheme.titleMedium),
                  ),
                  SoftIconButton(
                    icon: Icons.close_rounded,
                    label: '關閉',
                    size: 40,
                    iconSize: 20,
                    onTap: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Drop4UpTactileSurface(
                variant: Drop4UpTactileSurfaceVariant.inset,
                radius: 22,
                height: 160,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                color: Drop4UpTokens.cardSurface,
                child: TextField(
                  key: const Key('entry_detail_text_input'),
                  controller: textController,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    isCollapsed: true,
                  ),
                  style: textTheme.bodyLarge?.copyWith(fontSize: 15),
                  cursorColor: Drop4UpTokens.primaryBlue,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _DialogAction(
                      key: const Key('entry_delete_button'),
                      label: '刪除',
                      icon: Icons.delete_outline_rounded,
                      muted: true,
                      onTap: () async {
                        final shouldDelete = await _confirmDelete(
                          dialogContext,
                        );
                        if (shouldDelete != true) {
                          return;
                        }
                        await controller.deleteEntry(entry.id);
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DialogAction(
                      key: const Key('entry_save_button'),
                      label: '儲存',
                      icon: Icons.check_rounded,
                      onTap: () async {
                        await controller.updateEntryText(
                          id: entry.id,
                          text: textController.text,
                        );
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
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
}

Future<bool?> _confirmDelete(BuildContext context) {
  return showDialog<bool>(
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
              Text('刪除這一滴？', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                '刪除後會從本機紀錄移除。',
                style: textTheme.bodyMedium?.copyWith(
                  color: Drop4UpTokens.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DialogAction(
                      key: const Key('delete_cancel_button'),
                      label: '取消',
                      icon: Icons.close_rounded,
                      muted: true,
                      onTap: () => Navigator.of(dialogContext).pop(false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DialogAction(
                      key: const Key('delete_confirm_button'),
                      label: '刪除',
                      icon: Icons.delete_outline_rounded,
                      onTap: () => Navigator.of(dialogContext).pop(true),
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
}

class _DialogAction extends StatelessWidget {
  const _DialogAction({
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

String _formatEntryDate(DateTime date) {
  final local = date.toLocal();
  return '${local.year}.${_twoDigits(local.month)}.${_twoDigits(local.day)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

class _JournalStateCard extends StatelessWidget {
  const _JournalStateCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SoftSurface(
      variant: SoftSurfaceVariant.prominent,
      radius: 26,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Text(
        message,
        key: const Key('journal_empty_state'),
        style: textTheme.bodyMedium?.copyWith(
          color: Drop4UpTokens.textSecondary,
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drop4UpTactileSurface(
      radius: Drop4UpTokens.pillRadius,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      color: Drop4UpTokens.lightBlue.withValues(alpha: 0.18),
      child: Text(
        label,
        style: textTheme.labelMedium?.copyWith(
          fontSize: 12,
          color: Drop4UpTokens.primaryBlue,
        ),
      ),
    );
  }
}

class _CreateVisualCardButton extends StatelessWidget {
  const _CreateVisualCardButton();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drop4UpTactileSurface(
      variant: Drop4UpTactileSurfaceVariant.primaryRaised,
      height: 52,
      radius: 22,
      color: Drop4UpTokens.primaryBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_outlined,
            size: 20,
            color: Drop4UpTokens.softWhite,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Create Visual Card',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium?.copyWith(
                fontSize: 16,
                color: Drop4UpTokens.softWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalTag {
  const _JournalTag(this.label, this.selected);

  final String label;
  final bool selected;
}
