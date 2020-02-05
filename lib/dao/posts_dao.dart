import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

class PostsDao {
  // ルートコレクション取得
  final fsPosts = Firestore.instance.collection("posts");

  final fsUsers = Firestore.instance.collection("users");

  // 最大10件
  final int maxKensu = 10;

  // 開始日(2日前)
  final startDate = DateTime.now().subtract(new Duration(days: 2));
  // 終了日
  final endDate = DateTime.now();

  // いいね数順取得(上限10件)
  // 指定範囲は過去2日間の間
  Future<List<DocumentSnapshot>> getTrendPostsList() async {
    QuerySnapshot qs = await fsPosts
        .where(PostModelField.createdAt, isGreaterThanOrEqualTo: startDate)
        .where(PostModelField.createdAt, isLessThanOrEqualTo: endDate)
        .orderBy(PostModelField.createdAt, descending: true)
        .limit(maxKensu)
        .getDocuments();
    return qs.documents;
  }

  // 最新順取得(上限10件)
  Future<List<DocumentSnapshot>> getNewPostsList() async {
    QuerySnapshot qs = await fsPosts
        .orderBy(PostModelField.createdAt, descending: true)
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

  // プログラミング言語から取得
  Future<List<DocumentSnapshot>> getPortfolioByLanguages(
      List<String> langKey) async {
    QuerySnapshot qs = await fsPosts
        .where(
            '${PostModelField.content}.${PostModelField.programmingLanguage}',
            arrayContainsAny: langKey)
        .getDocuments();
    return qs.documents;
  }

  // postIDから取得
  Future<DocumentSnapshot> getPortfolioById(String postId) async {
    DocumentSnapshot doc = await fsPosts.document(postId).get();
    return doc;
  }

  // ポートフォリオを登録する
  void insertPortfolio(PostModelDoc postModelDoc, String userId) async {
    // ユーザーIDへの参照
    var userRef = fsUsers.document(userId);
    // バッチ処理用
    var batch = Firestore.instance.batch();

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
          PostModelField.imageName: postModelDoc.postModel.imageName,
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
          PostModelField.imageName: postModelDoc.postModel.imageName,
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
              PostModelField.imageName: postModelDoc.postModel.imageName,
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
              PostModelField.imageName: postModelDoc.postModel.imageName,
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

  // サブコレクションにユーザーIDを追加し、お気に入り機能を実装する
  Future<List<DocumentSnapshot>> addLikesCollection(
      String postId, String userId) async {
    fsPosts
        .document(postId)
        .collection('likesCount')
        .document(userId)
        .setData({'id': userId}, merge: true);
    QuerySnapshot qs =
        await fsPosts.document(postId).collection('likesCount').getDocuments();
    return qs.documents;
  }

  // サブコレクションにユーザーIDを追加し、お気に入り機能を実装する
  Future<List<DocumentSnapshot>> removeLikesCollection(
      String postId, String userId) async {
    fsPosts.document(postId).collection('likesCount').document().setData({
      PostModelField.likesCount: FieldValue.arrayUnion([userId])
    }, merge: true);
  }

  // いいねをカウントし、お気に入りに追加・削除する
  Future<int> addLikesCount(String postId, String userId) async {
    // バッチ処理用
    var batch = Firestore.instance.batch();
    // true: 追加
    // false: 削除
    int isAdd = -1;
    var postRef = fsPosts.document(postId);
    var userRef = fsUsers.document(userId);
    DocumentSnapshot doc = await userRef.get();
    List likedPost = await doc.data[UserModelField.likedPost];

    // 登録処理
    if (likedPost.contains(postId) == false) {
      batch.updateData(
          postRef, {PostModelField.likesCount: FieldValue.increment(1)});
      batch.updateData(userRef, {
        UserModelField.likedPost: FieldValue.arrayUnion([postId])
      });
      batch.commit();
      isAdd = 1;
      return isAdd;
    } else {
      batch.updateData(
          postRef, {PostModelField.likesCount: FieldValue.increment(-1)});
      batch.updateData(userRef, {
        UserModelField.likedPost: FieldValue.arrayRemove([postId])
      });
      batch.commit();
      isAdd = 0;
      return isAdd;
    }
  }

  // ポートフォリオを削除する
  void deleteMyPortfolio(String userId, String postId) {
    fsPosts.document(postId).delete();
    fsUsers.document(userId).collection(postId).document().delete();
  }
}
