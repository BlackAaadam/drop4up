import 'package:drop4up/data/reflection_entry.dart';
import 'package:drop4up/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_reflection_entry_repository.dart';

void main() {
  testWidgets('Home empty state shows fallback reflection and suggested tags', (
    tester,
  ) async {
    await _pumpHomeHarness(tester, entries: const []);

    expect(find.text('探索標籤'), findsOneWidget);
    expect(find.text('還沒有儲存的紀錄。\n一句也可以，慢慢記下。'), findsOneWidget);
    expect(find.text('恩典'), findsOneWidget);
    expect(find.text('禱告'), findsOneWidget);
    expect(find.text('平安'), findsOneWidget);
  });

  testWidgets(
    'Home reflection prefers latest favorite entry and preserves text',
    (tester) async {
      const favoriteText = '  祂在安靜裡提醒我。\n\n原文要完整保留。  ';
      await _pumpHomeHarness(
        tester,
        entries: [
          _entry(
            id: 'latest-entry',
            text: '最新但未收藏。',
            source: '講道',
            createdAt: DateTime.utc(2026, 5, 9, 9),
          ),
          _entry(
            id: 'favorite-entry',
            text: favoriteText,
            source: '禱告',
            tags: const ['感恩'],
            createdAt: DateTime.utc(2026, 5, 8, 9),
            isFavorite: true,
          ),
        ],
      );

      final reflectionText = tester.widget<Text>(
        find.byKey(const Key('home_reflection_text')),
      );

      expect(reflectionText.data, favoriteText);
      expect(reflectionText.data!.codeUnits, favoriteText.codeUnits);
      expect(find.text('2026.05.08  ·  感恩'), findsOneWidget);
    },
  );

  testWidgets('Home tags are generated from source and tags', (tester) async {
    await _pumpHomeHarness(
      tester,
      entries: [
        _entry(
          id: 'entry-1',
          text: '第一滴',
          source: '講道',
          tags: const ['平安', '信心'],
        ),
        _entry(
          id: 'entry-2',
          text: '第二滴',
          source: '禱告',
          tags: const ['平安'],
          createdAt: DateTime.utc(2026, 5, 8, 9),
        ),
      ],
    );

    expect(find.byKey(const ValueKey('home_tag_平安')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('home_tag_平安')),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('home_tag_講道')), findsOneWidget);
    expect(find.byKey(const ValueKey('home_tag_禱告')), findsOneWidget);
  });

  testWidgets('Home tag tap selects matching reflection only on Home', (
    tester,
  ) async {
    await _pumpHomeHarness(
      tester,
      entries: [
        _entry(
          id: 'peace-entry',
          text: '平安相關的一滴。',
          source: '講道',
          tags: const ['平安'],
          createdAt: DateTime.utc(2026, 5, 9, 9),
        ),
        _entry(
          id: 'favorite-entry',
          text: '收藏的感恩回望。',
          source: '禱告',
          tags: const ['感恩'],
          createdAt: DateTime.utc(2026, 5, 8, 9),
          isFavorite: true,
        ),
      ],
    );

    expect(find.text('收藏的感恩回望。'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('home_tag_平安')));
    await _pumpUi(tester);

    expect(find.text('平安相關的一滴。'), findsOneWidget);
    expect(find.text('2026.05.09  ·  平安'), findsOneWidget);
    expect(find.byKey(const Key('journal_search_input')), findsNothing);
  });

  testWidgets('Home view all opens Journal with selected tag filter', (
    tester,
  ) async {
    await _pumpHomeHarness(
      tester,
      entries: [
        _entry(
          id: 'peace-entry',
          text: '平安相關的一滴。',
          source: '講道',
          tags: const ['平安'],
          createdAt: DateTime.utc(2026, 5, 9, 9),
        ),
        _entry(
          id: 'gratitude-entry',
          text: '感恩相關的一滴。',
          source: '禱告',
          tags: const ['感恩'],
          createdAt: DateTime.utc(2026, 5, 8, 9),
        ),
      ],
    );

    await tester.tap(find.byKey(const ValueKey('home_tag_平安')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('home_view_all_tags')));
    await _pumpUi(tester);

    expect(find.text('Journal'), findsWidgets);
    expect(find.text('篩選：#平安'), findsOneWidget);
    expect(find.text('平安相關的一滴。'), findsOneWidget);
    expect(find.text('感恩相關的一滴。'), findsNothing);
  });

  testWidgets('Home view all opens Journal without filter when none selected', (
    tester,
  ) async {
    await _pumpHomeHarness(
      tester,
      entries: [
        _entry(id: 'entry-1', text: '第一滴。', tags: const ['平安']),
        _entry(
          id: 'entry-2',
          text: '第二滴。',
          tags: const ['感恩'],
          createdAt: DateTime.utc(2026, 5, 8, 9),
        ),
      ],
    );

    await tester.tap(find.byKey(const Key('home_view_all_tags')));
    await _pumpUi(tester);

    expect(find.text('Journal'), findsWidgets);
    expect(find.byKey(const Key('journal_active_filter_clear')), findsNothing);
    expect(find.text('第一滴。'), findsOneWidget);
    expect(find.text('第二滴。'), findsOneWidget);
  });
}

Future<TestReflectionEntryRepository> _pumpHomeHarness(
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
      clock: () => DateTime.utc(2026, 5, 9, 12),
    ),
  );
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
