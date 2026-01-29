import 'package:flutter_starter_pro/config/env/app_environment.dart';
import 'package:flutter_starter_pro/core/analytics/analytics_service.dart';
import 'package:flutter_starter_pro/core/utils/logger.dart';

/// A no-op analytics service that logs events locally.
///
/// Use this implementation for development or when analytics
/// is disabled. In production, use [FirebaseAnalyticsService].
class NoOpAnalyticsService implements AnalyticsService {
  const NoOpAnalyticsService();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> logEvent(
    String name, {
    Map<String, dynamic>? parameters,
  }) async {
    AppLogger.debug('Analytics Event: $name, params: $parameters');
  }

  @override
  Future<void> logScreenView(
    String screenName, {
    String? screenClass,
  }) async {
    AppLogger.debug('Analytics Screen View: $screenName');
  }

  @override
  Future<void> setUserId(String? userId) async {
    AppLogger.debug('Analytics User ID: $userId');
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    AppLogger.debug('Analytics User Property: $name = $value');
  }

  @override
  Future<void> logLogin({String? loginMethod}) async {
    AppLogger.debug('Analytics Login: $loginMethod');
  }

  @override
  Future<void> logSignUp({String? signUpMethod}) async {
    AppLogger.debug('Analytics Sign Up: $signUpMethod');
  }

  @override
  Future<void> logAppOpen() async {
    AppLogger.debug('Analytics App Open');
  }

  @override
  Future<void> logSearch(String searchTerm) async {
    AppLogger.debug('Analytics Search: $searchTerm');
  }

  @override
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    AppLogger.debug('Analytics Share: $contentType, $itemId');
  }

  @override
  Future<void> logPurchase({
    required String currency,
    required double value,
    String? transactionId,
    List<AnalyticsItem>? items,
  }) async {
    AppLogger.debug('Analytics Purchase: $currency $value');
  }

  @override
  Future<void> logTutorialBegin() async {
    AppLogger.debug('Analytics Tutorial Begin');
  }

  @override
  Future<void> logTutorialComplete() async {
    AppLogger.debug('Analytics Tutorial Complete');
  }

  @override
  Future<void> setAnalyticsCollectionEnabled({required bool enabled}) async {
    AppLogger.debug('Analytics Collection Enabled: $enabled');
  }

  @override
  Future<void> resetAnalyticsData() async {
    AppLogger.debug('Analytics Data Reset');
  }
}

/// Firebase Analytics implementation.
///
/// To use this, add `firebase_analytics` to your pubspec.yaml:
/// ```yaml
/// dependencies:
///   firebase_core: ^3.1.0
///   firebase_analytics: ^11.0.1
/// ```
///
/// Then uncomment the Firebase-specific code below.
class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService(this.environment);

  final AppEnvironment environment;

  @override
  Future<void> initialize() async {
    if (!environment.enableAnalytics) return;

    AppLogger.info('Firebase Analytics initialized');
  }

  @override
  Future<void> logEvent(
    String name, {
    Map<String, dynamic>? parameters,
  }) async {
    if (!environment.enableAnalytics) return;

    if (environment.enableLogging) {
      AppLogger.debug('Analytics Event: $name');
    }
  }

  @override
  Future<void> logScreenView(
    String screenName, {
    String? screenClass,
  }) async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> setUserId(String? userId) async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> logLogin({String? loginMethod}) async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> logSignUp({String? signUpMethod}) async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> logAppOpen() async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> logSearch(String searchTerm) async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  }) async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> logPurchase({
    required String currency,
    required double value,
    String? transactionId,
    List<AnalyticsItem>? items,
  }) async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> logTutorialBegin() async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> logTutorialComplete() async {
    if (!environment.enableAnalytics) return;
  }

  @override
  Future<void> setAnalyticsCollectionEnabled({required bool enabled}) async {}

  @override
  Future<void> resetAnalyticsData() async {}
}
