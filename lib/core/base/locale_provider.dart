import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class LocaleProvider extends ChangeNotifier {
  final _storageService = StorageService();
  late Locale _locale;

  LocaleProvider() {
    // Initialize with stored language
    final savedLanguage = _storageService.language;
    _locale = Locale(savedLanguage);
  }

  Locale get locale => _locale;

  Future<void> setLocale(String languageCode) async {
    if (_locale.languageCode != languageCode) {
      await _storageService.setLanguage(languageCode);
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  // Helper method to check if a locale is supported
  bool isSupported(String languageCode) {
    return ['en', 'es']
        .contains(languageCode); // Add your supported languages here
  }
}
