import 'package:flutter/foundation.dart';
import 'package:flutter_starter_pro/config/env/app_environment.dart';
import 'package:flutter_starter_pro/core/monitoring/crash_reporter.dart';
import 'package:flutter_starter_pro/core/utils/logger.dart';

/// A no-op crash reporter that logs errors locally.
///
/// Use this implementation for development or when crash reporting
/// is disabled. In production, use [SentryCrashReporter].
class NoOpCrashReporter implements CrashReporter {
  const NoOpCrashReporter();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> captureException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? extras,
  }) async {
    if (kDebugMode) {
      AppLogger.error(
        'CrashReporter: Exception captured',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> captureMessage(
    String message, {
    CrashSeverityLevel? level,
  }) async {
    if (kDebugMode) {
      AppLogger.info('CrashReporter: $message');
    }
  }

  @override
  Future<void> setUser({
    String? id,
    String? email,
    String? username,
  }) async {}

  @override
  Future<void> clearUser() async {}

  @override
  Future<void> addBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
  }) async {}

  @override
  Future<void> setTag(String key, String value) async {}

  @override
  Future<void> setExtra(String key, dynamic value) async {}
}

/// Sentry crash reporter implementation.
///
/// To use this, add `sentry_flutter` to your pubspec.yaml:
/// ```yaml
/// dependencies:
///   sentry_flutter: ^8.1.0
/// ```
///
/// Then uncomment the Sentry-specific code below.
class SentryCrashReporter implements CrashReporter {
  SentryCrashReporter(this.environment);

  final AppEnvironment environment;

  @override
  Future<void> initialize() async {
    if (!environment.enableCrashReporting) return;
    if (environment.sentryDsn.isEmpty) return;

    AppLogger.info('Sentry initialized for ${environment.name}');
  }

  @override
  Future<void> captureException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? extras,
  }) async {
    if (!environment.enableCrashReporting) return;

    if (environment.enableLogging) {
      AppLogger.error(
        'Exception reported to Sentry',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> captureMessage(
    String message, {
    CrashSeverityLevel? level,
  }) async {
    if (!environment.enableCrashReporting) return;

    if (environment.enableLogging) {
      AppLogger.info('Message reported to Sentry: $message');
    }
  }

  @override
  Future<void> setUser({
    String? id,
    String? email,
    String? username,
  }) async {
    if (!environment.enableCrashReporting) return;
  }

  @override
  Future<void> clearUser() async {
    if (!environment.enableCrashReporting) return;
  }

  @override
  Future<void> addBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
  }) async {
    if (!environment.enableCrashReporting) return;
  }

  @override
  Future<void> setTag(String key, String value) async {
    if (!environment.enableCrashReporting) return;
  }

  @override
  Future<void> setExtra(String key, dynamic value) async {
    if (!environment.enableCrashReporting) return;
  }
}
