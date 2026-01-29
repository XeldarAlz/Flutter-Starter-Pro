import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Application logger utility
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
    level: kDebugMode ? Level.debug : Level.info,
  );

  /// Log a debug message
  static void debug(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log an info message
  static void info(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message
  static void warning(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log an error message
  static void error(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a fatal error message
  static void fatal(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log to developer console (for DevTools)
  static void devLog(
    String message, {
    String name = 'APP',
    int level = 0,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a time-stamped message for performance tracking
  static void performance(String operation, Duration duration) {
    info('⏱️ $operation completed in ${duration.inMilliseconds}ms');
  }

  /// Log network request
  static void network(String method, String url, {int? statusCode}) {
    final status = statusCode != null ? ' [$statusCode]' : '';
    debug('🌐 $method $url$status');
  }

  /// Log navigation event
  static void navigation(String from, String to) {
    debug('🧭 Navigation: $from → $to');
  }

  /// Log user action
  static void userAction(String action, {Map<String, dynamic>? params}) {
    final paramsStr = params != null ? ' $params' : '';
    debug('👤 User Action: $action$paramsStr');
  }
}
