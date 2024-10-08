import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('vi');
  Locale _selectedLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;
  Locale get selectedLocale => _selectedLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language_code');
    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  void selectLocale(Locale locale) {
    _selectedLocale = locale;
    notifyListeners();
  }

  Future<void> applySelectedLocale() async {
    if (_currentLocale != _selectedLocale) {
      _currentLocale = _selectedLocale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', _currentLocale.languageCode);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    if (newLocale != _currentLocale) {
      _currentLocale = newLocale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', newLocale.languageCode);
      notifyListeners();
    }
  }

  void setLocale(Locale newLocale) {
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      notifyListeners();
    }
  }
}