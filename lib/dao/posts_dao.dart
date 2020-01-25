import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/models/posts_model.dart';

class PostsDao {
  // ルートコレクション取得
  final fs = Firestore.instance.collection("posts");
  final int maxKensu = 10; // 最大10件

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

  // ポートフォリオを登録する
  insertPortfolio(String userId, PostModelDoc postModelDoc) {
    var _userRef = Firestore.instance.collection("users").document(userId);

    if (postModelDoc.postId == null) {
      // ポートフォリオ新規登録
      fs.document().setData({
        PostModelField.content: {
          PostModelField.title: postModelDoc.postModel.title,
          PostModelField.portfolioUrl: postModelDoc.postModel.portfolioUrl,
          PostModelField.overview: postModelDoc.postModel.overview,
          PostModelField.programmingLanguage:
              postModelDoc.postModel.programmingLanguage,
          PostModelField.details: postModelDoc.postModel.details,
        },
        PostModelField.programmingLanguage:
            postModelDoc.postModel.programmingLanguage,
        PostModelField.postUserIdRef: _userRef,
        PostModelField.likesCount: postModelDoc.postModel.likesCount,
        PostModelField.createdAt: new DateTime.now(),
      });
    } else {
      // ポートフォリオ更新
      fs.document(postModelDoc.postId).setData({
        PostModelField.content: {
          PostModelField.title: postModelDoc.postModel.title,
          PostModelField.portfolioUrl: postModelDoc.postModel.portfolioUrl,
          PostModelField.overview: postModelDoc.postModel.overview,
          PostModelField.programmingLanguage:
              postModelDoc.postModel.programmingLanguage,
          PostModelField.details: postModelDoc.postModel.details,
        },
        PostModelField.programmingLanguage:
            postModelDoc.postModel.programmingLanguage,
        PostModelField.postUserIdRef: _userRef,
        PostModelField.likesCount: postModelDoc.postModel.likesCount,
        PostModelField.updatedAt: new DateTime.now(),
      }, merge: true);
    }
  }
}
