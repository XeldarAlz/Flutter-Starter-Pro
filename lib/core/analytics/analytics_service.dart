/// Interface for analytics services.
///
/// This abstraction allows switching between different analytics
/// providers (Firebase Analytics, Mixpanel, Amplitude, etc.) without
/// changing application code.
///
/// ## Usage
///
/// ```dart
/// final analytics = ref.read(analyticsServiceProvider);
///
/// // Log a custom event
/// await analytics.logEvent('button_clicked', parameters: {
///   'button_name': 'submit',
///   'screen': 'checkout',
/// });
///
/// // Log screen view
/// await analytics.logScreenView('HomeScreen');
/// ```
abstract class AnalyticsService {
  /// Initialize the analytics service.
  ///
  /// Should be called during app bootstrap.
  Future<void> initialize();

  /// Log a custom event.
  ///
  /// [name] is the event name.
  /// [parameters] are optional key-value pairs for additional context.
  Future<void> logEvent(
    String name, {
    Map<String, dynamic>? parameters,
  });

  /// Log a screen view.
  ///
  /// [screenName] is the name of the screen being viewed.
  /// [screenClass] is an optional class name for the screen.
  Future<void> logScreenView(
    String screenName, {
    String? screenClass,
  });

  /// Set the user ID for analytics tracking.
  ///
  /// Pass `null` to clear the user ID.
  Future<void> setUserId(String? userId);

  /// Set a user property.
  ///
  /// User properties are persistent and are included with all events.
  Future<void> setUserProperty(String name, String? value);

  /// Log a login event.
  Future<void> logLogin({String? loginMethod});

  /// Log a sign-up event.
  Future<void> logSignUp({String? signUpMethod});

  /// Log an app open event.
  Future<void> logAppOpen();

  /// Log a search event.
  Future<void> logSearch(String searchTerm);

  /// Log a share event.
  Future<void> logShare({
    required String contentType,
    required String itemId,
    String? method,
  });

  /// Log a purchase event.
  Future<void> logPurchase({
    required String currency,
    required double value,
    String? transactionId,
    List<AnalyticsItem>? items,
  });

  /// Log a tutorial begin event.
  Future<void> logTutorialBegin();

  /// Log a tutorial complete event.
  Future<void> logTutorialComplete();

  /// Enable or disable analytics collection.
  Future<void> setAnalyticsCollectionEnabled(bool enabled);

  /// Reset analytics data.
  Future<void> resetAnalyticsData();
}

/// Represents an item for analytics events (e.g., purchases).
class AnalyticsItem {
  const AnalyticsItem({
    this.itemId,
    this.itemName,
    this.itemCategory,
    this.price,
    this.quantity,
  });

  final String? itemId;
  final String? itemName;
  final String? itemCategory;
  final double? price;
  final int? quantity;

  Map<String, dynamic> toMap() {
    return {
      if (itemId != null) 'item_id': itemId,
      if (itemName != null) 'item_name': itemName,
      if (itemCategory != null) 'item_category': itemCategory,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
    };
  }
}
