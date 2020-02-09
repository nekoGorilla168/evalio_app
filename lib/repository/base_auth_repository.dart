import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/dao/posts_dao.dart';
import 'package:evalio_app/dao/user_dao.dart';
import 'package:evalio_app/firebase/firebase_auth.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final userDao = UserDao();
  final postDao = PostsDao();
  final fireAuth = FireAuth();

  // 新規登録
  Future insertUser(UserModel userModel) => userDao.insertUserInfo(userModel);

  // ログインしたことがあるか検証
  Future<bool> checkLoginRireki(String userId) async {
    bool isLogin = await userDao.checkRegisteredUser(userId);
    return isLogin;
  }

  // ユーザー情報取得
  Future getUser(String userId) async {
    Future<DocumentSnapshot> futureUserDoc = userDao.getUserInfo(userId);
    Future<DocumentSnapshot> futurePostDoc = postDao.getMyPortfolio(userId);
    await Future.wait([futureUserDoc, futurePostDoc]);
    DocumentSnapshot userDoc = await futureUserDoc;
    DocumentSnapshot postDoc = await futurePostDoc;
    return postDoc != null
        ? UserModelDoc(userDoc.documentID, UserModel.fromFire(userDoc.data),
            PostModelDoc(postDoc.documentID, PostModel.fromMap(postDoc.data)))
        : UserModelDoc(userDoc.documentID, UserModel.fromFire(userDoc.data));
  }

  // FireAuthよりユーザー情報取得
  Future<UserModel> getFromFirebaseAuth() async {
    Future<UserModel> userModel = fireAuth.signInTwitter().then((userInfo) {
      UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
      String userName;
      String photoUrl;
      for (UserInfo data in userInfo.providerData) {
        userName = data.displayName;
        photoUrl = data.photoUrl;
      }
      userUpdateInfo.displayName = userName;
      userUpdateInfo.photoUrl = photoUrl;
      return new UserModel(
          userId: userInfo.uid, userName: userName, photoUrl: photoUrl);
    });
    return userModel;
  }
}
