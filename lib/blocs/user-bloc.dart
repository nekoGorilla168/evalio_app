import 'dart:async';

import 'package:evalio_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserBloc {
  // リポジトリークラス
  //final _authRepository = AuthRepository();
  // ユーザーモデルクラス
  UserModel userModel;

  final _userController = StreamController<UserModel>.broadcast();

  Stream<UserModel> get getUser => _userController.stream;

  // ユーザー情報の作成
  void createFUser(FirebaseUser user) {
    userModel = new UserModel(
      userId: user.uid,
      userName: user.displayName,
      isAnonymous: user.isAnonymous,
      photoUrl: user.photoUrl,
    );
    _userController.sink.add(userModel);
  }

  void dispose() {
    _userController.close();
  }
}
