import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shopsmart/core/services/admob_service.dart';

class InterstitialAdService {
  InterstitialAd? interstitialAd;

  void loadAd() {
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

  void showAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();

      interstitialAd = null;
    }
  }
}
