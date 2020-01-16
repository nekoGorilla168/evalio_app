import 'dart:async';

import 'package:evalio_app/models/user_model.dart';
import 'package:evalio_app/repository/base_auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc {
  // リポジトリークラス
  final _authRepository = AuthRepository();

  final _userController = StreamController<UserModel>.broadcast();

  final _idController = StreamController<String>.broadcast();

  Stream<UserModel> get getUser => _userController.stream;

  Stream<String> get getId => _idController.stream;

  // ユーザー情報の作成
//  void createFUser(FirebaseUser user) {
//    var userModel = new UserModel(
//      userId: user.uid,
//      userName: user.displayName,
//      photoUrl: user.photoUrl,
//    );
//    _userController.sink.add(userModel);
//  }

  // コンストラクタ
  UserBloc() {
    checkLoggedIn();
  }

  // ローカルストレージチェック
  void checkLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _id = preferences.getString(DotEnv().env['TWITTER_REGISTERED']);
    _idController.sink.add(_id);
  }

  void getLoginUser() async {
    UserModel userModel = await _authRepository.getFromFirebaseAuth();
    _userController.sink.add(userModel);
  }

  void dispose() {
    _idController.close();
    _userController.close();
  }
}
