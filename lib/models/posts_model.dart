// 投稿内容のモデルクラス

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/models/user_model.dart';

// ポートフォリオIDとフィールドのクラス
class PostModelDoc {
  String postId; // 投稿者id
  PostModel postModel; // フィールド
  UserModelDoc userModelDocRef; // ユーザーモデル

  // コンストラクタ
  PostModelDoc(this.postId, this.postModel, [this.userModelDocRef]);
}

// フィールドのデータ構造クラス
class PostModel {
  String postId; // ポートフォリオID
  String postUserId; // 投稿者ID
  String portfolioUrl; // ポートフォリオURL
  String title; // ポートフォリオタイトル
  String theme; // ポートフォリオ詳細
  int likesCount = 0; // お気に入りにされた数
  List programmingLanguage; // 使用技術
  DateTime createdAt; // 投稿日
  DateTime updatedAt; // 更新日
  Map content; // 投稿内容
  Map postUserInfo; // 投稿したユーザー情報
  String imageUrl; // サムネイル画像ダウンロードURL
  String overview; // アプリケーションの概要
  String details; // アプリケーションの詳細

  // コンストラクタ
  PostModel(
      {this.title,
      this.programmingLanguage,
      this.imageUrl,
      this.portfolioUrl,
      this.overview,
      this.details});

  // 名前付きコンストラクタ
  PostModel.fromMap(Map map) {
    this.postId = map[PostModelField.postId];
    this.content = map[PostModelField.content];
    this.likesCount = map[PostModelField.likesCount];
    //日付変換
    // 登録日
    var createDate = map[PostModelField.createdAt];
    if (createDate is Timestamp) {
      this.createdAt = createDate.toDate();
    }
    // 更新日
    var updateDate = map[PostModelField.updatedAt];
    if (updateDate is Timestamp) {
      this.updatedAt = updateDate.toDate();
    }
  }
}

// FireStoreのフィールド名
class PostModelField {
  static const postId = "postId";
  static const postUserIdRef = "postUserIdRef";
  static const content = "content";
  static const title = "title";
  static const overview = "overview";
  static const details = "details";
  static const portfolioUrl = "portfolioUrl";
  static const portfolioPhotoData = "portfolioPhotoData";
  static const likesCount = "likesCount";
  static const createdAt = "createdAt";
  static const updatedAt = "updatedAt";
  static const imageUrl = "imageUrl";
  static const programmingLanguage = "programmingLanguage";
}
