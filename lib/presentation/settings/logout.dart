import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/repository/users_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  // ユーザーリポジトリ
  final _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    // ユーザーブロック
    final _userCtrl = Provider.of<UserBloc>(context);

    return ListView(
      children: <Widget>[
        ListTile(
          onTap: () {
            FirebaseAuth.instance.signOut();
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
                          onPressed: () {
                            _userRepository.deleteAllData(
                                _userCtrl.getId,
                                _userCtrl.getPostId,
                                _userCtrl.getUserDoc.postModelDoc.postModel
                                    .content[PostModelField.imageName]);
                            FirebaseAuth.instance.signOut();
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
//        ListTile(
//          title: Text('a'),
//        ),
//        Divider(),
      ],
    );
  }
}
