import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/dao/posts_dao.dart';
import 'package:evalio_app/dao/user-dao.dart';
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
    DocumentSnapshot userDoc = await userDao.getUserInfo(userId);
    DocumentSnapshot postDoc = await postDao.getMyPortfolio(userId);
    return postDoc != null
        ? UserModelDoc(userDoc.documentID, UserModel.fromFire(userDoc.data),
            PostModelDoc(postDoc.documentID, PostModel.fromMap(postDoc.data)))
        : UserModelDoc(userDoc.documentID, UserModel.fromFire(userDoc.data));
  }

  // FireAuthよりユーザー情報取得
  Future getFromFirebaseAuth() async {
    FirebaseUser fireUser = await fireAuth.signInTwitter();
    return new UserModel(
        userId: fireUser.uid,
        userName: fireUser.displayName,
        photoUrl: fireUser.photoUrl);
  }
}
