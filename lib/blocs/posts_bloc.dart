import 'dart:async';

import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/repository/posts_repository.dart';

class PostsBloc {
  // 投稿リストリポジトリ
  final _postRepository = PostsRepositpry();

  final _allPostsController = StreamController<List<PostModel>>.broadcast();

  Stream<List<PostModel>> get getPostsList => _allPostsController.stream;

  // コンストラクタ
  PostsBloc() {
    getPosts();
  }

  void getPosts() async {
    List<PostModel> _postModel = await _postRepository.getPosts();
    _allPostsController.sink.add(_postModel);
  }

  void dispose() {
    _allPostsController.close();
  }
}
