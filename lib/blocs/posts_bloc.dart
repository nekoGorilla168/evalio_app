import 'dart:async';

import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/repository/posts_repository.dart';

class PostsBloc {
  // 投稿リストリポジトリ
  final _postRepository = PostsRepositpry();

  // いいね順
  final _trendPostsController = StreamController<List<PostModel>>.broadcast();
  Stream<List<PostModel>> get getPostsList => _trendPostsController.stream;
  // 最新順
  final _newPostsController = StreamController<List<PostModel>>.broadcast();
  Stream<List<PostModel>> get newPostsList => _newPostsController.stream;

  // コンストラクタ
  PostsBloc() {
    getTrendPostsList();
    getNewPostsList();
  }

  void getTrendPostsList() async {
    List<PostModel> _postModel = await _postRepository.getTrendPosts();
    _trendPostsController.sink.add(_postModel);
  }

  void getNewPostsList() async {
    List<PostModel> _postModel = await _postRepository.getNewPosts();
    _newPostsController.sink.add(_postModel);
  }

  void dispose() {
    _trendPostsController.close();
    _newPostsController.close();
  }
}
