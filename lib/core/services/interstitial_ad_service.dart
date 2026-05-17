import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shopsmart/core/services/admob_service.dart';
import 'package:shopsmart/core/services/premium_service.dart';

class InterstitialAdService {
  InterstitialAd? interstitialAd;

  Future<void> loadAd() async {
    bool isPremium = await PremiumService.isPremium();
    if (isPremium) return;

    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          debugPrint('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Failed to load interstitial ad: ${error.message}');
        },
      ),
    );
  }

  Future<void> showAd() async {
    bool isPremium = await PremiumService.isPremium();
    if (isPremium) return;

    if (interstitialAd != null) {
      interstitialAd!.show();

      interstitialAd = null;
    }
  }
}
