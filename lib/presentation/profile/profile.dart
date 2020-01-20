import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ctrlUser = Provider.of<UserBloc>(context);

    return StreamBuilder<UserModel>(
        stream: _ctrlUser.getUser,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[],
                ),
                Card(
                  child: Text('自己紹介'),
                ),
                Card(
                  child: Text('好きな興味のある技術'),
                ),
                FlatButton(
                  onPressed: () async {
                    var response = await FlutterShareMe().shareToTwitter(
                      url: '',
                      msg: '#evalio #Twitter転職',
                    );
                  },
                  child: Text('Twitterで共有する'),
                )
              ],
            );
          }
        });
  }
}
