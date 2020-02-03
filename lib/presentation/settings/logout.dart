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
          onTap: null,
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
