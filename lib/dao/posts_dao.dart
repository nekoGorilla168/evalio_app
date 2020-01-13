import 'package:cloud_firestore/cloud_firestore.dart';

class PostsDao {
  // ルートコレクション取得
  final fs = Firestore.instance.collection("posts");

  // 投稿ポートフォリオ取得(最大10件まで)
  Future<List<DocumentSnapshot>> getPostsList() async {
    QuerySnapshot qs = await fs.limit(10).getDocuments();
    return qs.documents;
  }
}
