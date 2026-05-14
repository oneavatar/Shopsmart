import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration configuration = PurchasesConfiguration(
      "test_cltACqfjJxpJWgqQnPxbGbSckuN",
    );
    await Purchases.configure(configuration);
  }

  static Future<bool> purchasePremium() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      final package = offerings.current?.availablePackages.first;
      if (package != null) {
        CustomerInfo info = await Purchases.purchasePackage(package);
        return info.entitlements.active.containsKey("premium");
      }
      return false;
    } catch (e) {
      print("Purchase failed: $e");
    }
    return false;
  }
}
