class Drop4UpPreferences {
  const Drop4UpPreferences({required this.largeText});

  static const defaults = Drop4UpPreferences(largeText: false);

  final bool largeText;

  Drop4UpPreferences copyWith({bool? largeText}) {
    return Drop4UpPreferences(largeText: largeText ?? this.largeText);
  }

  Map<String, Object?> toJson() {
    return {'largeText': largeText};
  }

  factory Drop4UpPreferences.fromJson(Map<String, Object?> json) {
    final largeText = json['largeText'];
    if (largeText is! bool) {
      throw const FormatException(
        'Drop4UpPreferences.largeText must be a bool.',
      );
    }
    return Drop4UpPreferences(largeText: largeText);
  }
}
