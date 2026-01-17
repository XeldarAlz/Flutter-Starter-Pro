/// Interface for crash reporting services.
///
/// This abstraction allows switching between different crash reporting
/// providers (Sentry, Firebase Crashlytics, etc.) without changing
/// application code.
///
/// ## Usage
///
/// ```dart
/// final crashReporter = ref.read(crashReporterProvider);
///
/// try {
///   await riskyOperation();
/// } catch (e, stackTrace) {
///   await crashReporter.captureException(e, stackTrace);
/// }
/// ```
abstract class CrashReporter {
  /// Initialize the crash reporting service.
  ///
  /// Should be called during app bootstrap before any other operations.
  Future<void> initialize();

  /// Capture and report an exception.
  ///
  /// [exception] is the error that occurred.
  /// [stackTrace] is the stack trace associated with the error.
  /// [extras] are additional key-value pairs to attach to the report.
  Future<void> captureException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? extras,
  });

  /// Capture and report a message.
  ///
  /// Use this for non-exception events that should be tracked.
  Future<void> captureMessage(
    String message, {
    CrashSeverityLevel? level,
  });

  /// Set the current user for crash reports.
  ///
  /// Pass `null` to clear the user (e.g., on logout).
  Future<void> setUser({
    String? id,
    String? email,
    String? username,
  });

  /// Clear the current user from crash reports.
  Future<void> clearUser();

  /// Add a breadcrumb for debugging context.
  ///
  /// Breadcrumbs are logged events that provide context for crashes.
  Future<void> addBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
  });

  /// Set a custom tag that will be included with all crash reports.
  Future<void> setTag(String key, String value);

  /// Set extra context data that will be included with all crash reports.
  Future<void> setExtra(String key, dynamic value);
}

/// Severity level for crash reports.
enum CrashSeverityLevel {
  /// Debug-level message.
  debug,

  /// Informational message.
  info,

  /// Warning message.
  warning,

  /// Error message.
  error,

  /// Fatal error message.
  fatal,
}
