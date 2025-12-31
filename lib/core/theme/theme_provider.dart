import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_pro/core/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Theme mode notifier for managing app theme
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    // Try to get saved theme preference
    final localStorage = ref.watch(localStorageProvider);
    final savedTheme = localStorage?.themeMode;

    return _parseThemeMode(savedTheme);
  }

  ThemeMode _parseThemeMode(String? mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Set the theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final localStorage = ref.read(localStorageProvider);
    await localStorage?.setThemeMode(_themeModeToString(mode));
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Check if current theme is dark
  bool get isDarkMode => state == ThemeMode.dark;

  /// Check if current theme is light
  bool get isLightMode => state == ThemeMode.light;

  /// Check if using system theme
  bool get isSystemMode => state == ThemeMode.system;
}

/// Provider for LocalStorage instance
/// This should be overridden in main.dart with the actual instance
@riverpod
LocalStorage? localStorage(Ref ref) {
  return null;
}

