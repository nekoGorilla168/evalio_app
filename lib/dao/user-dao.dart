import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/models/user_model.dart';

class UserDao {
  // ルートコレクション
  var fs = Firestore.instance.collection("users");

  // ユーザー登録状態チェック
  Future<bool> checkRegisteredUser(String id) async {
    bool isExist = false;

    DocumentSnapshot doc = await fs.document(id).get();
    if (doc.data.length != 0) {
      isExist = true;
    }
    return isExist;
  }

  // ユーザー情報新規登録
  insertUserInfo(UserModel userModel) {
    fs.document(userModel.userId).setData({
      UserModelField.userName: userModel.userName,
      UserModelField.photoUrl: userModel.photoUrl,
      "profile": {"interest": null, "selfIntroducation": null},
      "likedPosts": [],
      "post": null,
      UserModelField.createdAt: new DateTime.now()
    });
  }

  // ユーザー情報更新
  void updateUserInfo(UserModel userModel) {}

// ユーザー情報取得
  Future<DocumentSnapshot> getUserInfo(String userId) async {
    DocumentSnapshot doc = await fs.document(userId).get();
    return doc;
  }
}
