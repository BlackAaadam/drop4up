import 'dart:convert';
import 'dart:io';

import 'package:drop4up/data/drop4up_preferences.dart';
import 'package:drop4up/data/drop4up_preferences_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('missing preferences file returns defaults', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'drop4up_preferences_missing_test_',
    );
    addTearDown(() => tempDir.delete(recursive: true));
    final repository = Drop4UpPreferencesRepository(
      documentsDirectoryProvider: () async => tempDir,
    );

    final preferences = await repository.load();

    expect(preferences.largeText, isFalse);
  });

  test('preferences JSON round trip preserves values', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'drop4up_preferences_round_trip_test_',
    );
    addTearDown(() => tempDir.delete(recursive: true));
    final repository = Drop4UpPreferencesRepository(
      documentsDirectoryProvider: () async => tempDir,
    );

    await repository.save(const Drop4UpPreferences(largeText: true));
    final restored = await repository.load();
    final file = File(
      '${tempDir.path}${Platform.pathSeparator}drop4up_preferences.json',
    );
    final decoded = jsonDecode(await file.readAsString());

    expect(restored.largeText, isTrue);
    expect(decoded, {'largeText': true});
  });

  test('malformed preferences JSON fails clearly', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'drop4up_preferences_malformed_test_',
    );
    addTearDown(() => tempDir.delete(recursive: true));
    final file = File(
      '${tempDir.path}${Platform.pathSeparator}drop4up_preferences.json',
    );
    await file.writeAsString('{ nope');
    final repository = Drop4UpPreferencesRepository(
      documentsDirectoryProvider: () async => tempDir,
    );

    expect(
      repository.load,
      throwsA(isA<MalformedDrop4UpPreferencesException>()),
    );
  });
}
