import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/dao/user-dao.dart';
import 'package:evalio_app/firebase/firebase_auth.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final userDao = UserDao();
  final fireAuth = FireAuth();

  // 新規登録
  Future insertUser(UserModel userModel) => userDao.insertUserInfo(userModel);

  // ユーザー情報取得
  Future getUser(String userId) async {
    DocumentSnapshot doc = await userDao.getUserInfo(userId);
    return UserModel.fromMap(doc.data);
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
