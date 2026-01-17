import 'package:flutter_starter_pro/config/env/app_environment.dart';

/// Staging environment configuration.
///
/// Used for testing and QA with production-like settings but
/// pointing to staging servers. Crash reporting is enabled but
/// analytics may be limited.
class StagingEnvironment implements AppEnvironment {
  const StagingEnvironment();

  @override
  String get name => 'staging';

  @override
  String get baseUrl => 'https://staging-api.example.com/v1';

  @override
  bool get enableLogging => true;

  @override
  bool get enableCrashReporting => true;

  @override
  bool get enableAnalytics => false;

  @override
  String get sentryDsn => const String.fromEnvironment(
        'SENTRY_DSN_STAGING',
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
  bool get showDebugBanner => true;

  @override
  bool get isProduction => false;

  @override
  bool get isDevelopment => false;

  @override
  bool get isStaging => true;
}
