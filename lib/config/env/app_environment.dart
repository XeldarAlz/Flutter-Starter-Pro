/// Base class defining the application environment configuration.
///
/// Each environment (dev, staging, prod) implements this interface
/// with appropriate values for API endpoints, feature flags, and
/// service configurations.
///
/// Example usage:
/// ```dart
/// final env = ref.watch(environmentProvider);
/// print(env.baseUrl); // https://api.example.com/v1
/// ```
abstract class AppEnvironment {
  /// Environment name (development, staging, production)
  String get name;

  /// Base URL for API requests
  String get baseUrl;

  /// Whether to enable detailed logging
  bool get enableLogging;

  /// Whether to enable crash reporting (Sentry/Crashlytics)
  bool get enableCrashReporting;

  /// Whether to enable analytics tracking
  bool get enableAnalytics;

  /// Sentry DSN for crash reporting (empty if not using Sentry)
  String get sentryDsn;

  /// Connection timeout for API requests
  Duration get connectionTimeout;

  /// Receive timeout for API requests
  Duration get receiveTimeout;

  // Feature flags

  /// Whether biometric authentication is enabled
  bool get enableBiometricAuth;

  /// Whether social login (Google, Apple) is enabled
  bool get enableSocialAuth;

  /// Whether offline mode and data sync is enabled
  bool get enableOfflineMode;

  /// Whether to show debug banner
  bool get showDebugBanner;

  /// Whether this is a production environment
  bool get isProduction => name == 'production';

  /// Whether this is a development environment
  bool get isDevelopment => name == 'development';

  /// Whether this is a staging environment
  bool get isStaging => name == 'staging';
}
