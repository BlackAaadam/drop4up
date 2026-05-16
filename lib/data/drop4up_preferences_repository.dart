import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'drop4up_preferences.dart';

typedef Drop4UpPreferencesDirectoryProvider = Future<Directory> Function();

class Drop4UpPreferencesRepository {
  Drop4UpPreferencesRepository({
    Drop4UpPreferencesDirectoryProvider? documentsDirectoryProvider,
    this.fileName = 'drop4up_preferences.json',
  }) : _documentsDirectoryProvider =
           documentsDirectoryProvider ?? getApplicationDocumentsDirectory;

  final Drop4UpPreferencesDirectoryProvider _documentsDirectoryProvider;
  final String fileName;

  Future<Drop4UpPreferences> load() async {
    final file = await _storageFile();
    if (!await file.exists()) {
      return Drop4UpPreferences.defaults;
    }

    final rawJson = await file.readAsString();
    final Object? decoded;
    try {
      decoded = jsonDecode(rawJson);
    } on FormatException catch (error) {
      throw MalformedDrop4UpPreferencesException(
        'Drop4Up preferences JSON is malformed.',
        error,
      );
    }

    if (decoded is! Map) {
      throw const MalformedDrop4UpPreferencesException(
        'Drop4Up preferences JSON root must be an object.',
      );
    }

    try {
      return Drop4UpPreferences.fromJson(decoded.cast<String, Object?>());
    } on FormatException catch (error) {
      throw MalformedDrop4UpPreferencesException(
        'Drop4Up preferences JSON does not match the expected shape.',
        error,
      );
    }
  }

  Future<void> save(Drop4UpPreferences preferences) async {
    final file = await _storageFile();
    await file.parent.create(recursive: true);
    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString('${encoder.convert(preferences.toJson())}\n');
  }

  Future<File> _storageFile() async {
    final directory = await _documentsDirectoryProvider();
    return File('${directory.path}${Platform.pathSeparator}$fileName');
  }
}

class MalformedDrop4UpPreferencesException implements Exception {
  const MalformedDrop4UpPreferencesException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() {
    if (cause == null) {
      return 'MalformedDrop4UpPreferencesException: $message';
    }
    return 'MalformedDrop4UpPreferencesException: $message ($cause)';
  }
}
