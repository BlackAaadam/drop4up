import 'package:flutter/material.dart';

import '../data/reflection_entry.dart';
import '../state/reflection_entries_scope.dart';
import '../ui/drop4up_tactile_surface.dart';
import '../ui/drop4up_tokens.dart';
import '../ui/reflection_taxonomy.dart';
import '../ui/soft_icon_button.dart';
import '../ui/soft_surface.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({
    super.key,
    this.initialTaxonomyFilter,
    this.onInitialFilterConsumed,
  });

  final String? initialTaxonomyFilter;
  final VoidCallback? onInitialFilterConsumed;

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  _JournalFilter _filter = const _JournalFilter.all();

  @override
  void initState() {
    super.initState();
    _applyInitialFilter();
  }

  @override
  void didUpdateWidget(covariant JournalScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTaxonomyFilter != widget.initialTaxonomyFilter) {
      _applyInitialFilter();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyInitialFilter() {
    final label = widget.initialTaxonomyFilter?.trim();
    if (label == null || label.isEmpty) {
      return;
    }
    _filter = _JournalFilter.taxonomy(label);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      widget.onInitialFilterConsumed?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final entriesController = ReflectionEntriesScope.of(context);
    final allEntries = entriesController.entries;
    final visibleEntries = allEntries
        .where(
          (entry) =>
              _matchesJournalQuery(entry, _query) &&
              _matchesJournalFilter(entry, _filter),
        )
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
              onTap: () => _openFilterSheet(context, allEntries),
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
          onFilterTap: () => _openFilterSheet(context, allEntries),
        ),
        if (!_filter.isAll) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: _ActiveJournalFilterChip(
              filter: _filter,
              onClear: () =>
                  setState(() => _filter = const _JournalFilter.all()),
            ),
          ),
        ],
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
          const _JournalStateCard(message: '正在載入紀錄...')
        else if (allEntries.isEmpty)
          const _JournalStateCard(message: '還沒有儲存的紀錄。')
        else if (visibleEntries.isEmpty)
          const _JournalStateCard(message: '找不到符合的紀錄。')
        else
          for (final entry in visibleEntries) ...[
            _JournalEntryCard(entry: entry),
            if (entry != visibleEntries.last) const SizedBox(height: 9),
          ],
        const SizedBox(height: 11),
        _CreateVisualCardButton(
          entry: visibleEntries.isEmpty ? null : visibleEntries.first,
        ),
      ],
    );
  }

  Future<void> _openFilterSheet(
    BuildContext context,
    List<ReflectionEntry> entries,
  ) async {
    final filter = await _showJournalFilterSheet(
      context,
      entries: entries,
      selectedFilter: _filter,
    );
    if (!mounted || filter == null) {
      return;
    }
    setState(() => _filter = filter);
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

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
                      hintText: '搜尋每一滴',
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
          key: const Key('journal_filter_button'),
          icon: Icons.filter_list_rounded,
          label: '篩選',
          size: 44,
          iconSize: 21,
          onTap: onFilterTap,
        ),
      ],
    );
  }
}

class _ActiveJournalFilterChip extends StatelessWidget {
  const _ActiveJournalFilterChip({required this.filter, required this.onClear});

  final _JournalFilter filter;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      key: const Key('journal_active_filter_clear'),
      behavior: HitTestBehavior.opaque,
      onTap: onClear,
      child: Drop4UpTactileSurface(
        radius: Drop4UpTokens.pillRadius,
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        color: Drop4UpTokens.cardSurface.withValues(alpha: 0.94),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '篩選：${filter.displayLabel}',
              style: textTheme.labelMedium?.copyWith(
                fontSize: 12.5,
                color: Drop4UpTokens.textSecondary,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.close_rounded,
              size: 14,
              color: Drop4UpTokens.textSecondary,
            ),
          ],
        ),
      ),
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

bool _matchesJournalFilter(ReflectionEntry entry, _JournalFilter filter) {
  return switch (filter.kind) {
    _JournalFilterKind.all => true,
    _JournalFilterKind.favorite => entry.isFavorite,
    _JournalFilterKind.taxonomy =>
      entry.source == filter.label || entry.tags.contains(filter.label),
  };
}

String _normalizeTag(String value) {
  final trimmed = value.trim();
  return trimmed.startsWith('#') ? trimmed.substring(1).trim() : trimmed;
}

enum _JournalFilterKind { all, favorite, taxonomy }

class _JournalFilter {
  const _JournalFilter._(this.kind, this.label);

  const _JournalFilter.all() : this._(_JournalFilterKind.all, null);
  const _JournalFilter.favorite() : this._(_JournalFilterKind.favorite, null);
  const _JournalFilter.taxonomy(String label)
    : this._(_JournalFilterKind.taxonomy, label);

  final _JournalFilterKind kind;
  final String? label;

  bool get isAll => kind == _JournalFilterKind.all;

  String get displayLabel {
    return switch (kind) {
      _JournalFilterKind.all => '全部',
      _JournalFilterKind.favorite => '收藏',
      _JournalFilterKind.taxonomy => '#$label',
    };
  }

  bool sameAs(_JournalFilter other) {
    return kind == other.kind && label == other.label;
  }
}

class _JournalFilterStat {
  const _JournalFilterStat(this.label, this.count);

  final String label;
  final int count;
}

List<_JournalFilterStat> _buildJournalFilterStats(
  List<ReflectionEntry> entries,
) {
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
      _JournalFilterStat(key, value),
  ];
  stats.sort((a, b) {
    final countCompare = b.count.compareTo(a.count);
    if (countCompare != 0) {
      return countCompare;
    }
    return a.label.compareTo(b.label);
  });
  return stats;
}

