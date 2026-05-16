import 'dart:convert';
import 'dart:io';
import 'package:drop4up/data/profile_backup_file_service.dart';
import 'package:drop4up/data/drop4up_preferences.dart';
import 'package:drop4up/data/drop4up_preferences_repository.dart';
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

  testWidgets('Backup dialog offers file backup without exposing raw data', (
    tester,
  ) async {
    await _pumpProfileHarness(
      tester,
      entries: [
        _entry(
          id: 'entry-backup',
          text: '  Keep this text exactly.\n\n# not a tag rewrite  ',
          source: '閱讀',
          tags: const ['感恩'],
        ),
      ],
    );

    await tester.tap(find.text('備份資料'));
    await _pumpUi(tester);

    expect(find.byKey(const Key('profile_backup_file_button')), findsOneWidget);
    expect(find.text('儲存備份檔'), findsOneWidget);
    expect(find.textContaining('Drop4Up_Backup'), findsOneWidget);
    expect(find.byKey(const Key('profile_backup_json_text')), findsNothing);
  });

  testWidgets('Backup failure shows error and keeps sheet open', (
    tester,
  ) async {
    final repository = await _pumpProfileHarness(
      tester,
      entries: [_entry(id: 'safe-entry', text: 'Keep local data safe')],
      backupFileService: ProfileBackupFileService(
        directoryProvider: () async {
          throw StateError('write failed');
        },
      ),
    );

    await tester.tap(find.byIcon(Icons.file_download_outlined));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('profile_backup_file_button')));
    await _pumpUi(tester);

    expect(find.byKey(const Key('profile_backup_file_error')), findsOneWidget);
    expect(find.byKey(const Key('profile_backup_file_button')), findsOneWidget);
    expect((await repository.load()).entries.single.id, 'safe-entry');
  });

  testWidgets('Restore valid JSON can replace local entries', (tester) async {
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
    expect(
      find.byKey(const Key('profile_restore_file_button')),
      findsOneWidget,
    );
    expect(find.text('選擇備份檔'), findsOneWidget);
    expect(find.text('合併'), findsOneWidget);
    expect(find.text('取代全部'), findsOneWidget);
    await tester.tap(find.byKey(const Key('profile_restore_strategy_replace')));
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
    expect(find.text('本機紀錄已取代為備份內容。'), findsOneWidget);
  });

  testWidgets('Restore valid JSON merges by default without rewriting text', (
    tester,
  ) async {
    const localText = '  Local text remains exact.\nAmen.  ';
    const restoredText = '  Restored text stays exact.\nSecond line.  ';
    final repository = await _pumpProfileHarness(
      tester,
      entries: [_entry(id: 'local-entry', text: localText)],
    );

    await tester.tap(find.text('還原資料'));
    await _pumpUi(tester);
    await tester.enterText(
      find.byKey(const Key('profile_restore_json_input')),
      _backupJson([
        _entry(
          id: 'local-entry',
          text: 'Backup duplicate should not overwrite local text.',
        ),
        _entry(id: 'restored-entry', text: restoredText, source: '閱讀'),
      ]),
    );
    await tester.tap(find.byKey(const Key('profile_restore_confirm_button')));
    await _pumpUi(tester);

    final entries = (await repository.load()).entries;

    expect(entries, hasLength(2));
    expect(
      entries.map((entry) => entry.id),
      containsAll(['local-entry', 'restored-entry']),
    );
    expect(
      entries.singleWhere((entry) => entry.id == 'local-entry').text,
      localText,
    );
    expect(
      entries.singleWhere((entry) => entry.id == 'local-entry').text.codeUnits,
      localText.codeUnits,
    );
    expect(
      entries.singleWhere((entry) => entry.id == 'restored-entry').text,
      restoredText,
    );
    expect(
      entries
          .singleWhere((entry) => entry.id == 'restored-entry')
          .text
          .codeUnits,
      restoredText.codeUnits,
    );
    expect(find.text('備份紀錄已合併到本機。'), findsOneWidget);
  });

  testWidgets('Restore sheet exposes file entry and preserves paste restore', (
    tester,
  ) async {
    const restoredText = '檔案中的中文要先看得到。';
    final repository = await _pumpProfileHarness(
      tester,
      entries: [_entry(id: 'old-entry', text: 'Old local drop')],
      backupFileService: ProfileBackupFileService(filePicker: () async => null),
    );

    await tester.tap(find.text('還原資料'));
    await _pumpUi(tester);

    expect(
      find.byKey(const Key('profile_restore_file_button')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('profile_restore_preview_text')), findsNothing);
    await tester.enterText(
      find.byKey(const Key('profile_restore_json_input')),
      _backupJson([
        _entry(id: 'preview-entry', text: restoredText, source: '閱讀'),
      ]),
    );
    await tester.tap(find.byKey(const Key('profile_restore_strategy_replace')));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('profile_restore_confirm_button')));
    await _pumpUi(tester);

    final entry = (await repository.load()).entries.single;
    expect(entry.text, restoredText);
    expect(entry.text.codeUnits, restoredText.codeUnits);
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
    expect(find.text('大字體模式'), findsOneWidget);
    expect(find.text('目前使用標準文字大小。'), findsOneWidget);
    await tester.tap(find.text('完成'));
    await _pumpUi(tester);

    await tester.tap(find.text('關於 Drop4Up'));
    await _pumpUi(tester);
    expect(
      find.textContaining('Drop4Up 是一個安靜的 Flutter UI prototype'),
      findsOneWidget,
    );
  });

  testWidgets('Preferences large text setting persists and updates theme', (
    tester,
  ) async {
    final preferencesRepository = _TestDrop4UpPreferencesRepository();
    await _pumpProfileHarness(
      tester,
      entries: const [],
      preferencesRepository: preferencesRepository,
    );
    final before = tester.widget<Text>(find.text('備份資料')).style?.fontSize;

    await tester.tap(find.text('偏好設定'));
    await _pumpUi(tester);
    await tester.tap(find.byKey(const Key('profile_large_text_toggle')));
    await _pumpUi(tester);

    expect(preferencesRepository.preferences.largeText, isTrue);
    expect(find.text('目前使用較大的閱讀文字。'), findsOneWidget);
    await tester.tap(find.text('完成'));
    await _pumpUi(tester);
    final after = tester.widget<Text>(find.text('備份資料')).style?.fontSize;
    expect(after, greaterThan(before!));

    await tester.pumpWidget(
      Drop4UpPreviewApp(
        repository: TestReflectionEntryRepository(),
        preferencesRepository: preferencesRepository,
      ),
    );
    await _pumpUi(tester);

    await tester.tap(find.text('偏好設定'));
    await _pumpUi(tester);
    expect(find.text('目前使用較大的閱讀文字。'), findsOneWidget);
  });
}

Future<TestReflectionEntryRepository> _pumpProfileHarness(
  WidgetTester tester, {
  required List<ReflectionEntry> entries,
  ProfileBackupFileService? backupFileService,
  Drop4UpPreferencesRepository? preferencesRepository,
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
      preferencesRepository: preferencesRepository,
      profileBackupFileService: backupFileService,
      clock: () => DateTime.utc(2026, 5, 9, 12),
    ),
  );
  await _pumpUi(tester);
  await tester.tap(find.text('Profile'));
  await _pumpUi(tester);
  return repository;
}

class _TestDrop4UpPreferencesRepository extends Drop4UpPreferencesRepository {
  _TestDrop4UpPreferencesRepository()
    : super(documentsDirectoryProvider: _unusedDirectoryProvider);

  Drop4UpPreferences preferences = Drop4UpPreferences.defaults;

  @override
  Future<Drop4UpPreferences> load() async {
    return preferences;
  }

  @override
  Future<void> save(Drop4UpPreferences preferences) async {
    this.preferences = preferences;
  }
}

Future<Directory> _unusedDirectoryProvider() async {
  throw StateError('_TestDrop4UpPreferencesRepository does not use file IO.');
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
