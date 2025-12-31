/// Storage keys for local persistence
abstract class StorageKeys {
  // Secure storage keys (for sensitive data)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';

  // Shared preferences keys (for non-sensitive data)
  static const String isFirstLaunch = 'is_first_launch';
  static const String isOnboardingCompleted = 'is_onboarding_completed';
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';
  static const String lastSyncTime = 'last_sync_time';
  static const String rememberMe = 'remember_me';
  static const String userEmail = 'user_email';

  // Hive box names
  static const String userBox = 'user_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
}

