import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/dao/posts_dao.dart';
import 'package:evalio_app/models/posts_model.dart';

class PostsRepositpry {
  final _postDao = PostsDao();

  Future<List<PostModel>> getPosts() async {
    List<DocumentSnapshot> _docs = await _postDao.getPostsList();
    List<PostModel> posts;
    if (_docs != null) {
      posts = _docs.map((doc) => PostModel.fromMap(doc.data)).toList();
      return posts;
    } else {
      return posts;
    }
  }
}
