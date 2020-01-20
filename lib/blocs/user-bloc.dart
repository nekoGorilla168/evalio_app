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

  // 新規登録
  void shinkiToroku(UserModel userModel) async {
    await _authRepository.insertUser(userModel);
    getUserInfo(userModel.userId);
    // ローカルストレージに保存
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DotEnv().env['TWITTER_REGISTERED'], userModel.userId);
  }

  // ユーザー情報取得
  void getUserInfo(String userId) async {
    UserModel userModel = await _authRepository.getUser(userId);
    _userController.sink.add(userModel);
  }

  void dispose() {
    _idController.close();
    _userController.close();
  }
}
