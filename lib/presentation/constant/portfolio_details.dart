import 'package:cached_network_image/cached_network_image.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/const_programming_language_model.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 投稿への操作
    final _postCtrl = Provider.of<PostsBloc>(context);
    // ユーザー情報取得
    final _userCtrl = Provider.of<UserBloc>(context);
    // 遷移時の値受け渡し
    UserModelDoc userInfo = ModalRoute.of(context).settings.arguments;

    return userInfo == null
        ? CircularProgressIndicator()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text('ポートフォリオ詳細'),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // ログインユーザーIDとポートフォリオのIDが同じかどうか
                    _userCtrl.getPostId == userInfo.postModelDoc.postId
                        ? Container(
                            alignment: Alignment.topRight,
                            child: FlatButton.icon(
                              onPressed: () {
                                _postCtrl.deletePOrtfolio(_userCtrl.getId,
                                    userInfo.postModelDoc.postId);
                                _userCtrl.getUserInfo(_userCtrl.getId);
                              },
                              icon: Icon(Icons.navigate_next),
                              label: Text('削除する'),
                            ),
                          )
                        : Container(),
                    // 投稿ユーザー情報
                    postUserInfo(context, userInfo),
                    // 投稿日・更新日
                    showPostedDate(userInfo.postModelDoc.postModel.createdAt,
                        userInfo.postModelDoc.postModel.updatedAt),
                    Divider(
                      color: Colors.grey,
                    ),
                    // アプリケーションタイトル
                    showTitle(
                        context,
                        userInfo.postModelDoc.postModel
                            .content[PostModelField.title]),
                    // 使用技術のリスト
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: -6,
                      children: createChipList(userInfo.postModelDoc.postModel
                          .content[PostModelField.programmingLanguage]),
                    ),
                    // 写真表示
                    _displayPhotoField(userInfo.postModelDoc.postModel
                        .content[PostModelField.imageUrl]),
                    // URLオープン
                    _launchUrl(userInfo.postModelDoc.postModel
                        .content[PostModelField.portfolioUrl]),
                    // いいね数表示
                    _displayLikesCount(
                        userInfo.postModelDoc.postModel.likesCount),
                    Divider(
                      color: Colors.grey,
                    ),
                    //　アプリケーション概要タイトル
                    _overviewTitle(),
                    // 概要表示
                    _displayOverview(
                        context,
                        userInfo.postModelDoc.postModel
                            .content[PostModelField.overview]),
                    Divider(
                      color: Colors.grey,
                    ),
                    // アプリケーション詳細タイトル
                    _detailsTitle(),
                    // アプリケーション詳細表示
                    _displayDetails(
                        context,
                        userInfo.postModelDoc.postModel
                            .content[PostModelField.details])
                  ],
                ),
              ),
            ),
          );
  }

  // 投稿したユーザーの情報
  Widget postUserInfo(BuildContext context, UserModelDoc userModelDoc) {
    // 文字のスタイル
    final style = TextStyle(fontSize: 15.0);
    final _userCtrl = Provider.of<UserBloc>(context);

    return InkWell(
      onTap: () {
        if (_userCtrl.getId != userModelDoc.userId) {
          Navigator.of(context)
              .pushNamed('/otherUserProfile', arguments: userModelDoc);
        }
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Container(
              child: CachedNetworkImage(
                imageUrl: userModelDoc.userModel.photoUrl,
                imageBuilder: (context, imgProvider) => Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                        DecorationImage(image: imgProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, img) => CircularProgressIndicator(),
                errorWidget: (context, img, error) => Icon(Icons.error),
              ),
            ),
            Text(
              userModelDoc.userModel.userName,
              style: style,
            ),
          ],
        ),
      ),
    );
  }

  // 登録日・更新日を表示
  Widget showPostedDate(DateTime createDate, DateTime updateDate) {
    // 日付のフォーマット(yyyyMMdd)
    final _format = DateFormat("yyyy/MM/dd", "ja_JP");

    final _dateFontStyle = TextStyle(color: Colors.grey);

    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'create ${_format.format(createDate)}',
                style: _dateFontStyle,
              ),
              updateDate == null
                  ? Container()
                  : Text(
                      'update ${_format.format(updateDate)}',
                      style: _dateFontStyle,
                    ),
            ],
          )
        ],
      ),
    );
  }

  // タイトルを表示する
  Widget showTitle(BuildContext context, String title) {
    // タイトルのスタイルを決定
    final _titleStyle = TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.w600,
    );

    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Text(
        '$title',
        style: _titleStyle,
      ),
    );
  }

  // チップリストを返すウィジェット
  List<Widget> createChipList(List<dynamic> programmingLanguage) {
    List<Widget> _chipList = programmingLanguage.map((langKey) {
      // 言語名を取得
      String langName = ProgrammingLangMap.plMap[langKey];

      return Transform.scale(
        scale: 0.85,
        child: Chip(
          label: Text(langName),
          backgroundColor: Colors.blueGrey.shade100,
        ),
      );
    }).toList();
    return _chipList;
  }

  // 写真の表示領域
  Widget _displayPhotoField(String imageUrl) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
      width: 360,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (BuildContext context, url) =>
              CircularProgressIndicator(),
          errorWidget: (BuildContext context, url, error) =>
              Icon(Icons.error_outline),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // URLを開く
  Widget _launchUrl(String portfolioUrl) {
    final _portfolioUrlStyle = TextStyle(color: Colors.lightBlue);

    return GestureDetector(
      onTap: () async {
        if (await canLaunch(portfolioUrl)) {
          await launch(portfolioUrl);
        } else {}
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          portfolioUrl,
          style: _portfolioUrlStyle,
        ),
      ),
    );
  }

  // お気に入りにされた数
  Widget _displayLikesCount(int likesCount) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 30.0,
        ),
        Text('$likesCount'),
      ],
    );
  }

  // アプリケーション概要のタイトル表示
  Widget _overviewTitle() {
    final _overviewStyle = TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.dotted);
    return Container(
      padding: EdgeInsets.only(top: 5.0, right: 220, bottom: 15.0),
      child: Text(
        'Overview',
        style: _overviewStyle,
      ),
    );
  }

  // アプリケーション概要の本文を表示
  Widget _displayOverview(BuildContext context, String overview) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: Text(overview),
    );
  }

  // 詳細のタイトル
  Widget _detailsTitle() {
    final _detailsStyle = TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.dotted);
    return Container(
      padding: EdgeInsets.only(top: 5.0, right: 250, bottom: 15.0),
      child: Text(
        'Details',
        style: _detailsStyle,
      ),
    );
  }

  // アプリケーション詳細
  Widget _displayDetails(BuildContext context, String details) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: MarkdownBody(
        data: details,
      ),
    );
  }
}
