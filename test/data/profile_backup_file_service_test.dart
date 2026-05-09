import 'dart:convert';
import 'dart:io';

import 'package:drop4up/data/profile_backup_file_service.dart';
import 'package:drop4up/data/reflection_entry.dart';
import 'package:drop4up/data/reflection_entry_document.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  test(
    'writeAndShareBackup creates a restorable file with exact text',
    () async {
      const text = '  神的平安仍在。\n\nDo not rewrite this.  ';
      final tempDir = await Directory.systemTemp.createTemp(
        'drop4up_backup_service_test_',
      );
      addTearDown(() => tempDir.delete(recursive: true));

      ShareParams? sharedParams;
      final service = ProfileBackupFileService(
        directoryProvider: () async => tempDir,
        shareLauncher: (params) async {
          sharedParams = params;
          return const ShareResult('', ShareResultStatus.success);
        },
      );
      final document = ReflectionEntryDocument(
        schemaVersion: ReflectionEntryDocument.currentSchemaVersion,
        exportedAt: DateTime.utc(2026, 5, 9, 12),
        entries: [
          ReflectionEntry(
            id: 'entry-backup',
            text: text,
            source: '閱讀',
            tags: ['感恩'],
            createdAt: DateTime.utc(2026, 5, 9, 8),
            updatedAt: DateTime.utc(2026, 5, 9, 8),
            isFavorite: true,
          ),
        ],
      );

      final backupFile = await service.writeAndShareBackup(document);
      final file = File(backupFile.path);
      final expectedFileName = profileBackupFileName(document.exportedAt);
      final decoded = jsonDecode(await file.readAsString());
      final restored = ReflectionEntryDocument.fromJson(
        (decoded as Map).cast<String, Object?>(),
      );
      final restoredEntry = restored.entries.single;

      expect(backupFile.fileName, expectedFileName);
      expect(file.existsSync(), isTrue);
      expect(restoredEntry.text, text);
      expect(restoredEntry.text.codeUnits, text.codeUnits);
      expect(restoredEntry.source, '閱讀');
      expect(restoredEntry.tags, const ['感恩']);
      expect(restoredEntry.isFavorite, isTrue);
      expect(sharedParams?.title, backupFile.fileName);
      expect(sharedParams?.subject, isNull);
      expect(sharedParams?.text, isNull);
      expect(sharedParams?.files, hasLength(1));
      expect(sharedParams?.fileNameOverrides, [backupFile.fileName]);
    },
  );

  test('pickRestoreDocument reads a selected .drop4up file', () async {
    const text = 'Restored from file exactly.\n  Amen.';
    final tempDir = await Directory.systemTemp.createTemp(
      'drop4up_restore_service_test_',
    );
    addTearDown(() => tempDir.delete(recursive: true));

    final backupFile = File(
      '${tempDir.path}${Platform.pathSeparator}x.drop4up',
    );
    await backupFile.writeAsString(
      profileBackupDocumentText(
        ReflectionEntryDocument(
          schemaVersion: ReflectionEntryDocument.currentSchemaVersion,
          exportedAt: DateTime.utc(2026, 5, 9, 12),
          entries: [
            ReflectionEntry(
              id: 'restored-entry',
              text: text,
              source: '禱告',
              tags: ['信心'],
              createdAt: DateTime.utc(2026, 5, 9, 8),
              updatedAt: DateTime.utc(2026, 5, 9, 8),
              isFavorite: false,
            ),
          ],
        ),
      ),
    );
    final service = ProfileBackupFileService(
      directoryProvider: () async => tempDir,
      filePicker: () async => XFile(backupFile.path),
    );

    final document = await service.pickRestoreDocument();
    final entry = document!.entries.single;

    expect(entry.id, 'restored-entry');
    expect(entry.text, text);
    expect(entry.text.codeUnits, text.codeUnits);
    expect(entry.source, '禱告');
    expect(entry.tags, const ['信心']);
  });

  test(
    'pickRestoreDocument returns null when file selection is cancelled',
    () async {
      final service = ProfileBackupFileService(filePicker: () async => null);

      expect(await service.pickRestoreDocument(), isNull);
    },
  );

  test('parseProfileBackupDocumentText rejects malformed backup content', () {
    expect(
      () => parseProfileBackupDocumentText('{ nope'),
      throwsA(isA<FormatException>()),
    );
  });
}
