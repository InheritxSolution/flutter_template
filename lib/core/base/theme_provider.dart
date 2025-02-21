import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  ThemeProvider() {
    _initTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void _initTheme() {
    _themeMode = _storageService.themeMode;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _storageService.setThemeMode(mode);
      notifyListeners();
    }
  }

  // Use your AppTheme configurations
  ThemeData get lightTheme => AppTheme.lightTheme;

  ThemeData get darkTheme => AppTheme.darkTheme;
}
