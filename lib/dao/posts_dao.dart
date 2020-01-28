import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:uuid/uuid.dart';

class PostsDao {
  // ルートコレクション取得
  final fsPosts = Firestore.instance.collection("posts");

  final fsUsers = Firestore.instance.collection("users");

  // バッチ処理用
  final batch = Firestore.instance.batch();
  // 最大10件
  final int maxKensu = 10;

  // いいね数順取得(上限10件)
  Future<List<DocumentSnapshot>> getTrendPostsList() async {
    QuerySnapshot qs = await fsPosts
        .orderBy("likesCount", descending: true)
        .limit(maxKensu)
        .getDocuments();
    return qs.documents;
  }

  // 最新順取得
  Future<List<DocumentSnapshot>> getNewPostsList() async {
    QuerySnapshot qs = await fsPosts
        .orderBy("createdAt", descending: true)
        .limit(maxKensu)
        .getDocuments();
    return qs.documents;
  }

  // ログインユーザーのポートフォリオを取得
  Future<DocumentSnapshot> getMyPortfolio(String userId) async {
    QuerySnapshot qs;
    await fsUsers
        .document(userId)
        .collection("post")
        .getDocuments()
        .then((docData) => qs = docData)
        .catchError((error) => qs = error);

    if (qs.documents.length == 0) return null;
    return qs.documents[0];
  }

  // ポートフォリオを登録する
  insertPortfolio(PostModelDoc postModelDoc, String userId) {
    if (postModelDoc.postId == null) {
      // uuid生成
      var uuid = Uuid();
      // ドキュメントID用のユニークなID
      String portfolioId = uuid.v1();

      // ポートフォリオ新規登録
      var newPortfolio = fsPosts.document(portfolioId);
      batch.setData(newPortfolio, {
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
        PostModelField.postUserIdRef: userId,
        PostModelField.likesCount: postModelDoc.postModel.likesCount,
        PostModelField.createdAt: FieldValueType.serverTimestamp,
      });
      // ユーザー側にも同じ内容を書き込み
      // userのサブコレクションに追加
      newPortfolio =
          fsUsers.document(userId).collection("post").document(portfolioId);
      batch.setData(newPortfolio, {
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
        PostModelField.postUserIdRef: userId,
        PostModelField.likesCount: postModelDoc.postModel.likesCount,
        PostModelField.createdAt: FieldValueType.serverTimestamp,
      });
      // バッチ処理
      batch.commit();
    } else {
      // ポートフォリオ更新
      fsPosts.document(postModelDoc.postId).setData({
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
        PostModelField.postUserIdRef: userId,
        PostModelField.likesCount: postModelDoc.postModel.likesCount,
        PostModelField.updatedAt: FieldValueType.serverTimestamp,
      }, merge: true);
    }
  }
}
