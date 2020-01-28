import 'package:cached_network_image/cached_network_image.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PortfolioDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 遷移時の値受け渡し
    UserModelDoc userInfo = ModalRoute.of(context).settings.arguments;

    return userInfo == null
        ? CircularProgressIndicator()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('ポートフォリオ詳細'),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    postUserInfo(userInfo.userModel.userName,
                        userInfo.userModel.photoUrl),
                    showPostedDate(userInfo.postModelDoc.postModel.createdAt,
                        userInfo.postModelDoc.postModel.updatedAt),
                    showTitle(userInfo
                        .postModelDoc.postModel.content[PostModelField.title]),
                  ],
                ),
              ),
            ),
          );
  }

  // 投稿したユーザーの情報
  Widget postUserInfo(String userName, String photoUrl) {
    // 文字のスタイル
    final style = TextStyle(fontSize: 15.0);

    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Container(
            child: CachedNetworkImage(
              imageUrl: photoUrl,
              imageBuilder: (context, imgProvider) => Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: imgProvider, fit: BoxFit.fill),
                ),
              ),
              placeholder: (context, img) => CircularProgressIndicator(),
              errorWidget: (context, img, error) => Icon(Icons.error),
            ),
          ),
          Text(
            userName,
            style: style,
          ),
        ],
      ),
    );
  }

  // 登録日・更新日を表示
  Widget showPostedDate(DateTime createDate, DateTime updateDate) {
    // 日付のフォーマット(yyyyMMdd)
    final _format = DateFormat("yyyy/MM/dd", "ja_JP");

    final _dateFontStyle = TextStyle(color: Colors.grey);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              'create / ${_format.format(createDate)}',
              style: _dateFontStyle,
            ),
            updateDate == null
                ? Container()
                : Text(
                    'update / ${_format.format(updateDate)}',
                    style: _dateFontStyle,
                  ),
          ],
        )
      ],
    );
  }

  // タイトルを表示する
  Widget showTitle(String title) {
    // タイトルのスタイルを決定
    final _titleStyle = TextStyle(fontSize: 30.0,);

    return Text(
      '${title}',
      style: _titleStyle,
    );
  }

  // ポートフォリオ
  Widget portFolioDetails(PostModelDoc postModelDoc) {
    return Container(
      child: Column(
        children: <Widget>[],
      ),
    );
  }
}
