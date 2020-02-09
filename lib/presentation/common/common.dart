import 'package:cached_network_image/cached_network_image.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/const_programming_language_model.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommonProcessing {
  // チップリストを返すウィジェット
  List<Widget> createChipList(List<String> programmingLanguage, double scale) {
    List<Widget> _chipList = programmingLanguage.map((langKey) {
      // 言語名を取得
      String langName = ProgrammingLangMap.plMap[langKey];

      return Transform.scale(
        scale: scale,
        child: Chip(
          label: Text(langName),
          backgroundColor: Colors.blueGrey.shade100,
        ),
      );
    }).toList();

    return _chipList;
  }

  // 日付けの計算
  String postedTime(String date, DateFormat format) {
    // 今日と投稿日を取得
    var today = DateTime.now();
    var createdAt = DateTime.parse(date);
    // 差分を取得
    var isDiffTime = today.difference(createdAt);

    // 差分により表記が変わる
    if (isDiffTime.inDays != 0) {
      if (isDiffTime.inDays > 30) {
        // 日付のフォーマット(yyyyMMdd)
        return format.format(createdAt);
      } else {
        return "${isDiffTime.inDays} days ago";
      }
    } else if (isDiffTime.inHours != 0) {
      return "${isDiffTime.inHours} hours ago";
    } else {
      return "${isDiffTime.inMinutes} minutes ago";
    }
  }

  // カードを作成するメソッド
  Widget createPostCard(PostModelDoc postDoc, DateFormat format) {
    return Builder(builder: (BuildContext context) {
      final _postCtrl = Provider.of<PostsBloc>(context);
      final _userCtrl = Provider.of<UserBloc>(context);

      return Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // 投稿者名とアバターを表示する
                _returnAuthorNmPhoto(postDoc.userModelDocRef.userModel.userName,
                    postDoc.userModelDocRef.userModel.photoUrl),
                // 投稿日を表示する
                _returnPostedDateTime(postDoc.postModel.createdAt, format),
              ],
            ),
            Wrap(
              runSpacing: 2.0,
              spacing: -6.0,
              alignment: WrapAlignment.start,
              children: createChipList(
                  // 使用技術のチップリストを返す
                  postDoc.postModel.content[PostModelField.programmingLanguage]
                      .cast<String>(),
                  0.75),
            ),
            Container(
              width: 360,
              height: 200,
              child: CachedNetworkImage(
                imageUrl: postDoc.postModel.content[PostModelField.imageUrl],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
                fit: BoxFit.cover,
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
            InkWell(
              splashColor: Colors.lightBlueAccent.shade100,
              onTap: () {
                Navigator.of(context).pushNamed('/details',
                    arguments: UserModelDoc(postDoc.userModelDocRef.userId,
                        postDoc.userModelDocRef.userModel, postDoc));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        postDoc.postModel.content[PostModelField.title],
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Text(
                      postDoc.postModel.content[PostModelField.overview],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 0.0),
                          child: Text(
                            '${postDoc.postModel.likesCount} Likes!',
                            style:
                                _likesCountText(postDoc.postModel.likesCount),
                          ),
                        ),
                        // いいねボタンクラス
                        LikesIcon(postDoc.postId),
                        IconButton(
                          splashColor: Colors.lightBlueAccent.shade100,
                          icon: Icon(Icons.share),
                          onPressed: () async {
                            var response =
                                await FlutterShareMe().shareToTwitter(
                              url: '',
                              msg: _twitterMessage(
                                  postDoc
                                      .postModel.content[PostModelField.title],
                                  postDoc.userModelDocRef.userModel.userName),
                            );
                          },
                        ),
                        IconButton(
                            splashColor: Colors.red.shade300,
                            icon: Icon(Icons.mood_bad),
                            onPressed: () {}),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  // 現在から投稿日までの経過時間を表示するウィジェット
  Widget _returnPostedDateTime(DateTime createdAt, DateFormat format) {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              postedTime(format.format(createdAt), format),
              style: TextStyle(fontSize: 12.0, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  // 共有用メッセージ作成
  String _twitterMessage(String title, String userName) {
    String msg = '''このポートフォリオをシェア！
    
【ユーザー】
$userName 
【タイトル】
$title 

アプリ内で検索！

#evalio
#Twitter転職''';
    return msg;
  }

// 投稿者名・写真を返す
  Widget _returnAuthorNmPhoto(String userName, [String photoUrl]) {
    return Container(
      child: Expanded(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 3.8, left: 3.8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.8),
              child: Container(
                width: 200,
                child: Text(
                  userName,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// お気に入りにされた数によって太さを変える
  TextStyle _likesCountText(int likesCount) {
    TextStyle _style;

    if (likesCount < 10) {
      _style = TextStyle(fontWeight: FontWeight.w300);
    } else if (likesCount < 100) {
      _style = TextStyle(fontWeight: FontWeight.w400);
    } else {
      _style = TextStyle(fontWeight: FontWeight.w700);
    }
    return _style;
  }
}

//
class LikesIcon extends StatelessWidget {
  final postId;

  LikesIcon(this.postId);

  @override
  Widget build(BuildContext context) {
    final _userCtrl = Provider.of<UserBloc>(context);
    return StreamBuilder<List<String>>(
      stream: _userCtrl.getMyFavoriteList,
      builder: (context, snapshot) {
        return IconButton(
          color: snapshot.hasData && snapshot.data.contains(postId) == true
              ? Colors.yellow
              : Colors.black,
          splashColor: Colors.yellowAccent,
          icon: Icon(Icons.star_border),
          onPressed: () async {
            _userCtrl.updateMyFavoriteList(postId, _userCtrl.getId);
          },
        );
      },
    );
  }
}
