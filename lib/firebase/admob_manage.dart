import 'package:firebase_admob/firebase_admob.dart';

class AdmobManage {
  static const MobileAdTargetingInfo mobileAd = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    childDirected: false,
    contentUrl: 'https://flutter.io',
  );
  static BannerAd banner;

  static InterstitialAd interstitialAd;

  // 初期化処理
  static void initAdInfo() {
    // バナー
    banner ??= BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.fullBanner,
      targetingInfo: mobileAd,
      listener: (event) => print('Initialize Ad'),
    );
    interstitialAd = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: mobileAd,
    );
    // バナーを表示
    if (banner != null)
      banner
        ..load()
        ..show(anchorOffset: 137.0, anchorType: AnchorType.top);
  }

  // バナー広告を作成する
  static void createBannerForHome() {
    // バナー
    banner = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.fullBanner,
      targetingInfo: mobileAd,
      listener: (event) => print('Initialize Ad'),
    );
  }

  // 設定画面用バナー広告を作成する
  static void createBannerForSetting() {
    // バナー
    banner = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.mediumRectangle,
      targetingInfo: mobileAd,
      listener: (event) => print('Initialize Ad'),
    );
  }

  // ホーム画面用バナーを表示する
  static void showBannerForHome() {
    createBannerForHome();
    // バナーを表示
    banner
      ..load()
      ..show(anchorOffset: 137.0, anchorType: AnchorType.top);
  }

  // 設定画面用バナーを表示する
  static void showBannerForSetteing() {
    createBannerForSetting();
    // バナーを表示
    banner
      ..load()
      ..show(anchorOffset: 120.0, anchorType: AnchorType.bottom);
  }

  // インタースティシャル広告作成
  static void createInter() {
    interstitialAd = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: mobileAd,
    );
  }

  // インタースティシャル広告の表示
  static void showInter() {
    createInter();
    // インタースティシャル広告表示
    interstitialAd
      ..load()
      ..show();
  }

  // バナーを消す
  static void adDispose({int gamenIndex}) async {
    bool diss = false;
    if (gamenIndex == 0) {
      diss = await banner?.dispose();
      banner = null;
      showBannerForHome();
    } else if (gamenIndex == 3) {
      diss = await banner?.dispose();
      banner = null;
      showBannerForSetteing();
    } else {
      diss = await banner?.dispose();
      banner = null;
    }
  }
}
