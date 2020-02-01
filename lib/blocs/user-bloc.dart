import 'dart:async';

import 'package:evalio_app/models/user_model.dart';
import 'package:evalio_app/repository/base_auth_repository.dart';
import 'package:evalio_app/repository/users_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc {
  // リポジトリークラス
  final _authRepository = AuthRepository();
  // ユーザーリポジトリクラス
  final _userRepositpry = UserRepository();

  // ユーザー情報
  final _userController = StreamController<UserModelDoc>.broadcast();
  Stream<UserModelDoc> get getUser => _userController.stream;
  // ユーザーId
  final _idController = StreamController<String>.broadcast();
  Stream<String> get getIds => _idController.stream;

  // ユーザーID保持
  String _id = "";
  String get getId => _id;

  // このユーザーの投稿Id取得
  String _postId;
  String get getPostId => _postId;

  // Sttream形式ではないユーザー情報
  UserModelDoc _userModelDoc;
  UserModelDoc get getUserDoc => _userModelDoc;

  // Twitterへのリンク
  String _twitterLink;
  String get getTwitterLink => _twitterLink;
  // 自己紹介
  String _introducation;
  String get getIntroducation => _introducation;
  // 興味関心
  String _interest;
  String get getInterest => _interest;

  // お気に入りのリスト
  List<String> _myFavorites;
  List<String> get getMyFavorites => _myFavorites;

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
    if (userModelDoc != null) _userController.sink.add(userModelDoc);
    _userModelDoc = userModelDoc;
    _myFavorites = userModelDoc.userModel.likedPost.cast<String>();
    if (userModelDoc.postModelDoc != null) {
      _postId = userModelDoc.postModelDoc.postId;
    }
  }

  // ユーザープロフィールを更新する
  void updateUserProfile(String userId, String introducation, String interest) {
    _userRepositpry.updateUser(userId, introducation, interest);
    getUserInfo(userId);
  }

  // ユーザーIDをセットする
  void setUserId(String userId) {
    _id = userId;
  }

  // Twitterリンクをセットする
  void setTwitterLink(String link) {
    _twitterLink = link;
  }

  // 自己紹介をセットする
  void setIntroducation(String introducation) {
    _introducation = introducation;
  }

  // 興味関心をセットする
  void setInterest(String interst) {
    _interest = interst;
  }

  // コントローラーの破棄
  void dispose() {
    _idController.close();
    _userController.close();
  }
}
