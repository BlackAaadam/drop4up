import 'reflection_entry.dart';

class ReflectionEntryDocument {
  const ReflectionEntryDocument({
    required this.schemaVersion,
    required this.exportedAt,
    required this.entries,
  });

  static const currentSchemaVersion = 1;

  final int schemaVersion;
  final DateTime exportedAt;
  final List<ReflectionEntry> entries;

  factory ReflectionEntryDocument.empty({DateTime? exportedAt}) {
    return ReflectionEntryDocument(
      schemaVersion: currentSchemaVersion,
      exportedAt: exportedAt ?? DateTime.now().toUtc(),
      entries: const [],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'exportedAt': exportedAt.toIso8601String(),
      'entries': [for (final entry in entries) entry.toJson()],
    };
  }

  factory ReflectionEntryDocument.fromJson(Map<String, Object?> json) {
    final schemaVersion = json['schemaVersion'];
    if (schemaVersion is! int) {
      throw const FormatException('schemaVersion must be an integer.');
    }
    if (schemaVersion != currentSchemaVersion) {
      throw UnsupportedReflectionSchemaException(schemaVersion);
    }

    final exportedAt = json['exportedAt'];
    if (exportedAt is! String) {
      throw const FormatException('exportedAt must be an ISO-8601 string.');
    }

    final entries = json['entries'];
    if (entries is! List) {
      throw const FormatException('entries must be a list.');
    }

    try {
      return ReflectionEntryDocument(
        schemaVersion: schemaVersion,
        exportedAt: DateTime.parse(exportedAt),
        entries: [
          for (final entry in entries)
            if (entry is Map)
              ReflectionEntry.fromJson(entry.cast<String, Object?>())
            else
              throw const FormatException('entries must contain objects only.'),
        ],
      );
    } on UnsupportedReflectionSchemaException {
      rethrow;
    } on FormatException {
      rethrow;
    } catch (error) {
      throw FormatException('Reflection entry document is malformed: $error');
    }
  }
}

class UnsupportedReflectionSchemaException implements Exception {
  const UnsupportedReflectionSchemaException(this.schemaVersion);

  final int schemaVersion;

  @override
  String toString() {
    return 'UnsupportedReflectionSchemaException: schemaVersion '
        '$schemaVersion is not supported.';
  }
}
