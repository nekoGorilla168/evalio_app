import 'package:cached_network_image/cached_network_image.dart';
import 'package:evalio_app/blocs/display_post_list_bloc.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/models/const_programming_language_model.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _streamCtrl = Provider.of<DisplayPostsListBloc>(context);

    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  splashColor: Colors.green.shade100,
                  onTap: () {
                    _streamCtrl.selectedTrend();
                    _streamCtrl.selectedIndexChanged(0);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: _streamCtrl.getISTrend
                                ? Colors.green
                                : Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.trending_up,
                            color: _streamCtrl.getISTrend
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                        Text(
                          'トレンド',
                          style: _streamCtrl.getISTrend
                              ? TextStyle(fontSize: 17)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  splashColor: Colors.green.shade100,
                  onTap: () {
                    _streamCtrl.selectedNew();
                    _streamCtrl.selectedIndexChanged(1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: _streamCtrl.getIsNew
                                  ? Colors.green
                                  : Colors.grey.shade300)),
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.fiber_new,
                            color: _streamCtrl.getIsNew
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                        Text(
                          '最新',
                          style: _streamCtrl.getIsNew
                              ? TextStyle(fontSize: 17)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Expanded(
              child: IndexedStack(
                index: _streamCtrl.getCurIndex,
                children: <Widget>[
                  BuildTrendList(),
                  BuildNewList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// トレンド一覧を表示するクラス
class BuildTrendList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _postsCtrl = Provider.of<PostsBloc>(context);
    // 日付のフォーマット(yyyyMMdd)
    initializeDateFormatting('ja_JP');
    final _format = DateFormat("yyyyMMdd", "ja_JP");

    return Container(
      child: StreamBuilder(
        stream: _postsCtrl.getTrendPosts,
        builder: (context, AsyncSnapshot snapshot) {
          return (snapshot.hasData)
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    return createPostCard(snapshot.data[index], _format);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

// 最新投稿リスト
class BuildNewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _postsCtrl = Provider.of<PostsBloc>(context);
    // 日付のフォーマット(yyyyMMdd)
    initializeDateFormatting('ja_JP');
    final _format = DateFormat("yyyyMMdd", "ja_JP");

    return Container(
      child: StreamBuilder(
        stream: _postsCtrl.getNewPosts,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    return createPostCard(snapshot.data[index], _format);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

// チップリストを返すウィジェット
List<Widget> createChipList(List<String> programmingLanguage) {
  List<Widget> _chipList = programmingLanguage.map((langKey) {
    // 言語名を取得
    String langName = ProgrammingLangMap.plMap[langKey];

    return Transform.scale(
      scale: 0.65,
      child: Chip(
        label: Text(langName),
        backgroundColor: Colors.blueGrey.shade100,
      ),
    );
  }).toList();

  return _chipList;
}

// 投稿されたポートフォリオが現在の日付から何日前の投稿かを計算する
String postedTime(String date) {
  // 今日と投稿日を取得
  var today = DateTime.now();
  var createdAt = DateTime.parse(date);
  // 差分を取得
  var isDiffTime = today.difference(createdAt);

  // 差分により表記が変わる
  if (isDiffTime.inDays != 0) {
    if (isDiffTime.inDays > 30) {
      // 日付のフォーマット(yyyyMMdd)
      initializeDateFormatting('ja_JP');
      final _format = DateFormat("yyyy/MM/dd", "ja_JP");
      return _format.format(createdAt);
    } else {
      return "${isDiffTime.inDays} days ago";
    }
  } else if (isDiffTime.inHours != 0) {
    return "${isDiffTime.inHours} hours ago";
  } else {
    return "${isDiffTime.inMinutes} minutes ago";
  }
}

// 投稿者名・写真を返す
Widget returnAuthorNmPhoto(String userName, [String photoUrl]) {
  return Container(
    child: Expanded(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 3.8, left: 3.8),
            child: CircleAvatar(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 3.8),
            child: Text(userName),
          ),
        ],
      ),
    ),
  );
}

// 現在から投稿日までの経過時間を表示するウィジェット
Widget returnPostedDateTime(DateTime createdAt, DateFormat format) {
  return Container(
    padding: EdgeInsets.only(right: 10.0),
    child: Row(
      children: <Widget>[
        Container(
          child: Text(
            postedTime(format.format(createdAt)),
            style: TextStyle(fontSize: 12.0, color: Colors.grey.shade600),
          ),
        ),
      ],
    ),
  );
}

// お気に入りにされた数によって太さを変える
TextStyle likesCountText(int likesCount) {
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

// トレンド・最新共通
// 投稿リストを生成
Widget createPostCard(PostModelDoc postDoc, DateFormat format) {
  return Card(
    elevation: 5,
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            returnAuthorNmPhoto(postDoc.postModel.title),
            returnPostedDateTime(postDoc.postModel.createdAt, format),
          ],
        ),
        Wrap(
          runSpacing: 2.0,
          alignment: WrapAlignment.start,
          children: createChipList(
              postDoc.postModel.programmingLanguage.cast<String>()),
        ),
        Container(
          color: Colors.deepOrange,
          width: 360,
          height: 200,
          child: CachedNetworkImage(
            imageUrl:
                'https://1.bp.blogspot.com/-B54gNIK9aB8/Xbo7GUlkrKI/AAAAAAABVys/0cVBQjxSw4ovbd-LmFBuCOFYd74bNqTHACNcBGAsYHQ/s1600/figure_jump_happy.png',
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error_outline),
            fit: BoxFit.contain,
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
        ),
        InkWell(
          splashColor: Colors.lightBlueAccent.shade100,
          onTap: () {},
          child: Container(
            width: 360,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    postDoc.postModel.title,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Text(
                  postDoc.postModel.content["theme"],
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
                        style: likesCountText(postDoc.postModel.likesCount),
                      ),
                    ),
                    IconButton(
//                    color: Colors.yellow,
                      splashColor: Colors.yellowAccent,
                      icon: Icon(Icons.star_border),
                      onPressed: () {},
                    ),
                    IconButton(
                        splashColor: Colors.lightBlueAccent.shade100,
                        icon: Icon(Icons.share),
                        onPressed: () {}),
                    IconButton(
                        splashColor: Colors.red.shade300,
                        icon: Icon(Icons.mood_bad),
                        onPressed: () {})
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
