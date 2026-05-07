class ReflectionEntry {
  const ReflectionEntry({
    required this.id,
    required this.text,
    required this.source,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
  });

  final String id;
  final String text;
  final String source;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;

  ReflectionEntry copyWith({
    String? id,
    String? text,
    String? source,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return ReflectionEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      source: source ?? this.source,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'text': text,
      'source': source,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory ReflectionEntry.fromJson(Map<String, Object?> json) {
    return ReflectionEntry(
      id: _readString(json, 'id'),
      text: _readString(json, 'text'),
      source: _readString(json, 'source'),
      tags: _readStringList(json, 'tags'),
      createdAt: _readDateTime(json, 'createdAt'),
      updatedAt: _readDateTime(json, 'updatedAt'),
      isFavorite: _readBool(json, 'isFavorite'),
    );
  }

  static String _readString(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is String) {
      return value;
    }
    throw FormatException('ReflectionEntry.$key must be a string.');
  }

  static bool _readBool(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
    throw FormatException('ReflectionEntry.$key must be a bool.');
  }

  static DateTime _readDateTime(Map<String, Object?> json, String key) {
    final value = _readString(json, key);
    try {
      return DateTime.parse(value);
    } on FormatException {
      throw FormatException('ReflectionEntry.$key must be an ISO-8601 date.');
    }
  }

  static List<String> _readStringList(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is! List) {
      throw FormatException('ReflectionEntry.$key must be a list.');
    }
    return [
      for (final item in value)
        if (item is String)
          item
        else
          throw FormatException(
            'ReflectionEntry.$key must contain strings only.',
          ),
    ];
  }
}
