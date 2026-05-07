import 'package:flutter/material.dart';

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

const _entries = [
  _JournalEntry(
    date: '2026.05.07',
    text: '今天在安靜裡想起，祂的平安仍然保守我的心。',
    tags: ['平安', '禱告'],
    pinned: true,
  ),
  _JournalEntry(
    date: '2026.05.04',
    text: '一句提醒停在心裡：先信靠，再往前走。',
    tags: ['信靠', '講道'],
    pinned: false,
  ),
];

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

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
        const _SearchRow(),
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
        for (final entry in _entries) ...[
          _JournalEntryCard(entry: entry),
          if (entry != _entries.last) const SizedBox(height: 9),
        ],
        const SizedBox(height: 11),
        const _CreateVisualCardButton(),
      ],
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow();

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
                Text(
                  '搜尋 drops',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Drop4UpTokens.textSecondary,
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

  final _JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SoftSurface(
      variant: SoftSurfaceVariant.prominent,
      radius: 26,
      padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                entry.date,
                style: textTheme.labelMedium?.copyWith(
                  color: Drop4UpTokens.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(
                entry.pinned
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                size: 20,
                color: entry.pinned
                    ? Drop4UpTokens.primaryBlue
                    : Drop4UpTokens.textSecondary,
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
          const SizedBox(height: 7),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [for (final tag in entry.tags) _MiniTag(label: tag)],
          ),
        ],
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

class _JournalEntry {
  const _JournalEntry({
    required this.date,
    required this.text,
    required this.tags,
    required this.pinned,
  });

  final String date;
  final String text;
  final List<String> tags;
  final bool pinned;
}
