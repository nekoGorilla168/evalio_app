import 'dart:async';

import 'package:evalio_app/models/user_model.dart';
import 'package:evalio_app/repository/base_auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc {
  // リポジトリークラス
  final _authRepository = AuthRepository();

  // ユーザー情報
  final _userController = StreamController<UserModelDoc>.broadcast();
  Stream<UserModelDoc> get getUser => _userController.stream;
  // ユーザーId
  final _idController = StreamController<String>.broadcast();
  Stream<String> get getIds => _idController.stream;

  // ユーザーID保持
  String _id = "";
  String get getId => _id;

  // Sttream形式ではないユーザー情報
  UserModelDoc _userModelDoc;
  UserModelDoc get getUserDoc => _userModelDoc;

  // コンストラクタ
  UserBloc() {
    checkLoggedIn();
  }

  // ローカルストレージチェック
  void checkLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString(DotEnv().env['TWITTER_REGISTERED']);
    _id = id;
    _idController.sink.add(id);
  }

  // 新規登録
  void shinkiToroku(UserModel userModel) async {
    await _authRepository.insertUser(userModel);
    // 登録後ユーザー情報取得
    getUserInfo(userModel.userId);
    // ローカルストレージに保存
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DotEnv().env['TWITTER_REGISTERED'], userModel.userId);
  }

  // ユーザー情報取得
  void getUserInfo(String userId) async {
    UserModelDoc userModelDoc = await _authRepository.getUser(userId);
    _userController.sink.add(userModelDoc);
    _userModelDoc = userModelDoc;
  }

  // ユーザーIDをセットする
  void setUserId(String userId) {
    _id = userId;
  }

  // コントローラーの破棄
  void dispose() {
    _idController.close();
    _userController.close();
  }
}
