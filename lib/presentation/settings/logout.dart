import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/firebase/admob_manage.dart';
import 'package:evalio_app/firebase/firebase_auth.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/repository/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  // ユーザーリポジトリ
  final _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    final _url = "https://twitter.com/9KTwARQQ5qhwShi";
    // ユーザーブロック
    final _userCtrl = Provider.of<UserBloc>(context);

    return ListView(
      children: <Widget>[
        ListTile(
          onTap: () async {
            if (await canLaunch(_url)) {
              launch(_url);
            }
          },
          leading: Icon(
            Icons.link,
            color: Colors.indigo,
          ),
          title: Text('開発者Twitter'),
        ),
        Divider(),
        ListTile(
          onTap: () {
            AdmobManage.adDispose(gamenIndex: 2);
            AdmobManage.showInter();
            FireAuth().twitterSignOut();
            Navigator.pushNamedAndRemoveUntil(
                context, '/loggedIn', (Route<dynamic> route) => false);
          },
          leading: Icon(
            Icons.keyboard_return,
            color: Colors.blue,
          ),
          title: Text('サインアウト'),
        ),
        Divider(),
        ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text('注意'),
                    content: Text('ユーザーデータ及び投稿した記録はすべて削除されますがよろしいですか？'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('キャンセル')),
                      FlatButton(
                          onPressed: () async {
                            AdmobManage.adDispose(gamenIndex: 2);
                            _userRepository.deleteAllData(
                                _userCtrl.getId,
                                _userCtrl.getPostId,
                                _userCtrl.getUserDoc.postModelDoc == null
                                    ? null
                                    : _userCtrl
                                        .getUserDoc
                                        .postModelDoc
                                        .postModel
                                        .content[PostModelField.imageName]);
                            // ユーザーデータを削除する
                            FireAuth().reAuthenticate();
                            FireAuth().deleteAuthenticatedUser();
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/loggedIn', (Route<dynamic> route) => false);
                          },
                          child: Text('OK')),
                    ],
                  );
                });
          },
          leading: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text('アカウント削除'),
        ),
        Divider(),
      ],
    );
  }
}
