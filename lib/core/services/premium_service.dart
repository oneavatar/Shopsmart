import 'package:shared_preferences/shared_preferences.dart';

class PremiumService {
  static const String premiumKey = 'isPremium';

  static Future<void> setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(premiumKey, value);
  }

  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(premiumKey) ?? false;
  }
}
