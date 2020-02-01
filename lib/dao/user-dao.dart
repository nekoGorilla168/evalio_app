import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/models/user_model.dart';

class UserDao {
  // ルートコレクション
  final fsUser = Firestore.instance.collection("users");

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
      "profile": {"interest": null, "selfIntroducation": null},
      "likedPost": [],
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
}
