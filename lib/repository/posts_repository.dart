import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/dao/posts_dao.dart';
import 'package:evalio_app/models/posts_model.dart';

class PostsRepositpry {
  final _postDao = PostsDao();

  // トレンド
  Future<List<PostModelDoc>> getTrendPosts() async {
    List<DocumentSnapshot> _docs = await _postDao.getTrendPostsList();
    List<PostModelDoc> posts;
    if (_docs != null) {
      posts = _docs
          .map((doc) =>
              PostModelDoc(doc.documentID, PostModel.fromMap(doc.data)))
          .toList();
      return posts;
    } else {
      return posts;
    }
  }

  // 最新
  Future<List<PostModelDoc>> getNewPosts() async {
    List<DocumentSnapshot> _docs = await _postDao.getNewPostsList();
    List<PostModelDoc> posts;
    if (_docs != null) {
      posts = _docs
          .map((doc) =>
              PostModelDoc(doc.documentID, PostModel.fromMap(doc.data)))
          .toList();
      return posts;
    } else {
      return posts;
    }
  }
}
