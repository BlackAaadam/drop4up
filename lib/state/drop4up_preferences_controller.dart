import 'package:flutter/foundation.dart';

import '../data/drop4up_preferences.dart';
import '../data/drop4up_preferences_repository.dart';

class Drop4UpPreferencesController extends ChangeNotifier {
  Drop4UpPreferencesController({
    required Drop4UpPreferencesRepository repository,
  }) : _repository = repository;

  final Drop4UpPreferencesRepository _repository;

  Drop4UpPreferences _preferences = Drop4UpPreferences.defaults;
  bool _isLoaded = false;
  bool _isSaving = false;
  Object? _error;

  Drop4UpPreferences get preferences => _preferences;
  bool get isLoaded => _isLoaded;
  bool get isSaving => _isSaving;
  Object? get error => _error;

  Future<void> load() async {
    try {
      _preferences = await _repository.load();
      _isLoaded = true;
      _error = null;
    } catch (error) {
      _isLoaded = true;
      _error = error;
    }
    notifyListeners();
  }

  Future<void> updateLargeText(bool largeText) async {
    if (_preferences.largeText == largeText) {
      return;
    }
    final previous = _preferences;
    final next = _preferences.copyWith(largeText: largeText);
    _preferences = next;
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.save(next);
      _isSaving = false;
      notifyListeners();
    } catch (error) {
      _preferences = previous;
      _isSaving = false;
      _error = error;
      notifyListeners();
      rethrow;
    }
  }
}
