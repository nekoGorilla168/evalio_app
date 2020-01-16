import 'package:evalio_app/blocs/display_post_list_bloc.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:flutter/material.dart';
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

    return Container(
      child: StreamBuilder(
        stream: _postsCtrl.getPostsList,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.separated(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(''),
                      ),
                      title: Text(snapshot.data[index].title),
                      subtitle: Text.rich(TextSpan(children: [
                        TextSpan(text: '投稿者:${snapshot.data[index].title}'),
                        WidgetSpan(child: Icon(Icons.star)),
                      ])),
                      isThreeLine: true,
                      onTap: () {},
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey.shade300,
                    );
                  },
                )
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

    return Container(
        child: StreamBuilder(
            stream: _postsCtrl.newPostsList,
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? ListView.separated(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, int index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(''),
                          ),
                          title: Text(snapshot.data[index].title),
                          subtitle: Text.rich(TextSpan(children: [
                            TextSpan(text: '投稿者:${snapshot.data[index].title}'),
                            WidgetSpan(child: Icon(Icons.star)),
                          ])),
                          isThreeLine: true,
                          onTap: () {},
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey.shade300,
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }
}
