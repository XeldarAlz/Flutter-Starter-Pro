import 'package:flutter_starter_pro/config/env/app_environment.dart';

/// Development environment configuration.
///
/// Used for local development with debugging enabled and
/// relaxed timeouts. Crash reporting and analytics are disabled.
class DevEnvironment implements AppEnvironment {
  const DevEnvironment();

  @override
  String get name => 'development';

  @override
  String get baseUrl => 'https://dev-api.example.com/v1';

  @override
  bool get enableLogging => true;

  @override
  bool get enableCrashReporting => false;

  @override
  bool get enableAnalytics => false;

  @override
  String get sentryDsn => '';

  @override
  Duration get connectionTimeout => const Duration(seconds: 60);

  @override
  Duration get receiveTimeout => const Duration(seconds: 60);

  // Feature flags
  @override
  bool get enableBiometricAuth => true;

  @override
  bool get enableSocialAuth => true;

  @override
  bool get enableOfflineMode => true;

  @override
  bool get showDebugBanner => true;

  @override
  bool get isProduction => false;

  @override
  bool get isDevelopment => true;

  @override
  bool get isStaging => false;
}
