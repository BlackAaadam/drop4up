import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'reflection_entry_document.dart';

typedef ProfileBackupDirectoryProvider = Future<Directory> Function();
typedef ProfileBackupShareLauncher =
    Future<ShareResult> Function(ShareParams params);
typedef ProfileBackupFilePicker = Future<file_selector.XFile?> Function();

class ProfileBackupFileService {
  ProfileBackupFileService({
    ProfileBackupDirectoryProvider? directoryProvider,
    ProfileBackupShareLauncher? shareLauncher,
    ProfileBackupFilePicker? filePicker,
  }) : _directoryProvider =
           directoryProvider ?? getApplicationDocumentsDirectory,
       _shareLauncher = shareLauncher ?? SharePlus.instance.share,
       _filePicker = filePicker ?? _defaultRestoreFilePicker;

  final ProfileBackupDirectoryProvider _directoryProvider;
  final ProfileBackupShareLauncher _shareLauncher;
  final ProfileBackupFilePicker _filePicker;

  Future<ProfileBackupFile> writeBackup(
    ReflectionEntryDocument document,
  ) async {
    final directory = await _directoryProvider();
    final backupDirectory = Directory(
      '${directory.path}${Platform.pathSeparator}drop4up_backups',
    );
    await backupDirectory.create(recursive: true);

    final fileName = profileBackupFileName(document.exportedAt);
    final file = File(
      '${backupDirectory.path}${Platform.pathSeparator}$fileName',
    );
    await file.writeAsBytes(
      utf8.encode(profileBackupDocumentText(document)),
      flush: true,
    );

    return ProfileBackupFile(
      path: file.path,
      fileName: fileName,
      entryCount: document.entries.length,
      exportedAt: document.exportedAt,
    );
  }

  Future<ShareResult> shareBackup(
    ProfileBackupFile backupFile, {
    Rect? sharePositionOrigin,
  }) {
    return _shareLauncher(
      ShareParams(
        title: backupFile.fileName,
        files: [XFile(backupFile.path, mimeType: 'application/octet-stream')],
        fileNameOverrides: [backupFile.fileName],
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  Future<ProfileBackupFile> writeAndShareBackup(
    ReflectionEntryDocument document, {
    Rect? sharePositionOrigin,
  }) async {
    final backupFile = await writeBackup(document);
    await shareBackup(backupFile, sharePositionOrigin: sharePositionOrigin);
    return backupFile;
  }

  Future<ReflectionEntryDocument?> pickRestoreDocument() async {
    final file = await _filePicker();
    if (file == null) {
      return null;
    }
    final bytes = await file.readAsBytes();
    return parseProfileBackupDocumentText(utf8.decode(bytes));
  }

  static Future<file_selector.XFile?> _defaultRestoreFilePicker() {
    return file_selector.openFile(
      // Keep the picker unfiltered so cloud providers such as Google Drive do
      // not hide .drop4up files because of their provider-specific MIME type.
      acceptedTypeGroups: const [],
      confirmButtonText: '選擇',
    );
  }
}

class ProfileBackupFile {
  const ProfileBackupFile({
    required this.path,
    required this.fileName,
    required this.entryCount,
    required this.exportedAt,
  });

  final String path;
  final String fileName;
  final int entryCount;
  final DateTime exportedAt;
}

String profileBackupDocumentText(ReflectionEntryDocument document) {
  return const JsonEncoder.withIndent('  ').convert(document.toJson());
}

ReflectionEntryDocument parseProfileBackupDocumentText(String text) {
  final decoded = jsonDecode(text);
  if (decoded is! Map) {
    throw const FormatException('Drop4Up backup must be an object.');
  }
  return ReflectionEntryDocument.fromJson(decoded.cast<String, Object?>());
}

String profileBackupFileName(DateTime exportedAt) {
  final local = exportedAt.toLocal();
  return 'Drop4Up_Backup_'
      '${_twoDigits(local.year, 4)}-'
      '${_twoDigits(local.month)}-'
      '${_twoDigits(local.day)}_'
      '${_twoDigits(local.hour)}'
      '${_twoDigits(local.minute)}.drop4up';
}

String _twoDigits(int value, [int width = 2]) {
  return value.toString().padLeft(width, '0');
}
