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
  Future<void> initialize() async {
    // No-op
  }

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
  }) async {
    // No-op
  }

  @override
  Future<void> clearUser() async {
    // No-op
  }

  @override
  Future<void> addBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
  }) async {
    // No-op
  }

  @override
  Future<void> setTag(String key, String value) async {
    // No-op
  }

  @override
  Future<void> setExtra(String key, dynamic value) async {
    // No-op
  }
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

    // TODO: Uncomment when sentry_flutter is added to dependencies
    // await SentryFlutter.init(
    //   (options) {
    //     options.dsn = environment.sentryDsn;
    //     options.environment = environment.name;
    //     options.tracesSampleRate = environment.isProduction ? 0.2 : 1.0;
    //     options.attachScreenshot = true;
    //     options.attachViewHierarchy = true;
    //     options.enableAutoPerformanceTracing = true;
    //   },
    // );

    AppLogger.info('Sentry initialized for ${environment.name}');
  }

  @override
  Future<void> captureException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? extras,
  }) async {
    if (!environment.enableCrashReporting) return;

    // TODO: Uncomment when sentry_flutter is added
    // await Sentry.captureException(
    //   exception,
    //   stackTrace: stackTrace,
    //   withScope: (scope) {
    //     if (extras != null) {
    //       extras.forEach((key, value) {
    //         scope.setExtra(key, value);
    //       });
    //     }
    //   },
    // );

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

    // TODO: Uncomment when sentry_flutter is added
    // await Sentry.captureMessage(
    //   message,
    //   level: _mapSeverityLevel(level),
    // );

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

    // TODO: Uncomment when sentry_flutter is added
    // Sentry.configureScope((scope) {
    //   scope.setUser(SentryUser(
    //     id: id,
    //     email: email,
    //     username: username,
    //   ));
    // });
  }

  @override
  Future<void> clearUser() async {
    if (!environment.enableCrashReporting) return;

    // TODO: Uncomment when sentry_flutter is added
    // Sentry.configureScope((scope) => scope.setUser(null));
  }

  @override
  Future<void> addBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
  }) async {
    if (!environment.enableCrashReporting) return;

    // TODO: Uncomment when sentry_flutter is added
    // await Sentry.addBreadcrumb(Breadcrumb(
    //   message: message,
    //   category: category,
    //   data: data,
    //   timestamp: DateTime.now(),
    // ));
  }

  @override
  Future<void> setTag(String key, String value) async {
    if (!environment.enableCrashReporting) return;

    // TODO: Uncomment when sentry_flutter is added
    // Sentry.configureScope((scope) => scope.setTag(key, value));
  }

  @override
  Future<void> setExtra(String key, dynamic value) async {
    if (!environment.enableCrashReporting) return;

    // TODO: Uncomment when sentry_flutter is added
    // Sentry.configureScope((scope) => scope.setExtra(key, value));
  }

  // TODO: Uncomment when sentry_flutter is added
  // SentryLevel _mapSeverityLevel(CrashSeverityLevel? level) {
  //   switch (level) {
  //     case CrashSeverityLevel.debug:
  //       return SentryLevel.debug;
  //     case CrashSeverityLevel.info:
  //       return SentryLevel.info;
  //     case CrashSeverityLevel.warning:
  //       return SentryLevel.warning;
  //     case CrashSeverityLevel.error:
  //       return SentryLevel.error;
  //     case CrashSeverityLevel.fatal:
  //       return SentryLevel.fatal;
  //     case null:
  //       return SentryLevel.info;
  //   }
  // }
}
