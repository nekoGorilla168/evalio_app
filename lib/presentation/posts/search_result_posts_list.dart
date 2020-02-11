import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/presentation/common/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SearcResultPosts extends StatelessWidget {
  // 共通関数クラス
  final common = CommonProcessing();
  // 日付のフォーマット(yyyyMMdd)
  final _format = DateFormat("yyyyMMdd", "ja_JP");

  @override
  Widget build(BuildContext context) {
    // 投稿ブロック
    final _postCtrl = Provider.of<PostsBloc>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('検索結果'),
        ),
        body: Container(
          child: StreamBuilder<List<PostModelDoc>>(
            stream: _postCtrl.getSearchResult,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Card(
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          title: Text('Error!'),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                              '検索エラーが発生しました。検索条件が未指定、あるいは通信状況が悪い可能性があります。'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return common.createPostCard(
                            snapshot.data[index], _format);
                      }),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
