import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/presentation/common/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostListTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // トレンド最新を表示する
    return Container(
      padding: EdgeInsets.only(top: 57.0),
      child: TabBarView(
        children: [
          TrendList(),
          NewList(),
        ],
      ),
    );
  }
}

class TrendList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //
    return _TrendListState();
  }
}

class _TrendListState extends State<TrendList>
    with AutomaticKeepAliveClientMixin {
  // 共通処理クラス
  final CommonProcessing common = CommonProcessing();
  // 日付のフォーマット(yyyyMMdd)
  final _format = DateFormat("yyyyMMdd", "ja_JP");

  // 投稿のブロック
  PostsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PostsBloc();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  // 状態保持
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: // 最新の投稿リスト
          StreamBuilder(
        stream: bloc.getTrendPosts,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return common.createPostCard(
                          snapshot.data[index], _format);
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class NewList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //
    return _NewListState();
  }
}

class _NewListState extends State<NewList> with AutomaticKeepAliveClientMixin {
  // 共通処理クラス
  final CommonProcessing common = CommonProcessing();
  // 日付のフォーマット(yyyyMMdd)
  final _format = DateFormat("yyyyMMdd", "ja_JP");

  // 投稿のブロック
  PostsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PostsBloc();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  // 状態保持
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: // トレンドの投稿リスト
          StreamBuilder(
        stream: bloc.getNewPosts,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return common.createPostCard(
                            snapshot.data[index], _format);
                      }),
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
