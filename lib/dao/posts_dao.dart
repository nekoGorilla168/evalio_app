import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/models/user_model.dart';
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
    // ユーザーIDへの参照
    var userRef = fsUsers.document(userId);

    if (postModelDoc.postId == null) {
      // uuid生成
      var uuid = Uuid();
      // ドキュメントID用のユニークなID
      String portfolioId = uuid.v1();
      //
      var createDate = DateTime.now();
      // ポートフォリオ新規登録
      var newPortfolio = fsPosts.document(portfolioId);
      batch.setData(newPortfolio, {
        PostModelField.content: {
          PostModelField.title: postModelDoc.postModel.title,
          PostModelField.portfolioUrl: postModelDoc.postModel.portfolioUrl,
          PostModelField.imageUrl: postModelDoc.postModel.imageUrl,
          PostModelField.overview: postModelDoc.postModel.overview,
          PostModelField.programmingLanguage:
              postModelDoc.postModel.programmingLanguage,
          PostModelField.details: postModelDoc.postModel.details,
        },
        PostModelField.programmingLanguage:
            postModelDoc.postModel.programmingLanguage,
        PostModelField.postUserIdRef: userRef,
        PostModelField.likesCount: postModelDoc.postModel.likesCount,
        PostModelField.createdAt: createDate,
      });
      // ユーザー側にも同じ内容を書き込み
      // userのサブコレクションに追加
      newPortfolio =
          fsUsers.document(userId).collection("post").document(portfolioId);
      batch.setData(newPortfolio, {
        PostModelField.content: {
          PostModelField.title: postModelDoc.postModel.title,
          PostModelField.imageUrl: postModelDoc.postModel.imageUrl,
          PostModelField.portfolioUrl: postModelDoc.postModel.portfolioUrl,
          PostModelField.overview: postModelDoc.postModel.overview,
          PostModelField.programmingLanguage:
              postModelDoc.postModel.programmingLanguage,
          PostModelField.details: postModelDoc.postModel.details,
        },
        PostModelField.programmingLanguage:
            postModelDoc.postModel.programmingLanguage,
        PostModelField.postUserIdRef: userRef,
        PostModelField.likesCount: postModelDoc.postModel.likesCount,
        PostModelField.createdAt: createDate,
      });
      // バッチ処理
      batch.commit();
    } else {
      var updateDate = DateTime.now();

      // ポートフォリオ更新
      var updatePortfolio = fsPosts.document(postModelDoc.postId);
      batch.setData(
          updatePortfolio,
          {
            PostModelField.content: {
              PostModelField.title: postModelDoc.postModel.title,
              PostModelField.imageUrl: postModelDoc.postModel.imageUrl,
              PostModelField.portfolioUrl: postModelDoc.postModel.portfolioUrl,
              PostModelField.overview: postModelDoc.postModel.overview,
              PostModelField.programmingLanguage:
                  postModelDoc.postModel.programmingLanguage,
              PostModelField.details: postModelDoc.postModel.details,
            },
            PostModelField.programmingLanguage:
                postModelDoc.postModel.programmingLanguage,
            PostModelField.postUserIdRef: userRef,
            PostModelField.likesCount: postModelDoc.postModel.likesCount,
            PostModelField.updatedAt: updateDate,
          },
          merge: true);
      updatePortfolio = fsUsers
          .document(userId)
          .collection("post")
          .document(postModelDoc.postId);
      batch.setData(
          updatePortfolio,
          {
            PostModelField.content: {
              PostModelField.title: postModelDoc.postModel.title,
              PostModelField.imageUrl: postModelDoc.postModel.imageUrl,
              PostModelField.portfolioUrl: postModelDoc.postModel.portfolioUrl,
              PostModelField.overview: postModelDoc.postModel.overview,
              PostModelField.programmingLanguage:
                  postModelDoc.postModel.programmingLanguage,
              PostModelField.details: postModelDoc.postModel.details,
            },
            PostModelField.programmingLanguage:
                postModelDoc.postModel.programmingLanguage,
            PostModelField.postUserIdRef: userRef,
            PostModelField.likesCount: postModelDoc.postModel.likesCount,
            PostModelField.updatedAt: updateDate,
          },
          merge: true);
      batch.commit();
    }
  }

  // いいねをカウントし、お気に入りに追加する
  void addLikesCount(String postId, String userId) {
    var postRef = fsPosts.document(postId);

    Firestore.instance.runTransaction((t) {
      return t.get(postRef).then((doc) {
        if (doc.exists)
          t.update(postRef, <String, dynamic>{
            PostModelField.likesCount: doc.data[PostModelField.likesCount] + 1
          }).then((value) {
            // いいねの追加が成功した場合、自分のお気に入りにも追加する
            fsUsers.document(userId).updateData(<String, dynamic>{
              UserModelField.likedPost: FieldValue.arrayUnion([postId])
            });
          });
      });
    });
  }
}
