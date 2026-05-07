import 'dart:convert';
import 'dart:io';

import 'package:drop4up/data/reflection_entry.dart';
import 'package:drop4up/data/reflection_entry_document.dart';
import 'package:drop4up/data/reflection_entry_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReflectionEntryRepository', () {
    test('JSON round-trip preserves every field', () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'reflection_entries_test_',
      );
      addTearDown(() => tempDir.delete(recursive: true));

      final repository = ReflectionEntryRepository(
        documentsDirectoryProvider: () async => tempDir,
      );
      final createdAt = DateTime.utc(2026, 5, 7, 8, 30);
      final updatedAt = DateTime.utc(2026, 5, 7, 9, 45);
      final exportedAt = DateTime.utc(2026, 5, 7, 10);
      final entry = ReflectionEntry(
        id: 'entry-1',
        text: '主啊，求你保守我的心。\n  Preserve this spacing exactly.',
        source: 'Prayer',
        tags: ['禱告', '安靜'],
        createdAt: createdAt,
        updatedAt: updatedAt,
        isFavorite: true,
      );

      await repository.saveEntries([entry], exportedAt: exportedAt);

      final loaded = await repository.load();
      final loadedEntry = loaded.entries.single;

      expect(
        loaded.schemaVersion,
        ReflectionEntryDocument.currentSchemaVersion,
      );
      expect(loaded.exportedAt, exportedAt);
      expect(loadedEntry.id, entry.id);
      expect(loadedEntry.text, entry.text);
      expect(loadedEntry.source, entry.source);
      expect(loadedEntry.tags, entry.tags);
      expect(loadedEntry.createdAt, entry.createdAt);
      expect(loadedEntry.updatedAt, entry.updatedAt);
      expect(loadedEntry.isFavorite, entry.isFavorite);
    });

    test('missing storage file returns empty data', () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'reflection_entries_test_',
      );
      addTearDown(() => tempDir.delete(recursive: true));

      final repository = ReflectionEntryRepository(
        documentsDirectoryProvider: () async => tempDir,
      );

      final loaded = await repository.load();

      expect(
        loaded.schemaVersion,
        ReflectionEntryDocument.currentSchemaVersion,
      );
      expect(loaded.entries, isEmpty);
    });

    test(
      'malformed JSON restore fails clearly without overwriting data',
      () async {
        final tempDir = await Directory.systemTemp.createTemp(
          'reflection_entries_test_',
        );
        addTearDown(() => tempDir.delete(recursive: true));
        final file = File(
          '${tempDir.path}${Platform.pathSeparator}reflection_entries.json',
        );
        const malformed = '{ "schemaVersion": 1, "entries": [';
        await file.writeAsString(malformed);

        final repository = ReflectionEntryRepository(
          documentsDirectoryProvider: () async => tempDir,
        );

        expect(
          repository.load,
          throwsA(isA<MalformedReflectionStorageException>()),
        );
        expect(await file.readAsString(), malformed);
      },
    );

    test('unsupported schemaVersion fails clearly', () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'reflection_entries_test_',
      );
      addTearDown(() => tempDir.delete(recursive: true));
      final file = File(
        '${tempDir.path}${Platform.pathSeparator}reflection_entries.json',
      );
      await file.writeAsString(
        jsonEncode({
          'schemaVersion': 99,
          'exportedAt': DateTime.utc(2026, 5, 7).toIso8601String(),
          'entries': [],
        }),
      );

      final repository = ReflectionEntryRepository(
        documentsDirectoryProvider: () async => tempDir,
      );

      expect(
        repository.load,
        throwsA(isA<UnsupportedReflectionSchemaException>()),
      );
    });

    test('text is preserved exactly', () {
      const text = '  神的平安，今日仍然同在。\n\n「不要害怕。」\n\t阿們。  ';
      final entry = ReflectionEntry(
        id: 'entry-exact-text',
        text: text,
        source: 'Devotion',
        tags: const ['經文', '平安'],
        createdAt: DateTime.utc(2026, 5, 7, 12),
        updatedAt: DateTime.utc(2026, 5, 7, 12, 1),
        isFavorite: false,
      );

      final restored = ReflectionEntry.fromJson(entry.toJson());

      expect(restored.text, text);
      expect(restored.text.codeUnits, text.codeUnits);
    });
  });
}