Future<_JournalFilter?> _showJournalFilterSheet(
  BuildContext context, {
  required List<ReflectionEntry> entries,
  required _JournalFilter selectedFilter,
}) {
  final stats = _buildJournalFilterStats(entries);
  final favoriteCount = entries.where((entry) => entry.isFavorite).length;

  return showDialog<_JournalFilter>(
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 560),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('篩選紀錄', style: textTheme.titleMedium),
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
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _JournalFilterOptionChip(
                        key: const Key('journal_filter_all'),
                        label: '全部',
                        count: entries.length,
                        selected: selectedFilter.sameAs(
                          const _JournalFilter.all(),
                        ),
                        onTap: () => Navigator.of(
                          dialogContext,
                        ).pop(const _JournalFilter.all()),
                      ),
                      _JournalFilterOptionChip(
                        key: const Key('journal_filter_favorites'),
                        label: '收藏',
                        count: favoriteCount,
                        selected: selectedFilter.sameAs(
                          const _JournalFilter.favorite(),
                        ),
                        onTap: () => Navigator.of(
                          dialogContext,
                        ).pop(const _JournalFilter.favorite()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '來源與標籤',
                    style: textTheme.labelLarge?.copyWith(
                      color: Drop4UpTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (stats.isEmpty)
                    Text(
                      '還沒有可篩選的來源或標籤。',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Drop4UpTokens.textSecondary,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final stat in stats)
                          _JournalFilterOptionChip(
                            key: ValueKey('journal_filter_${stat.label}'),
                            label: '#${stat.label}',
                            count: stat.count,
                            selected: selectedFilter.sameAs(
                              _JournalFilter.taxonomy(stat.label),
                            ),
                            onTap: () => Navigator.of(
                              dialogContext,
                            ).pop(_JournalFilter.taxonomy(stat.label)),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _JournalFilterOptionChip extends StatelessWidget {
  const _JournalFilterOptionChip({
    super.key,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
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
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        color: selected
            ? Drop4UpTokens.lightBlue.withValues(alpha: 0.28)
            : Drop4UpTokens.cardSurface.withValues(alpha: 0.94),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                fontSize: 13,
                color: selected
                    ? Drop4UpTokens.primaryBlue
                    : Drop4UpTokens.textPrimary.withValues(alpha: 0.82),
              ),
            ),
            const SizedBox(width: 7),
            Text(
              '$count',
              style: textTheme.labelMedium?.copyWith(
                fontSize: 12,
                color: selected
                    ? Drop4UpTokens.primaryBlue.withValues(alpha: 0.76)
                    : Drop4UpTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
  const _CreateVisualCardButton({required this.entry});

  final ReflectionEntry? entry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: '建立視覺卡片',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _showVisualCardPreview(context, entry),
        child: Drop4UpTactileSurface(
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
                  '建立視覺卡片',
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
        ),
      ),
    );
  }
}

Future<void> _showVisualCardPreview(
  BuildContext context,
  ReflectionEntry? entry,
) {
  return showDialog<void>(
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
                  Expanded(child: Text('視覺卡片預覽', style: textTheme.titleMedium)),
                  SoftIconButton(
                    icon: Icons.close_rounded,
                    label: '關閉',
                    size: 40,
                    iconSize: 20,
                    onTap: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (entry == null)
                Text(
                  '先在 Drop 記下一滴，就能在這裡預覽視覺卡片。',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Drop4UpTokens.textSecondary,
                  ),
                )
              else
                _VisualCardPreview(entry: entry),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 132,
                  child: _DialogAction(
                    label: '完成',
                    icon: Icons.check_rounded,
                    onTap: () => Navigator.of(dialogContext).pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _VisualCardPreview extends StatelessWidget {
  const _VisualCardPreview({required this.entry});

  final ReflectionEntry entry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tags = [
      if (entry.source.isNotEmpty) entry.source,
      ...entry.tags,
    ].take(3).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        key: const Key('visual_card_preview'),
        width: double.infinity,
        height: 236,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFBFBFA),
                    Color(0xFFF2F6F7),
                    Color(0xFFE4EEF5),
                    Color(0xFFD1E0EC),
                  ],
                ),
              ),
            ),
            CustomPaint(painter: _VisualCardPainter()),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Drop4Up',
                    style: textTheme.labelLarge?.copyWith(
                      color: Drop4UpTokens.primaryBlue,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    entry.text,
                    key: const Key('visual_card_preview_text'),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: Drop4UpTokens.textPrimary,
                      height: 1.34,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      Text(
                        _formatEntryDate(entry.createdAt),
                        style: textTheme.labelMedium?.copyWith(
                          color: Drop4UpTokens.textSecondary,
                        ),
                      ),
                      for (final tag in tags) _VisualCardTag(label: '#$tag'),
                    ],
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

class _VisualCardTag extends StatelessWidget {
  const _VisualCardTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Drop4UpTokens.pillRadius),
        color: Drop4UpTokens.cardSurface.withValues(alpha: 0.72),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            fontSize: 12,
            color: Drop4UpTokens.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _VisualCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final mist = Paint()
      ..color = Drop4UpTokens.softWhite.withValues(alpha: 0.36)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.72, size.height * 0.24),
        width: size.width * 0.62,
        height: 76,
      ),
      mist,
    );

    final line = Paint()
      ..color = Drop4UpTokens.primaryBlue.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.70)
      ..quadraticBezierTo(
        size.width * 0.32,
        size.height * 0.58,
        size.width * 0.50,
        size.height * 0.69,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.82,
        size.width * 0.92,
        size.height * 0.64,
      );
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
