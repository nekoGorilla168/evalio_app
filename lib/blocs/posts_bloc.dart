import 'dart:async';
import 'dart:io';

import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/repository/posts_repository.dart';

class PostsBloc {
  // 投稿リストリポジトリ
  final _postRepository = PostsRepositpry();

  // いいね
  final _trendPostsController =
      StreamController<List<PostModelDoc>>.broadcast();
  Stream<List<PostModelDoc>> get getTrendPosts => _trendPostsController.stream;
  // 最新順
  final _newPostsController = StreamController<List<PostModelDoc>>.broadcast();
  Stream<List<PostModelDoc>> get getNewPosts => _newPostsController.stream;

  // 投稿クラス
  PostModelDoc _postModelDoc;

  // コンストラクタ
  PostsBloc() {
    getTrendPostsList();
    getNewPostsList();
  }

  // 自分が投稿したポートフォリオを取得
  void getMyPortfolio() async {}

  //　トレンド取得
  void getTrendPostsList() async {
    List<PostModelDoc> _postModelDoc = await _postRepository.getTrendPosts();
    if (_postModelDoc != null) _trendPostsController.sink.add(_postModelDoc);
  }

  // 最新リスト取得
  void getNewPostsList() async {
    List<PostModelDoc> _postModelDoc = await _postRepository.getNewPosts();
    if (_postModelDoc != null) _newPostsController.sink.add(_postModelDoc);
  }

  // 投稿用のデータを確保する

  // ポートフォリオを登録
  void addPostData(
    String title,
    List<String> langNames,
    File file,
    String portfolioUrl,
    String overview,
    String details,
    String userId,
  ) {
    _postRepository.addPortfolio(
        title, langNames, file, portfolioUrl, overview, details, userId);
  }

  void setPostDate() {}

  void dispose() {
    _trendPostsController.close();
    _newPostsController.close();
  }
}
