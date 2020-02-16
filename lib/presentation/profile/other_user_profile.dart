import 'package:admob_flutter/admob_flutter.dart';
import 'package:evalio_app/firebase/admob_manage.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherUserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModelDoc otherUser = ModalRoute.of(context).settings.arguments;

    // アイコン定義
    final _selfIcon = Icon(
      Icons.person,
      color: Colors.blueAccent,
    );
    final _interestIcon = Icon(
      Icons.library_books,
      color: Colors.green.shade300,
    );

    return otherUser == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text('ユーザープロフィール'),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _userInfoCard(otherUser.userModel, context),
                  /*
              * カード共通
              * 0 => 自己紹介カード
              * 1 => 好きな・興味関心のある技術カード
              * */
                  _commonProfileCard(
                      otherUser
                          .userModel.profile[UserModelField.selfIntroducation],
                      _selfIcon,
                      0,
                      context),
                  _commonProfileCard(
                      otherUser.userModel.profile[UserModelField.interest],
                      _interestIcon,
                      1,
                      context),
                  Container(
                    child: AdmobBanner(
                        adUnitId: AdmobManage.getBannerId(),
                        adSize: AdmobBannerSize.LARGE_BANNER),
                  ),
                ],
              ),
            ),
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
            InkWell(
              onTap: () async {
                if (await canLaunch(userModel.twitterLink)) {
                  await launch(userModel.twitterLink);
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  userModel.twitterLink,
                  style: TextStyle(color: Colors.lightBlueAccent.shade100),
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
