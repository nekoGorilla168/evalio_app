import 'package:cloud_firestore/cloud_firestore.dart';

class PostsDao {
  // ルートコレクション取得
  final fs = Firestore.instance.collection("posts");
  final int maxKensu = 10;

  // いいね数順取得(上限10件)
  Future<List<DocumentSnapshot>> getTrendPostsList() async {
    QuerySnapshot qs = await fs
        .orderBy("likesCount", descending: true)
        .limit(maxKensu)
        .getDocuments();
    return qs.documents;
  }

  // 最新順取得
  Future<List<DocumentSnapshot>> getNewPostsList() async {
    QuerySnapshot qs = await fs
        .orderBy("createdAt", descending: true)
        .limit(maxKensu)
        .getDocuments();
    return qs.documents;
  }
}
