import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ctrlUser = Provider.of<UserBloc>(context);
    // アイコン定義
    final _selfIcon = Icon(
      Icons.person,
      color: Colors.blueAccent,
    );
    final _interestIcon = Icon(
      Icons.library_books,
      color: Colors.green.shade300,
    );

    return StreamBuilder<UserModelDoc>(
      stream: _ctrlUser.getUser,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _userInfoCard(snapshot.data.userModel, context),
                /*
              * カード共通
              * 0 => 自己紹介カード
              * 1 => 好きな・興味関心のある技術カード
              * */
                _commonProfileCard(
                    snapshot.data.userModel
                        .profile[UserModelField.selfIntroducation],
                    _selfIcon,
                    0,
                    context),
                _commonProfileCard(
                    snapshot.data.userModel.profile[UserModelField.interest],
                    _interestIcon,
                    1,
                    context),
                FlatButton(
                  onPressed: () async {
                    var response = await FlutterShareMe().shareToTwitter(
                      url: '',
                      msg: '#evalio #Twitter転職',
                    );
                  },
                  child: Text('Twitterで共有する'),
                ),
                FlatButton(
                  textColor: Colors.lightBlueAccent,
                  splashColor: Colors.lightBlueAccent.shade100,
                  onPressed: () {
                    Navigator.pushNamed(context, '/test',
                        arguments: _ctrlUser.getUserDoc);
                  },
                  child: Text('投稿されたポートフォリオを確認する'),
                )
              ],
            ),
          );
        }
      },
    );
  }

  // ユーザーカード
  Widget _userInfoCard(UserModel userModel, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(userModel.photoUrl),
          ),
          title: Text(userModel.userName),
        ),
      ),
    );
  }

  // 共通カード
  Widget _commonProfileCard(
      String data, Icon iconData, int cardNo, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: iconData,
              title: cardNo == 0 ? Text('自己紹介') : Text('好きな・興味のある技術'),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              child: Text(cardNo == 0
                  ? data ?? 'まだ自己紹介が入力されておりません'
                  : data ?? 'まだ興味関心のある技術について入力されておりません'),
            ),
          ],
        ),
      ),
    );
  }
}
