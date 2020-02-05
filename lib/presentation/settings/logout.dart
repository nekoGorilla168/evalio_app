import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      FlatButton(onPressed: () {}, child: Text('キャンセル')),
                      FlatButton(onPressed: () {}, child: Text('OK')),
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
