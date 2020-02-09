import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_twitter/flutter_twitter.dart';

class FireAuth {
  // FirebaseAuth認証インスタンス
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // APIキーの入力
  final twitterLoggedIn = new TwitterLogin(
    consumerKey: DotEnv().env['TWITTER_API_KEY'],
    consumerSecret: DotEnv().env['TWITTER_API_SECRET_KEY'],
  );

  // 現在のログインユーザーを取得する
  Future<String> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user?.uid;
  }

  // サインアウト
  twitterSignOut() {
    _auth.signOut();
  }

  // 再認証する
  reAuthenticate() async {
    FirebaseUser user = await _auth.currentUser();
    TwitterSession session = await twitterLoggedIn.currentSession;
    print(session.toString());
    AuthCredential credential = TwitterAuthProvider.getCredential(
        authToken: session.token, authTokenSecret: session.secret);
    user.reauthenticateWithCredential(credential);
  }

  // ユーザーを削除する
  deleteAuthenticatedUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    if (currentUser != null) currentUser.delete();
  }

  // Twitter認証を行う
  Future<FirebaseUser> signInTwitter() async {
    // ツイッターの認証画面表示
    final TwitterLoginResult result = await twitterLoggedIn.authorize();

    // TwitterSession取得
    var session = result.session;
    // ユーザー情報にアクセス
    final AuthCredential authCredential = TwitterAuthProvider.getCredential(
        authToken: session.token, authTokenSecret: session.secret);

    // firebaeのUID取得
    final FirebaseUser firebaseUser =
        (await _auth.signInWithCredential(authCredential)).user;
    assert(!firebaseUser.isAnonymous);
    assert(await firebaseUser.getIdToken() != null);

    // firebaseの現在のユーザと認証済みのユーザを比較
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(currentUser.uid == firebaseUser.uid);
    return currentUser;
  }
}
