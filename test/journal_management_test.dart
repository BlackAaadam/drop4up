import 'package:drop4up/data/reflection_entry.dart';
import 'package:drop4up/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_reflection_entry_repository.dart';

void main() {
  testWidgets('search finds Traditional Chinese text', (tester) async {
    await _pumpJournalHarness(tester, entries: [_entry(text: '在安靜裡尋見平安。')]);

    await tester.enterText(find.byKey(const Key('journal_search_input')), '平安');
    await _pumpUi(tester);

    expect(find.text('在安靜裡尋見平安。'), findsOneWidget);
    expect(find.text('找不到符合的紀錄。'), findsNothing);
  });

  testWidgets('empty search shows all entries', (tester) async {
    await _pumpJournalHarness(
      tester,
      entries: [
        _entry(id: 'entry-1', text: '第一筆。'),
        _entry(id: 'entry-2', text: '第二筆。'),
      ],
    );

    expect(find.text('第一筆。'), findsOneWidget);
    expect(find.text('第二筆。'), findsOneWidget);
  });

  testWidgets('no-result state works', (tester) async {
    await _pumpJournalHarness(tester, entries: [_entry(text: '只留下安靜。')]);

    await tester.enterText(
      find.byKey(const Key('journal_search_input')),
      '不存在',
    );
    await _pumpUi(tester);

    expect(find.text('只留下安靜。'), findsNothing);
    expect(find.text('找不到符合的紀錄。'), findsOneWidget);
  });

  testWidgets('hashtag search matches tags and source', (tester) async {
    await _pumpJournalHarness(
      tester,
      entries: [
        _entry(id: 'entry-tag', text: '帶著標籤的一滴。', tags: const ['平安']),
        _entry(id: 'entry-source', text: '從禱告而來。', source: '禱告'),
      ],
    );

    await tester.enterText(
      find.byKey(const Key('journal_search_input')),
      '#平安',
    );
    await _pumpUi(tester);

    expect(find.text('帶著標籤的一滴。'), findsOneWidget);
    expect(find.text('從禱告而來。'), findsNothing);

    await tester.enterText(
      find.byKey(const Key('journal_search_input')),
      '#禱告',
    );
    await _pumpUi(tester);

    expect(find.text('帶著標籤的一滴。'), findsNothing);
    expect(find.text('從禱告而來。'), findsOneWidget);
  });

  testWidgets('filter sheet filters favorites and can clear', (tester) async {
    await _pumpJournalHarness(
      tester,
      entries: [
        _entry(id: 'favorite-entry', text: '收藏的一滴。', isFavorite: true),
        _entry(id: 'plain-entry', text: '一般的一滴。'),
      ],
    );

    await tester.tap(find.byKey(const Key('journal_filter_button')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('journal_filter_favorites')));
    await _pumpUi(tester);

    expect(find.text('收藏的一滴。'), findsOneWidget);
    expect(find.text('一般的一滴。'), findsNothing);
    expect(find.text('篩選：收藏'), findsOneWidget);

    await tester.tap(find.byKey(const Key('journal_active_filter_clear')));
    await _pumpUi(tester);

    expect(find.text('收藏的一滴。'), findsOneWidget);
    expect(find.text('一般的一滴。'), findsOneWidget);
  });

  testWidgets('filter sheet filters by source and tag', (tester) async {
    await _pumpJournalHarness(
      tester,
      entries: [
        _entry(
          id: 'tag-entry',
          text: '平安標籤的一滴。',
          source: '講道',
          tags: const ['平安'],
        ),
        _entry(id: 'source-entry', text: '禱告來源的一滴。', source: '禱告'),
      ],
    );

    await tester.tap(find.byKey(const Key('journal_filter_button')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const ValueKey('journal_filter_平安')));
    await _pumpUi(tester);

    expect(find.text('平安標籤的一滴。'), findsOneWidget);
    expect(find.text('禱告來源的一滴。'), findsNothing);
    expect(find.text('篩選：#平安'), findsOneWidget);

    await tester.tap(find.byKey(const Key('journal_active_filter_clear')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('journal_filter_button')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const ValueKey('journal_filter_禱告')));
    await _pumpUi(tester);

    expect(find.text('平安標籤的一滴。'), findsNothing);
    expect(find.text('禱告來源的一滴。'), findsOneWidget);
    expect(find.text('篩選：#禱告'), findsOneWidget);
  });

  testWidgets('edit preserves exact spaces and line breaks', (tester) async {
    final repository = await _pumpJournalHarness(
      tester,
      entries: [_entry(id: 'entry-edit', text: '原本的文字。')],
    );
    const editedText = '  神的平安仍在。\n\n「不要害怕。」\n\t阿們。  ';

    await tester.tap(find.byKey(const ValueKey('journal_entry_entry-edit')));
    await _pumpUi(tester);
    await tester.enterText(
      find.byKey(const Key('entry_detail_text_input')),
      editedText,
    );
    await tester.tap(find.byKey(const Key('entry_save_button')));
    await _pumpUi(tester);

    final entry = (await repository.load()).entries.single;

    expect(entry.text, editedText);
    expect(entry.text.codeUnits, editedText.codeUnits);
    expect(entry.updatedAt, DateTime.utc(2026, 5, 7, 12, 30));
    expect(entry.createdAt, DateTime.utc(2026, 5, 7, 8));
  });

  testWidgets('edit updates source and tags without changing text', (
    tester,
  ) async {
    final repository = await _pumpJournalHarness(
      tester,
      entries: [
        _entry(
          id: 'entry-metadata',
          text: '  原文不改。\n阿們。  ',
          tags: const ['平安'],
        ),
      ],
    );

    await tester.tap(
      find.byKey(const ValueKey('journal_entry_entry-metadata')),
    );
    await _pumpUi(tester);

    await tester.tap(find.byKey(const ValueKey('entry_source_禱告')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const ValueKey('entry_tag_平安')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('entry_add_tag_button')));
    await _pumpUi(tester);
    await tester.enterText(find.byKey(const Key('entry_add_tag_input')), '#信心');
    await tester.tap(find.byKey(const Key('entry_add_tag_confirm_button')));
    await _pumpUi(tester);

    await tester.tap(find.byKey(const Key('entry_save_button')));
    await _pumpUi(tester);

    final entry = (await repository.load()).entries.single;

    expect(entry.text, '  原文不改。\n阿們。  ');
    expect(entry.text.codeUnits, '  原文不改。\n阿們。  '.codeUnits);
    expect(entry.source, '禱告');
    expect(entry.tags, const ['信心']);
  });

  testWidgets('edit can update date without changing entry content', (
    tester,
  ) async {
    final repository = await _pumpJournalHarness(
      tester,
      entries: [
        _entry(
          id: 'entry-date',
          text: '  Date edit keeps this text.\nAmen.  ',
          source: '講道',
          tags: const ['平安'],
          createdAt: DateTime.utc(2026, 5, 7, 8),
        ),
      ],
    );

    await tester.tap(find.byKey(const ValueKey('journal_entry_entry-date')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('entry_date_picker_button')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const ValueKey('date_picker_day_2026-05-05')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('date_picker_confirm_button')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('entry_save_button')));
    await _pumpUi(tester);

    final entry = (await repository.load()).entries.single;

    expect(entry.text, '  Date edit keeps this text.\nAmen.  ');
    expect(
      entry.text.codeUnits,
      '  Date edit keeps this text.\nAmen.  '.codeUnits,
    );
    expect(entry.source, '講道');
    expect(entry.tags, const ['平安']);
    expect(entry.createdAt, DateTime.utc(2026, 5, 5));
    expect(entry.updatedAt, DateTime.utc(2026, 5, 7, 12, 30));
  });

  testWidgets('editing date reorders recent drops by created date', (
    tester,
  ) async {
    final repository = await _pumpJournalHarness(
      tester,
      entries: [
        _entry(
          id: 'entry-target',
          text: 'Target entry.',
          createdAt: DateTime.utc(2026, 5, 4, 8),
        ),
        _entry(
          id: 'entry-current-first',
          text: 'Current first entry.',
          createdAt: DateTime.utc(2026, 5, 5, 8),
        ),
      ],
    );

    await tester.tap(find.byKey(const ValueKey('journal_entry_entry-target')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('entry_date_picker_button')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const ValueKey('date_picker_day_2026-05-06')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('date_picker_confirm_button')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('entry_save_button')));
    await _pumpUi(tester);

    final entries = (await repository.load()).entries;

    expect(entries.first.id, 'entry-target');
    expect(entries.first.createdAt, DateTime.utc(2026, 5, 6));
    expect(entries.last.id, 'entry-current-first');
  });

  testWidgets('visual card preview uses first visible entry exactly', (
    tester,
  ) async {
    const previewText = '  建立卡片時，也要保留這一滴原文。\n第二行也保留。  ';
    await _pumpJournalHarness(
      tester,
      entries: [
        _entry(
          id: 'entry-preview',
          text: previewText,
          source: '閱讀',
          tags: const ['愛'],
          createdAt: DateTime.utc(2026, 5, 9, 8),
        ),
        _entry(
          id: 'entry-other',
          text: '另一滴。',
          source: '禱告',
          createdAt: DateTime.utc(2026, 5, 7, 8),
        ),
      ],
    );

    await tester.tap(find.text('建立視覺卡片'));
    await _pumpUi(tester);

    final preview = tester.widget<Text>(
      find.byKey(const Key('visual_card_preview_text')),
    );

    expect(find.text('視覺卡片預覽'), findsOneWidget);
    expect(preview.data, previewText);
    expect(preview.data!.codeUnits, previewText.codeUnits);
    final previewCard = find.byKey(const Key('visual_card_preview'));
    expect(
      find.descendant(of: previewCard, matching: find.text('#閱讀')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: previewCard, matching: find.text('#愛')),
      findsOneWidget,
    );
  });

  testWidgets('visual card preview has empty guidance without entries', (
    tester,
  ) async {
    await _pumpJournalHarness(tester, entries: const []);

    await tester.tap(find.text('建立視覺卡片'));
    await _pumpUi(tester);

    expect(find.text('視覺卡片預覽'), findsOneWidget);
    expect(find.text('先在 Drop 記下一滴，就能在這裡預覽視覺卡片。'), findsOneWidget);
  });

  testWidgets('favorite persists after reload', (tester) async {
    final repository = await _pumpJournalHarness(
      tester,
      entries: [_entry(id: 'entry-favorite', text: '收藏這一滴。')],
    );

    await tester.tap(find.byKey(const ValueKey('favorite_entry-favorite')));
    await _pumpUi(tester);
    await tester.pumpWidget(Drop4UpPreviewApp(repository: repository));
    await _pumpUi(tester);

    final entry = (await repository.load()).entries.single;

    expect(entry.isFavorite, isTrue);
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
  });

  testWidgets('delete persists after reload', (tester) async {
    final repository = await _pumpJournalHarness(
      tester,
      entries: [_entry(id: 'entry-delete', text: '準備刪除。')],
    );

    await tester.tap(find.byKey(const ValueKey('journal_entry_entry-delete')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('entry_delete_button')));
    await _pumpUi(tester);
    expect(find.text('刪除這一滴？'), findsOneWidget);

    await tester.tap(find.byKey(const Key('delete_confirm_button')));
    await _pumpUi(tester);
    await tester.pumpWidget(Drop4UpPreviewApp(repository: repository));
    await _pumpUi(tester);

    expect((await repository.load()).entries, isEmpty);
    expect(find.text('準備刪除。'), findsNothing);
    expect(find.text('還沒有儲存的紀錄。'), findsOneWidget);
  });
}

Future<TestReflectionEntryRepository> _pumpJournalHarness(
  WidgetTester tester, {
  required List<ReflectionEntry> entries,
}) async {
  tester.view.physicalSize = const Size(393, 873);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final repository = TestReflectionEntryRepository();
  await repository.saveEntries(entries);
  await tester.pumpWidget(
    Drop4UpPreviewApp(
      repository: repository,
      clock: () => DateTime.utc(2026, 5, 7, 12, 30),
    ),
  );
  await _pumpUi(tester);
  await tester.tap(find.text('Journal'));
  await _pumpUi(tester);
  return repository;
}

ReflectionEntry _entry({
  String id = 'entry-1',
  required String text,
  String source = '講道',
  List<String> tags = const [],
  DateTime? createdAt,
  bool isFavorite = false,
}) {
  final timestamp = createdAt ?? DateTime.utc(2026, 5, 7, 8);
  return ReflectionEntry(
    id: id,
    text: text,
    source: source,
    tags: tags,
    createdAt: timestamp,
    updatedAt: timestamp,
    isFavorite: isFavorite,
  );
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}
