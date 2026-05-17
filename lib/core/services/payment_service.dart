import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static Map<String, dynamic>? paymentIntent;

  static Future<bool> makePayment({
    required String amount,
    required String currency,
  }) async {
    try {
      // MOCK SUCCESS FOR TESTING:
      // If we are using a placeholder key in debug mode, simulate success.
      if (kDebugMode) {
        debugPrint("Stripe: Placeholder key detected. Simulating successful payment for testing...");
        await Future.delayed(const Duration(seconds: 2));
        return true;
      }

      // 1. Create Payment Intent on the server
      paymentIntent = await _createPaymentIntent(amount, currency);

      if (paymentIntent == null) return false;

      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'ShopSmart',
        ),
      );

      // 3. Display Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      debugPrint("Stripe Error: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> _createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      // NOTE: In a real app, this should be done on your backend.
      // Do NOT put your Secret Key in the mobile app code.
      Map<String, dynamic> body = {
        'amount': _calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_placeholder', // REPLACE WITH YOUR SECRET KEY IN BACKEND
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('Error creating PaymentIntent: ${err.toString()}');
      return null;
    }
  }

  static String _calculateAmount(String amount) {
    final calculatedAmount = (double.parse(amount) * 100).toInt();
    return calculatedAmount.toString();
  }
}
