import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RevenueCatService {
  static const String premiumKey = "isPremium";

  static Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration = PurchasesConfiguration(
      "test_cltACqfjJxpJWgqQnPxbGbSckuN",
    );

    await Purchases.configure(configuration);
  }

  static Future<String?> purchasePremium() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      
      if (offerings.all.isEmpty) {
        return "No subscription plans available at the moment.";
      }

      Package? package = offerings.current?.availablePackages.firstOrNull;
      
      if (package == null && offerings.all.isNotEmpty) {
        for (var offering in offerings.all.values) {
          if (offering.availablePackages.isNotEmpty) {
            package = offering.availablePackages.first;
            break;
          }
        }
      }

      if (package != null) {
        PurchaseResult result = await Purchases.purchasePackage(package);
        CustomerInfo customerInfo = result.customerInfo;

        final isPremium = customerInfo.entitlements.active.containsKey("premium");

        if (isPremium) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(premiumKey, true);
          return null; // Success
        }
        return "Premium entitlement not found. Please contact support.";
      } else {
        return "Could not find a valid purchase package.";
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return "Purchase cancelled.";
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        return "Purchases are not allowed on this device.";
      } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
        return "Payment is pending. Please check your store account.";
      } else if (kDebugMode && errorCode == PurchasesErrorCode.configurationError) {
        // Mock success for Test Key configuration in debug mode
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(premiumKey, true);
        return null;
      }
      return e.message ?? "An unexpected error occurred.";
    } catch (e) {
      return "An error occurred: ${e.toString()}";
    }
  }

  static Future<bool> isPremiumUser() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final isPremium = customerInfo.entitlements.active.containsKey("premium");
      
      // Sync with local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(premiumKey, isPremium);
      
      return isPremium;
    } catch (e) {
      debugPrint("RevenueCat: Error fetching customer info: $e");
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(premiumKey) ?? false;
    }
  }
}
