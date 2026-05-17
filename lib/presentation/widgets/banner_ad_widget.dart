import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shopsmart/core/services/admob_service.dart';
import 'package:shopsmart/core/services/premium_service.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => BannerAdWidgetState();
}

class BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? bannerAd;
  bool isAdLoaded = false;
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkPremiumAndLoadAd();
  }

  Future<void> _checkPremiumAndLoadAd() async {
    isPremium = await PremiumService.isPremium();
    if (mounted) {
      setState(() {});
    }
    if (!isPremium) {
      loadBannerAd();
    }
  }

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: AdMobService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Failed to load a banner ad: ${error.message}');
        },
      ),
    );
    bannerAd!.load();
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isPremium) {
      return const SizedBox.shrink();
    }
    if (!isAdLoaded || bannerAd == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: bannerAd!.size.height.toDouble(),
      width: bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: bannerAd!),
    );
  }
}
