import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
                OutlineButton(
                  shape: StadiumBorder(),
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent.shade100),
                  textColor: Colors.lightBlueAccent,
                  splashColor: Colors.lightBlueAccent.shade100,
                  onPressed: () {
                    if (snapshot.data.postModelDoc != null) {
                      Navigator.pushNamed(context, '/details',
                          arguments: _ctrlUser.getUserDoc);
                    } else {
                      Navigator.pushNamed(context, '/editor');
                    }
                  },
                  child: snapshot.data.postModelDoc == null
                      ? Text('ポートフォリオを投稿してみよう')
                      : Text('自分のポートフォリオを確認する'),
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
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userModel.photoUrl),
              ),
              title: Text(userModel.userName),
            ),
            Divider(
              color: Colors.grey,
            ),
            userModel.twitterLink == null
                ? Container(
                    child: Text('まだTwitterへのリンクが貼られておりません'),
                  )
                : InkWell(
                    onTap: () async {
                      if (await canLaunch(userModel.twitterLink)) {
                        await launch(userModel.twitterLink);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        userModel.twitterLink,
                        style:
                            TextStyle(color: Colors.lightBlueAccent.shade100),
                      ),
                    ),
                  ),
          ],
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
