import 'package:flutter/material.dart';

import '../data/reflection_entry.dart';
import '../state/reflection_entries_scope.dart';
import '../ui/drop4up_tactile_surface.dart';
import '../ui/drop4up_tokens.dart';
import '../ui/reflection_taxonomy.dart';
import '../ui/soft_icon_button.dart';
import '../ui/soft_surface.dart';

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
        : allEntries
              .where((entry) => _matchesJournalQuery(entry, _query))
              .toList();

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
            if (entry.source.isNotEmpty || entry.tags.isNotEmpty) ...[
              const SizedBox(height: 7),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  if (entry.source.isNotEmpty)
                    _MiniTag(label: '#${entry.source}'),
                  for (final tag in entry.tags) _MiniTag(label: '#$tag'),
                ],
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
  final tagController = TextEditingController();
  var selectedSource =
      reflectionSourceOptions.any((source) => source.label == entry.source)
      ? entry.source
      : reflectionSourceOptions.first.label;
  final editableTags = List<String>.of(entry.tags);
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final textTheme = Theme.of(dialogContext).textTheme;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return SoftSurface(
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
                    height: 150,
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
                  const SizedBox(height: 12),
                  _JournalSourceEditor(
                    selectedSource: selectedSource,
                    onChanged: (source) {
                      setDialogState(() => selectedSource = source);
                    },
                  ),
                  const SizedBox(height: 10),
                  _JournalTagEditor(
                    tags: editableTags,
                    tagController: tagController,
                    onChanged: () => setDialogState(() {}),
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
                            await controller.updateEntry(
                              id: entry.id,
                              text: textController.text,
                              source: selectedSource,
                              tags: editableTags,
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
            );
          },
        ),
      );
    },
  );
  tagController.dispose();
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

bool _matchesJournalQuery(ReflectionEntry entry, String query) {
  final normalizedQuery = query.trim();
  if (normalizedQuery.isEmpty) {
    return true;
  }

  if (normalizedQuery.startsWith('#')) {
    final tagQuery = _normalizeTag(normalizedQuery);
    if (tagQuery.isEmpty) {
      return true;
    }
    return entry.source == tagQuery || entry.tags.contains(tagQuery);
  }

  return entry.text.contains(normalizedQuery) ||
      entry.source.contains(normalizedQuery) ||
      entry.tags.any((tag) => tag.contains(normalizedQuery));
}

String _normalizeTag(String value) {
  final trimmed = value.trim();
  return trimmed.startsWith('#') ? trimmed.substring(1).trim() : trimmed;
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

class _JournalSourceEditor extends StatelessWidget {
  const _JournalSourceEditor({
    required this.selectedSource,
    required this.onChanged,
  });

  final String selectedSource;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: reflectionSourceOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final source = reflectionSourceOptions[index];
          return _JournalChoiceChip(
            key: ValueKey('entry_source_${source.label}'),
            label: source.label,
            icon: source.icon,
            selected: selectedSource == source.label,
            onTap: () => onChanged(source.label),
          );
        },
      ),
    );
  }
}

class _JournalTagEditor extends StatelessWidget {
  const _JournalTagEditor({
    required this.tags,
    required this.tagController,
    required this.onChanged,
  });

  final List<String> tags;
  final TextEditingController tagController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        for (final tag in tags)
          _EditableTagChip(
            key: ValueKey('entry_tag_$tag'),
            label: '#$tag',
            onTap: () {
              tags.remove(tag);
              onChanged();
            },
          ),
        _AddEntryTagChip(
          key: const Key('entry_add_tag_button'),
          onTap: () async {
            tagController.clear();
            final tag = await _showTagInputDialog(context, tagController);
            if (tag == null || tag.isEmpty || tags.contains(tag)) {
              return;
            }
            tags.add(tag);
            onChanged();
          },
        ),
      ],
    );
  }
}

class _JournalChoiceChip extends StatelessWidget {
  const _JournalChoiceChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
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
        radius: Drop4UpTokens.pillRadius,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: selected
            ? Drop4UpTokens.lightBlue.withValues(alpha: 0.22)
            : Drop4UpTokens.cardSurface.withValues(alpha: 0.94),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(icon, size: 16, color: Drop4UpTokens.primaryBlue),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                fontSize: 14,
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

class _EditableTagChip extends StatelessWidget {
  const _EditableTagChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Drop4UpTactileSurface(
        radius: Drop4UpTokens.pillRadius,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        color: Drop4UpTokens.cardSurface.withValues(alpha: 0.94),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                fontSize: 12,
                color: Drop4UpTokens.textSecondary,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.close_rounded,
              size: 13,
              color: Drop4UpTokens.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddEntryTagChip extends StatelessWidget {
  const _AddEntryTagChip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Drop4UpTactileSurface(
        radius: Drop4UpTokens.pillRadius,
        width: 30,
        height: 28,
        color: Drop4UpTokens.cardSurface.withValues(alpha: 0.92),
        child: const Icon(
          Icons.add_rounded,
          size: 17,
          color: Drop4UpTokens.textSecondary,
        ),
      ),
    );
  }
}

Future<String?> _showTagInputDialog(
  BuildContext context,
  TextEditingController tagController,
) {
  return showDialog<String>(
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
                  key: const Key('entry_add_tag_input'),
                  controller: tagController,
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
                    child: _DialogAction(
                      label: '取消',
                      icon: Icons.close_rounded,
                      muted: true,
                      onTap: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DialogAction(
                      key: const Key('entry_add_tag_confirm_button'),
                      label: '加入',
                      icon: Icons.add_rounded,
                      onTap: () => Navigator.of(
                        dialogContext,
                      ).pop(_normalizeTag(tagController.text)),
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
      variant: Drop4UpTactileSurfaceVariant.raised,
      radius: Drop4UpTokens.pillRadius,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: Drop4UpTokens.cardSurface.withValues(alpha: 0.94),
      child: Text(
        label,
        style: textTheme.labelMedium?.copyWith(
          fontSize: 12,
          color: Drop4UpTokens.textSecondary,
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
