import 'package:drop4up/data/reflection_entry.dart';
import 'package:drop4up/data/reflection_entry_document.dart';
import 'package:drop4up/data/reflection_entry_repository.dart';

class TestReflectionEntryRepository extends ReflectionEntryRepository {
  TestReflectionEntryRepository()
    : super(documentsDirectoryProvider: _unusedDirectoryProvider);

  ReflectionEntryDocument _document = ReflectionEntryDocument.empty(
    exportedAt: DateTime.utc(2026),
  );

  @override
  Future<ReflectionEntryDocument> load() async {
    return _document;
  }

  @override
  Future<void> saveEntries(
    List<ReflectionEntry> entries, {
    DateTime? exportedAt,
  }) async {
    _document = ReflectionEntryDocument(
      schemaVersion: ReflectionEntryDocument.currentSchemaVersion,
      exportedAt: exportedAt ?? DateTime.utc(2026, 5, 7, 12),
      entries: List<ReflectionEntry>.of(entries),
    );
  }
}

Future<Never> _unusedDirectoryProvider() async {
  throw StateError('TestReflectionEntryRepository does not use file IO.');
}
