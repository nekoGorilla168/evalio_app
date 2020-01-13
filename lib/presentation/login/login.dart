import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ctrlUser = Provider.of<UserBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
        leading: Container(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                color: Colors.lightBlue, // デフォルトの色
                splashColor: Colors.blue, // 押下時の色
                child: Text(
                  'Twitter Login',
                  style: TextStyle(color: Colors.white), // 文字色(白)
                ),
                onPressed: () {
                  _signInTwitter().then((response) {
                    // ユーザー情報有
                    if (response != null) {
                      _ctrlUser.createFUser(response);
                    }
                    Navigator.pushNamed(context, '/home');
                  });
                } // Twitterログイン
                ),
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _signInTwitter() async {
    final twitterLoggedIn = new TwitterLogin(
      consumerKey: DotEnv().env['TWITTER_API_KEY'],
      consumerSecret: DotEnv().env['TWITTER_API_SECRET_KEY'],
    );

    final TwitterLoginResult result = await twitterLoggedIn.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        //var session = result.session;
        FirebaseUser twUser = await _signInWithTwitter(
            result.session.token, result.session.secret);
        return twUser;
        break;
      case TwitterLoginStatus.cancelledByUser:
        debugPrint('Canceled');
        return null;
        break;
      case TwitterLoginStatus.error:
        debugPrint('Error!');
        return null;
        break;
    }
  }
}

// サインイン
Future<FirebaseUser> _signInWithTwitter(String token, String secret) async {
  final AuthCredential credential = TwitterAuthProvider.getCredential(
      authToken: token, authTokenSecret: secret);
  // Twitterユーザー情報取得
  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  assert(user.displayName != null);
  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  return user;
}
