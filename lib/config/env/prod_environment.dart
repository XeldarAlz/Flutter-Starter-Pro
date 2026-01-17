import 'package:flutter_starter_pro/config/env/app_environment.dart';

/// Production environment configuration.
///
/// Used for live production builds with optimized settings,
/// crash reporting, and analytics enabled. Logging is disabled
/// for security and performance.
class ProdEnvironment implements AppEnvironment {
  const ProdEnvironment();

  @override
  String get name => 'production';

  @override
  String get baseUrl => 'https://api.example.com/v1';

  @override
  bool get enableLogging => false;

  @override
  bool get enableCrashReporting => true;

  @override
  bool get enableAnalytics => true;

  @override
  String get sentryDsn => const String.fromEnvironment(
        'SENTRY_DSN',
        defaultValue: '',
      );

  @override
  Duration get connectionTimeout => const Duration(seconds: 30);

  @override
  Duration get receiveTimeout => const Duration(seconds: 30);

  // Feature flags
  @override
  bool get enableBiometricAuth => true;

  @override
  bool get enableSocialAuth => true;

  @override
  bool get enableOfflineMode => true;

  @override
  bool get showDebugBanner => false;

  @override
  bool get isProduction => true;

  @override
  bool get isDevelopment => false;

  @override
  bool get isStaging => false;
}
