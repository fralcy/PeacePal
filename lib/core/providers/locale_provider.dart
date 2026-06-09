import 'package:flutter/material.dart';
import '../utils/locale_storage.dart';

/// Provider để quản lý locale state
class LocaleProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  LocaleProvider() {
    _loadLocale();
  }

  Locale get currentLocale => _currentLocale;

  /// Load locale từ LocaleStorage
  void _loadLocale() {
    final savedLocale = LocaleStorage.getLocale();
    _currentLocale = savedLocale;
  }

  /// Reload locale từ DataManager (sau khi sync)
  void refresh() {
    _loadLocale();
    notifyListeners();
  }

  /// Đổi locale và lưu vào storage
  Future<void> setLocale(String languageCode) async {
    if (languageCode == _currentLocale.languageCode) return;

    final newLocale = Locale(languageCode);
    _currentLocale = newLocale;
    notifyListeners();

    await LocaleStorage.saveLocale(newLocale);
  }
}