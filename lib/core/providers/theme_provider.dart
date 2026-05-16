import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../utils/data_manager.dart';

/// Provider để quản lý theme state
class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme;

  ThemeProvider() : _currentTheme = AppThemes.pastelBlueBreeze {
    _loadTheme();
  }

  AppTheme get currentTheme => _currentTheme;

  /// Load theme từ DataManager
  void _loadTheme() {
    final themeId = DataManager().userSettings.currentTheme;
    _currentTheme = AppThemes.getById(themeId);
  }

  /// Reload theme từ DataManager (sau khi sync)
  void refresh() {
    _loadTheme();
    notifyListeners();
  }

  /// Đổi theme và lưu vào DataManager
  Future<void> setTheme(String themeId) async {
    final newTheme = AppThemes.getById(themeId);
    if (newTheme.id == _currentTheme.id) return;

    _currentTheme = newTheme;
    notifyListeners();

    final settings = DataManager().userSettings;
    await DataManager().saveUserSettings(
      settings.copyWith(currentTheme: themeId),
    );
  }
}