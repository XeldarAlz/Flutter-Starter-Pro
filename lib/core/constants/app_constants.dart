/// Application-wide constants
abstract class AppConstants {
  /// App name
  static const String appName = 'Flutter Starter Pro';

  /// App description
  static const String appDescription =
      'A production-ready Flutter starter with clean architecture';

  /// Default animation duration
  static const Duration animationDuration = Duration(milliseconds: 300);

  /// Default page transition duration
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);

  /// Splash screen delay
  static const Duration splashDelay = Duration(seconds: 2);

  /// Default pagination limit
  static const int defaultPageLimit = 20;

  /// Maximum retry attempts for network requests
  static const int maxRetryAttempts = 3;

  /// Debounce duration for search
  static const Duration searchDebounceDuration = Duration(milliseconds: 500);

  /// Minimum password length
  static const int minPasswordLength = 8;

  /// Maximum password length
  static const int maxPasswordLength = 32;

  /// OTP length
  static const int otpLength = 6;

  /// Session timeout duration
  static const Duration sessionTimeout = Duration(hours: 24);
}

