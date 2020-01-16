import 'package:evalio_app/dao/user-dao.dart';
import 'package:evalio_app/firebase/firebase_auth.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final userDao = UserDao();
  final fireAuth = FireAuth();

  Future insertUser(UserModel userModel) => userDao.insertUserInfo(userModel);

  Future getFromFirebaseAuth() async {
    FirebaseUser fireUser = await fireAuth.signInTwitter();
    return new UserModel(
        userId: fireUser.uid,
        userName: fireUser.displayName,
        photoUrl: fireUser.photoUrl);
  }
}
