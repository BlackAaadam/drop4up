import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'reflection_entry.dart';
import 'reflection_entry_document.dart';

typedef DirectoryProvider = Future<Directory> Function();

class ReflectionEntryRepository {
  ReflectionEntryRepository({
    DirectoryProvider? documentsDirectoryProvider,
    this.fileName = 'reflection_entries.json',
  }) : _documentsDirectoryProvider =
           documentsDirectoryProvider ?? getApplicationDocumentsDirectory;

  final DirectoryProvider _documentsDirectoryProvider;
  final String fileName;

  Future<ReflectionEntryDocument> load() async {
    final file = await _storageFile();
    if (!await file.exists()) {
      return ReflectionEntryDocument.empty();
    }

    final rawJson = await file.readAsString();
    final Object? decoded;
    try {
      decoded = jsonDecode(rawJson);
    } on FormatException catch (error) {
      throw MalformedReflectionStorageException(
        'Reflection entries JSON is malformed.',
        error,
      );
    }

    if (decoded is! Map) {
      throw const MalformedReflectionStorageException(
        'Reflection entries JSON root must be an object.',
      );
    }

    try {
      return ReflectionEntryDocument.fromJson(decoded.cast<String, Object?>());
    } on UnsupportedReflectionSchemaException {
      rethrow;
    } on FormatException catch (error) {
      throw MalformedReflectionStorageException(
        'Reflection entries JSON does not match the expected shape.',
        error,
      );
    }
  }

  Future<void> saveEntries(
    List<ReflectionEntry> entries, {
    DateTime? exportedAt,
  }) {
    return _writeDocument(
      ReflectionEntryDocument(
        schemaVersion: ReflectionEntryDocument.currentSchemaVersion,
        exportedAt: exportedAt ?? DateTime.now().toUtc(),
        entries: entries,
      ),
    );
  }

  Future<void> _writeDocument(ReflectionEntryDocument document) async {
    final file = await _storageFile();
    await file.parent.create(recursive: true);
    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(
      '${encoder.convert(document.toJson())}\n',
      flush: true,
    );
  }

  Future<File> _storageFile() async {
    final directory = await _documentsDirectoryProvider();
    return File('${directory.path}${Platform.pathSeparator}$fileName');
  }
}

class MalformedReflectionStorageException implements Exception {
  const MalformedReflectionStorageException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() {
    if (cause == null) {
      return 'MalformedReflectionStorageException: $message';
    }
    return 'MalformedReflectionStorageException: $message ($cause)';
  }
}
