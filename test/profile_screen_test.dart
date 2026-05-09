import 'dart:convert';

import 'package:drop4up/data/reflection_entry.dart';
import 'package:drop4up/data/reflection_entry_document.dart';
import 'package:drop4up/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_reflection_entry_repository.dart';

void main() {
  testWidgets('Profile summary reflects local entries', (tester) async {
    await _pumpProfileHarness(
      tester,
      entries: [
        _entry(
          id: 'entry-1',
          text: 'First drop',
          source: '講道',
          tags: const ['平安', '信心'],
          isFavorite: true,
        ),
        _entry(
          id: 'entry-2',
          text: 'Second drop',
          source: '禱告',
          tags: const ['平安'],
          createdAt: DateTime.utc(2026, 5, 8, 9),
        ),
      ],
    );

    expect(find.text('本機紀錄'), findsOneWidget);
    expect(find.text('紀錄'), findsOneWidget);
    expect(find.text('收藏'), findsOneWidget);
    expect(find.text('來源'), findsOneWidget);
    expect(find.text('標籤'), findsOneWidget);
    expect(find.text('最近儲存：2026.05.08'), findsOneWidget);
  });

  testWidgets('Backup dialog exposes valid JSON with exact text', (
    tester,
  ) async {
    const text = '  Keep this text exactly.\n\n# not a tag rewrite  ';
    await _pumpProfileHarness(
      tester,
      entries: [
        _entry(
          id: 'entry-backup',
          text: text,
          source: '閱讀',
          tags: const ['感恩'],
        ),
      ],
    );

    await tester.tap(find.text('備份資料'));
    await _pumpUi(tester);

    final preview = tester.widget<SelectableText>(
      find.byKey(const Key('profile_backup_json_text')),
    );
    final decoded = jsonDecode(preview.data!);
    final document = ReflectionEntryDocument.fromJson(
      (decoded as Map).cast<String, Object?>(),
    );
    final entry = document.entries.single;

    expect(entry.text, text);
    expect(entry.text.codeUnits, text.codeUnits);
    expect(entry.source, '閱讀');
    expect(entry.tags, const ['感恩']);
  });

  testWidgets('Restore valid JSON replaces local entries', (tester) async {
    final repository = await _pumpProfileHarness(
      tester,
      entries: [_entry(id: 'old-entry', text: 'Old local drop')],
    );
    const restoredText = 'Restored text stays exact.\n  Amen.';
    final backupJson = _backupJson([
      _entry(
        id: 'restored-entry',
        text: restoredText,
        source: '禱告',
        tags: const ['信心'],
      ),
    ]);

    await tester.tap(find.text('還原資料'));
    await _pumpUi(tester);
    await tester.enterText(
      find.byKey(const Key('profile_restore_json_input')),
      backupJson,
    );
    await tester.tap(find.text('還原'));
    await _pumpUi(tester);

    final entry = (await repository.load()).entries.single;

    expect(entry.id, 'restored-entry');
    expect(entry.text, restoredText);
    expect(entry.text.codeUnits, restoredText.codeUnits);
    expect(entry.source, '禱告');
    expect(entry.tags, const ['信心']);
    expect(find.text('本機紀錄已還原。'), findsOneWidget);
  });

  testWidgets('Restore malformed JSON shows error without overwrite', (
    tester,
  ) async {
    final repository = await _pumpProfileHarness(
      tester,
      entries: [_entry(id: 'safe-entry', text: 'Keep me')],
    );

    await tester.tap(find.text('還原資料'));
    await _pumpUi(tester);
    await tester.enterText(
      find.byKey(const Key('profile_restore_json_input')),
      '{ nope',
    );
    await tester.tap(find.text('還原'));
    await _pumpUi(tester);

    expect(find.byKey(const Key('profile_restore_error')), findsOneWidget);

    final entry = (await repository.load()).entries.single;
    expect(entry.id, 'safe-entry');
    expect(entry.text, 'Keep me');
  });

  testWidgets('About and Preferences actions open Profile dialogs', (
    tester,
  ) async {
    await _pumpProfileHarness(tester, entries: const []);

    await tester.tap(find.text('偏好設定'));
    await _pumpUi(tester);
    expect(find.textContaining('安靜的本機偏好設定會在之後加入'), findsOneWidget);
    await tester.tap(find.text('完成'));
    await _pumpUi(tester);

    await tester.tap(find.text('關於 Drop4Up'));
    await _pumpUi(tester);
    expect(
      find.textContaining('Drop4Up 是一個安靜的 Flutter UI prototype'),
      findsOneWidget,
    );
  });
}

Future<TestReflectionEntryRepository> _pumpProfileHarness(
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
  await tester.tap(find.text('Profile'));
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

String _backupJson(List<ReflectionEntry> entries) {
  return jsonEncode(
    ReflectionEntryDocument(
      schemaVersion: ReflectionEntryDocument.currentSchemaVersion,
      exportedAt: DateTime.utc(2026, 5, 9, 12),
      entries: entries,
    ).toJson(),
  );
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}
