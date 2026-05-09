import 'package:drop4up/data/reflection_entry.dart';
import 'package:drop4up/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_reflection_entry_repository.dart';

void main() {
  testWidgets('Drop save creates an entry', (tester) async {
    final harness = await _pumpHarness(tester);
    const text = '主啊，求你保守我的心。\n  This spacing stays.';

    await tester.tap(find.text('Drop'));
    await _pumpUi(tester);
    await tester.enterText(find.byKey(const Key('drop_text_input')), text);
    await tester.tap(find.byKey(const Key('save_drop_button')));
    await _pumpUi(tester);

    final document = await harness.repository.load();
    final entry = document.entries.single;

    expect(entry.id, 'entry-1');
    expect(entry.text, text);
    expect(entry.source, '講道');
    expect(entry.tags, isEmpty);
    expect(entry.createdAt, DateTime.utc(2026, 5, 7, 12));
    expect(entry.updatedAt, DateTime.utc(2026, 5, 7, 12));
    expect(entry.isFavorite, isFalse);
    expect(find.text('已儲存在本機。'), findsOneWidget);
  });

  testWidgets('saved entry appears in Journal', (tester) async {
    await _pumpHarness(tester);
    const text = '今天安靜記下一句，不改寫。';

    await tester.tap(find.text('Drop'));
    await _pumpUi(tester);
    await tester.enterText(find.byKey(const Key('drop_text_input')), text);
    await tester.tap(find.byKey(const Key('save_drop_button')));
    await _pumpUi(tester);

    await tester.tap(find.text('Journal'));
    await _pumpUi(tester);

    expect(find.text(text), findsOneWidget);
    expect(find.text('還沒有儲存的紀錄。'), findsNothing);
  });

  testWidgets('app reload loads entries from repository', (tester) async {
    final repository = TestReflectionEntryRepository();
    const text = '重新開啟後仍然看見這一筆。';

    await repository.saveEntries([
      ReflectionEntry(
        id: 'stored-entry',
        text: text,
        source: 'Prayer',
        tags: const [],
        createdAt: DateTime.utc(2026, 5, 7, 8),
        updatedAt: DateTime.utc(2026, 5, 7, 8),
        isFavorite: false,
      ),
    ]);

    await tester.pumpWidget(Drop4UpPreviewApp(repository: repository));
    await _pumpUi(tester);
    await tester.tap(find.text('Journal'));
    await _pumpUi(tester);

    expect(find.text(text), findsOneWidget);
  });

  testWidgets('saved text is preserved exactly with Traditional Chinese', (
    tester,
  ) async {
    final harness = await _pumpHarness(tester);
    const text = '  神的平安，今日仍然同在。\n\n「不要害怕。」\n\t阿們。  ';

    await tester.tap(find.text('Drop'));
    await _pumpUi(tester);
    await tester.enterText(find.byKey(const Key('drop_text_input')), text);
    await tester.tap(find.byKey(const Key('save_drop_button')));
    await _pumpUi(tester);

    final entry = (await harness.repository.load()).entries.single;

    expect(entry.text, text);
    expect(entry.text.codeUnits, text.codeUnits);
  });

  testWidgets('Drop layout saves selected manual tags without label clutter', (
    tester,
  ) async {
    final harness = await _pumpHarness(tester);
    const text = '  平安仍然同在。\n不要改寫這一句。  ';

    await tester.tap(find.text('Drop'));
    await _pumpUi(tester);

    expect(find.text('來源'), findsNothing);
    expect(find.text('可選附件'), findsNothing);
    expect(find.text('#平安'), findsOneWidget);
    expect(find.text('#信心'), findsOneWidget);
    expect(find.text('#感恩'), findsOneWidget);
    expect(find.text('#愛'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('drop_text_input')), text);
    await tester.tap(find.text('#平安'));
    await tester.tap(find.byKey(const Key('save_drop_button')));
    await _pumpUi(tester);

    final entry = (await harness.repository.load()).entries.single;

    expect(entry.text, text);
    expect(entry.tags, const ['平安']);
  });

  testWidgets('Drop plus button adds and saves a custom tag', (tester) async {
    final harness = await _pumpHarness(tester);
    const text = '今天交託新的標籤。';

    await tester.tap(find.text('Drop'));
    await _pumpUi(tester);

    await tester.tap(find.byKey(const Key('drop_add_tag_button')));
    await _pumpUi(tester);
    await tester.enterText(find.byKey(const Key('drop_add_tag_input')), '#盼望');
    await tester.tap(find.byKey(const Key('drop_add_tag_confirm_button')));
    await _pumpUi(tester);

    expect(find.text('#盼望'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('drop_text_input')), text);
    await tester.tap(find.byKey(const Key('save_drop_button')));
    await _pumpUi(tester);

    final entry = (await harness.repository.load()).entries.single;

    expect(entry.text, text);
    expect(entry.tags, const ['盼望']);
  });
}

Future<_Harness> _pumpHarness(WidgetTester tester) async {
  tester.view.physicalSize = const Size(393, 873);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final repository = TestReflectionEntryRepository();

  var nextId = 0;
  await tester.pumpWidget(
    Drop4UpPreviewApp(
      repository: repository,
      clock: () => DateTime.utc(2026, 5, 7, 12),
      idGenerator: () => 'entry-${++nextId}',
    ),
  );
  await _pumpUi(tester);

  return _Harness(repository);
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}

class _Harness {
  const _Harness(this.repository);

  final TestReflectionEntryRepository repository;
}
