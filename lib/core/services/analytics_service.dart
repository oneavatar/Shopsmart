import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: _analytics,
  );

  static Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  static Future<void> logAdClick(String adUnitId) async {
    await _analytics.logEvent(
      name: 'ad_click',
      parameters: {'ad_unit_id': adUnitId},
    );
  }

  static Future<void> logAddToCart(
    String productId,
    String productName,
    double price,
  ) async {
    await _analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName,
          price: price,
        ),
      ],
    );
  }

  static Future<void> logPurchasePremium() async {
    await _analytics.logEvent(name: 'purchase_premium');
  }

  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  static Future<void> setUserProperties(String userId) async {
    await _analytics.setUserId(id: userId);
  }
}
