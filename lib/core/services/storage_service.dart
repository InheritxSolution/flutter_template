import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../constants/storage_constants.dart';
import '../localization/language_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() => _instance;

  StorageService._internal();

  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter(); // Now this should work with proper import
    _box = await Hive.openBox(StorageConstants.box);
    _logInit();
  }

  /*// User Data Methods
  UserModel? get userData {
    final data = _box.get(StorageKeys.userData);
    if (data != null) {
      return UserModel.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<void> setUserData(UserModel? user) async {
    if (user != null) {
      await _box.put(StorageKeys.userData, jsonEncode(user.toJson()));
    } else {
      await _box.delete(StorageKeys.userData);
    }
    _log('Updated user data');
  }*/

  // Auth Token Methods
  String? get authToken =>
      _box.get(StorageConstants.tokenKey, defaultValue: "");

  Future<void> setAuthToken(String? token) async {
    if (token != null) {
      await _box.put(StorageConstants.tokenKey, token);
    } else {
      await _box.delete(StorageConstants.tokenKey);
    }
    _log('Updated auth token');
  }

  // App Settings Methods
  ThemeMode get themeMode {
    final value = _box.get(StorageConstants.themeMode, defaultValue: 'system');
    return ThemeMode.values.firstWhere(
      (mode) => mode.toString() == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _box.put(StorageConstants.themeMode, mode.toString());
    _log('Updated theme mode: $mode');
  }

  String get language => _box.get(StorageConstants.locale,
      defaultValue: LanguageConstants.defaultLanguage);

  Future<void> setLanguage(String languageCode) async {
    if (LanguageConstants.supportedLanguages.contains(languageCode)) {
      await _box.put(StorageConstants.locale, languageCode);
      _log('Updated language: $languageCode');
    }
  }

  bool get isFirstRun =>
      _box.get(StorageConstants.firstRun, defaultValue: false);

  Future<void> setIsFirstRun(bool value) async {
    await _box.put(StorageConstants.firstRun, value);
    _log('Updated onboarding status: $value');
  }

  // General Methods
  Future<void> clearAllData() async {
    await _box.clear();
    _log('Cleared all storage data');
  }

  Future<void> clearAuthData() async {
    // await _box.delete(StorageConstants.userData);
    await _box.delete(StorageConstants.tokenKey);
    _log('Cleared auth data');
  }

  // Logging
  void _logInit() {
    debugPrint('💾 Storage: Initialized Hive storage');
  }

  void _log(String message) {
    debugPrint('💾 Storage: $message');
  }
}
