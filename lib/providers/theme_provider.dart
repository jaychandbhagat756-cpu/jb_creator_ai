import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';

  AppThemeMode _themeMode = AppThemeMode.system;

  AppThemeMode get themeMode => _themeMode;

  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString(_themeKey);

    switch (savedTheme) {
      case 'light':
        _themeMode = AppThemeMode.light;
        break;

      case 'dark':
        _themeMode = AppThemeMode.dark;
        break;

      default:
        _themeMode = AppThemeMode.system;
    }

    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _themeKey,
      mode.name,
    );

    notifyListeners();
  }

  Future<void> toggleDarkMode(bool enabled) async {
    await setThemeMode(
      enabled
          ? AppThemeMode.dark
          : AppThemeMode.light,
    );
  }
}