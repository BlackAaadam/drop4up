import 'package:flutter/foundation.dart';

import '../data/reflection_entry.dart';
import '../data/reflection_entry_document.dart';
import '../data/reflection_entry_repository.dart';

typedef ReflectionClock = DateTime Function();
typedef ReflectionIdGenerator = String Function();

class ReflectionEntriesController extends ChangeNotifier {
  ReflectionEntriesController({
    required ReflectionEntryRepository repository,
    ReflectionClock? clock,
    ReflectionIdGenerator? idGenerator,
  }) : _repository = repository,
       _clock = clock ?? (() => DateTime.now().toUtc()),
       _idGenerator =
           idGenerator ??
           (() => 'reflection-${DateTime.now().microsecondsSinceEpoch}');

  final ReflectionEntryRepository _repository;
  final ReflectionClock _clock;
  final ReflectionIdGenerator _idGenerator;

  List<ReflectionEntry> _entries = const [];
  bool _isLoaded = false;
  bool _isSaving = false;
  Object? _error;

  List<ReflectionEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _isLoaded;
  bool get isSaving => _isSaving;
  Object? get error => _error;

  ReflectionEntryDocument exportDocument() {
    return ReflectionEntryDocument(
      schemaVersion: ReflectionEntryDocument.currentSchemaVersion,
      exportedAt: _clock().toUtc(),
      entries: List.unmodifiable(_entries),
    );
  }

  Future<void> load() async {
    try {
      final document = await _repository.load();
      _entries = _sortNewestFirst(document.entries);
      _isLoaded = true;
      _error = null;
    } catch (error) {
      _isLoaded = true;
      _error = error;
    }
    notifyListeners();
  }

  Future<ReflectionEntry> addEntry({
    required String text,
    required String source,
    List<String> tags = const [],
    DateTime? createdAt,
  }) async {
    final now = _clock().toUtc();
    final entry = ReflectionEntry(
      id: _idGenerator(),
      text: text,
      source: source,
      tags: List.unmodifiable(tags),
      createdAt: createdAt == null ? now : _dateOnlyUtc(createdAt),
      updatedAt: now,
      isFavorite: false,
    );
    final previousEntries = _entries;

    _entries = [entry, ..._entries];
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.saveEntries(_entries);
      _isSaving = false;
      notifyListeners();
      return entry;
    } catch (error) {
      _entries = previousEntries;
      _isSaving = false;
      _error = error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateEntryText({
    required String id,
    required String text,
  }) async {
    final now = _clock().toUtc();
    await _replaceEntry(
      id,
      (entry) => entry.copyWith(text: text, updatedAt: now),
    );
  }

  Future<void> updateEntry({
    required String id,
    required String text,
    required String source,
    required List<String> tags,
    DateTime? createdAt,
  }) async {
    final now = _clock().toUtc();
    await _replaceEntry(
      id,
      (entry) => entry.copyWith(
        text: text,
        source: source,
        tags: List.unmodifiable(tags),
        createdAt: createdAt == null ? null : _dateOnlyUtc(createdAt),
        updatedAt: now,
      ),
    );
  }

  Future<void> toggleFavorite(String id) async {
    await _replaceEntry(
      id,
      (entry) => entry.copyWith(isFavorite: !entry.isFavorite),
    );
  }

  Future<void> deleteEntry(String id) async {
    final previousEntries = _entries;
    final nextEntries = _entries.where((entry) => entry.id != id).toList();
    if (nextEntries.length == _entries.length) {
      return;
    }
    await _saveWithRollback(previousEntries, nextEntries);
  }

  Future<void> restoreDocument(ReflectionEntryDocument document) async {
    final previousEntries = _entries;
    await _saveWithRollback(previousEntries, document.entries);
  }

  Future<void> _replaceEntry(
    String id,
    ReflectionEntry Function(ReflectionEntry entry) update,
  ) async {
    final previousEntries = _entries;
    var found = false;
    final nextEntries = <ReflectionEntry>[];
    for (final entry in _entries) {
      if (entry.id == id) {
        nextEntries.add(update(entry));
        found = true;
      } else {
        nextEntries.add(entry);
      }
    }

    if (!found) {
      return;
    }
    await _saveWithRollback(previousEntries, nextEntries);
  }

  Future<void> _saveWithRollback(
    List<ReflectionEntry> previousEntries,
    List<ReflectionEntry> nextEntries,
  ) async {
    _entries = _sortNewestFirst(nextEntries);
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.saveEntries(_entries);
      _isSaving = false;
      notifyListeners();
    } catch (error) {
      _entries = previousEntries;
      _isSaving = false;
      _error = error;
      notifyListeners();
      rethrow;
    }
  }

  static List<ReflectionEntry> _sortNewestFirst(List<ReflectionEntry> entries) {
    final sorted = List<ReflectionEntry>.of(entries);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  static DateTime _dateOnlyUtc(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }
}
