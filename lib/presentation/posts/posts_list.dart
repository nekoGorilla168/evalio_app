import 'package:cached_network_image/cached_network_image.dart';
import 'package:evalio_app/blocs/display_post_list_bloc.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/presentation/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostsList extends StatelessWidget {
  final CommonProcessing common = CommonProcessing();

  // 日付のフォーマット(yyyyMMdd)
  final _format = DateFormat("yyyyMMdd", "ja_JP");

  @override
  Widget build(BuildContext context) {
    final _streamCtrl = Provider.of<DisplayPostsListBloc>(context);
    final _postsCtrl = Provider.of<PostsBloc>(context);

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
                  _postsCtrl.getPostTrendModelDoc == null
                      ? CircularProgressIndicator()
                      : _postList(_postsCtrl.getPostTrendModelDoc, context),
                  _postsCtrl.getPostTrendModelDoc == null
                      ? CircularProgressIndicator()
                      : _postList(_postsCtrl.getPostNewModelDoc, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 最新かトレンドを表示するメソッド
  Widget _postList(List<PostModelDoc> postList, BuildContext context) {
    return postList == null
        ? CircularProgressIndicator()
        : Container(
            child: ListView.builder(
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  return _createPostCard(postList[index], _format, context);
                }),
          );
  }

  // カードを作成するメソッド
  Widget _createPostCard(
      PostModelDoc postDoc, DateFormat format, BuildContext context) {
    final _postCtrl = Provider.of<PostsBloc>(context);
    final _userCtrl = Provider.of<UserBloc>(context);

    return Card(
      elevation: 5,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              returnAuthorNmPhoto(postDoc.userModelDocRef.userModel.userName),
              _returnPostedDateTime(postDoc.postModel.createdAt, format),
            ],
          ),
          Wrap(
            runSpacing: 2.0,
            spacing: -6.0,
            alignment: WrapAlignment.start,
            children: common.createChipList(
                postDoc.postModel.content[PostModelField.programmingLanguage]
                    .cast<String>(),
                0.75),
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
                          style: likesCountText(postDoc.postModel.likesCount),
                        ),
                      ),
                      IconButton(
//                    color: Colors.yellow,
                        splashColor: Colors.yellowAccent,
                        icon: Icon(Icons.star_border),
                        onPressed: () {
                          _postCtrl.addLikesCount(
                              postDoc.postId, _userCtrl.getId);
                        },
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

  // 現在から投稿日までの経過時間を表示するウィジェット
  Widget _returnPostedDateTime(DateTime createdAt, DateFormat format) {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              common.postedTime(format.format(createdAt), format),
              style: TextStyle(fontSize: 12.0, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
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
