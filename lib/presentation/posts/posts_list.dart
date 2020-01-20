import 'package:cached_network_image/cached_network_image.dart';
import 'package:evalio_app/blocs/display_post_list_bloc.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/models/test.dart';
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
                                  : Colors.grey.shade300)),
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
                        Text('トレンド'),
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
                        Text('最新'),
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
    final _format = DateFormat.yMd();

    return Container(
      child: StreamBuilder(
        stream: _postsCtrl.getPostsList,
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
    final _format = DateFormat("yyyy-mm-dd", "ja_JP");

    return Container(
        child: StreamBuilder(
            stream: _postsCtrl.newPostsList,
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
            }));
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

// トレンド・最新共通
// 投稿リストを生成
Widget createPostCard(PostModel post, DateFormat format) {
  return Card(
    elevation: 5,
    child: Column(
      children: <Widget>[
        Row(children: createChipList(post.programmingLanguage.cast<String>())),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[Text('投稿日  ' + format.format(post.createdAt))],
        ),
        Divider(
          color: Colors.grey.shade300,
        ),
        Row(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 3.8),
                    child: CircleAvatar(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3.8),
                    child: Text(post.title),
                  )
                ],
              ),
            ),
            Container(
                child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text('${post.likesCount}'),
                  ),
                  IconButton(
//                    color: Colors.yellow,
                    splashColor: Colors.yellowAccent,
                    icon: Icon(Icons.star_border),
                    onPressed: () {},
                  )
                ],
              ),
            )),
          ],
        )
      ],
    ),
  );
}
