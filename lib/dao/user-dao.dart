import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/models/user_model.dart';

class UserDao {
  // ルートコレクション
  final fsUser = Firestore.instance.collection("users");
  final fsPosts = Firestore.instance.collection("posts");

  // ユーザー登録状態チェック
  Future<bool> checkRegisteredUser(String id) async {
    bool isExist = false;

    DocumentSnapshot doc = await fsUser.document(id).get();
    if (doc.data.length != 0) {
      isExist = true;
    }
    return isExist;
  }

  // ユーザー情報新規登録
  insertUserInfo(UserModel userModel) {
    fsUser.document(userModel.userId).setData({
      UserModelField.userName: userModel.userName,
      UserModelField.photoUrl: userModel.photoUrl,
      UserModelField.profile: {
        UserModelField.interest: null,
        UserModelField.selfIntroducation: null
      },
      UserModelField.likedPost: [],
      UserModelField.twitterLink: null,
      UserModelField.createdAt: new DateTime.now()
    });
  }

  // ユーザー情報更新
  void updateUserInfo(UserModel userModel) {}

  // ユーザープロフィール更新
  void updateProfile(String userId, Map<String, String> profile) {
    fsUser.document(userId).updateData({
      UserModelField.profile: {
        UserModelField.interest: profile[UserModelField.interest],
        UserModelField.selfIntroducation:
            profile[UserModelField.selfIntroducation],
      }
    });
  }

// ユーザー情報取得
  Future<DocumentSnapshot> getUserInfo(String userId) async {
    DocumentSnapshot doc = await fsUser.document(userId).get();
    return doc;
  }

  // ユーザー情報取得(名前)
  Future<List<DocumentSnapshot>> getUserInfoByName(String userName) async {
    QuerySnapshot qs = await fsUser
        .where(UserModelField.userName, isEqualTo: userName)
        .getDocuments();
    return qs.documents;
  }

  // ポートフォリオを削除する
  void deleteAllData(String userId, String postId) async {
    fsPosts.document(postId).delete();
    fsUser.document(userId).collection(postId).document().delete();
    fsUser.document(userId).delete();
  }
}
