import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdmobManage {
  // インタースティシャル広告
  static AdmobInterstitial interstitialAd;

  // 初期化処理
  static void initAdInfo() {
    interstitialAd = AdmobInterstitial(
        adUnitId: getInterId(),
        listener: (AdmobAdEvent event, Map args) {
          if (event == AdmobAdEvent.closed) interstitialAd.load();
        });

    interstitialAd.load();
  }

  //Banner Ad Unit Id取得
  static String getBannerId() {
    return DotEnv().env['AD_UNIT_BANNER_ID'];
  }

  // Interstitial Ad Unit Id 取得
  static String getInterId() {
    return DotEnv().env['AD_UNIT_INTER_ID'];
  }
}
