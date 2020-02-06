import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // グローバルキー
    final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
    // ユーザーブロック
    final _userCtrl = Provider.of<UserBloc>(context);

    // ユーザー情報(遷移情報)
    UserModelDoc userInfo = ModalRoute.of(context).settings.arguments;
    // 使用アイコン定義
    final _link = Icon(
      Icons.link,
      color: Colors.indigo,
    );
    final _person = Icon(
      Icons.person,
      color: Colors.blueAccent,
    );
    final _technique = Icon(
      Icons.library_books,
      color: Colors.green,
    );

    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text('プロフィール編集'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () {
                        _userCtrl.updateUserProfile(
                            userInfo.userId,
                            _userCtrl.getIntroducation,
                            _userCtrl.getInterest,
                            _userCtrl.getTwitterLink);
                        // スナックバー表示
                        _key.currentState.showSnackBar(
                            const SnackBar(content: Text('プロフィールを更新しました。')));
                        // 画面を破棄して戻る
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.navigate_next),
                      label: Text('登録する'),
                    ),
                  ],
                ),
                /*
                  *入力エリアは共通化させる
                  * 入力エリアに番号を付与する
                  * 0 => Twitterリンク
                  * 1 => 自己紹介
                  * 2 => 好きな興味のある技術
                  * */
                _inputArea('あなたのTwitterへのリンク', _link, 0, _userCtrl),
                _inputArea('自己紹介', _person, 1, _userCtrl),
                _inputArea('好きな・興味のある技術', _technique, 2, _userCtrl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 共通入力エリア
  Widget _inputArea(
      String labelText, Icon icon, int areaNo, UserBloc userCtrl) {
    // 初期値設定
    String data;
    if (areaNo == 0) {
      data = userCtrl.getUserDoc.userModel.twitterLink;
    } else if (areaNo == 1) {
      data = userCtrl
          .getUserDoc.userModel.profile[UserModelField.selfIntroducation];
    } else {
      data = userCtrl.getUserDoc.userModel.profile[UserModelField.interest];
    }

    return Container(
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        maxLength: 200,
        initialValue: data ?? null,
        decoration: InputDecoration(
          hintMaxLines: 200,
          icon: icon,
          labelText: labelText,
        ),
        onChanged: (String inputData) {
          if (areaNo == 0) {
            userCtrl.setTwitterLink(inputData);
          } else if (areaNo == 1) {
            userCtrl.setIntroducation(inputData);
          } else {
            userCtrl.setInterest(inputData);
          }
        },
      ),
    );
  }
}
