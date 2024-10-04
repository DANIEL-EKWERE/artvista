import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsProvider extends ChangeNotifier {
  InterstitialAd? _interstitialAd;
  InterstitialAd? get interstitialAd => _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  NativeAd? _nativeAd;
  NativeAd? get nativeAd => _nativeAd;
  int _numNativeLoadAttempt = 0;
  bool isNativeLoading = false;

  RewardedAd? _rewardedAd;
  RewardedAd? get rewardedAd => _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  int clickCount = 0;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  RewardedInterstitialAd? get rewardedInterstitialAd => _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

  var adUnit = 'ca-app-pub-8689659519341801/7129774650';
  // BannerAd? _bannerAd;
  // int _numBannerLoadAttempt = 0;

  BannerAd? bannerAd;
  bool isLoaded = false;

  int maxFailedLoadAttempts = 0;

  void createNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-8689659519341801/3790127966',
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          isNativeLoading = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _nativeAd!.load();
  }

  void showNativeAd() {
    createNativeAd();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-8689659519341801/9948074331'
            : 'ca-app-pub-8689659519341801/9948074331',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            notifyListeners();
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
        notifyListeners();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
        notifyListeners();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
    notifyListeners();
  }

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-8689659519341801/7868705906'
            : 'ca-app-pub-8689659519341801/7868705906',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              createRewardedAd();
              notifyListeners();
            }
          },
        ));
  }

  void showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd();
        notifyListeners();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
        notifyListeners();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    notifyListeners();
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
    notifyListeners();
  }

  void createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-8689659519341801/5041208804'
            : 'ca-app-pub-8689659519341801/5041208804',
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            print('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            notifyListeners();
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createRewardedInterstitialAd();
              notifyListeners();
            }
          },
        ));
  }

  void showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedInterstitialAd();
        notifyListeners();
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedInterstitialAd();
        notifyListeners();
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedInterstitialAd = null;
    notifyListeners();
  }

  initBannerAds() {
    bannerAd = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: adUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isLoaded = true;
            notifyListeners();
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print(error);
          },
        ),
        request: const AdRequest());

    bannerAd!.load();
    notifyListeners();
  }

  void increamentCount() {
    clickCount++;
    notifyListeners();
  }

  void resetCount() {
    clickCount = 0;
    notifyListeners();
  }
}
