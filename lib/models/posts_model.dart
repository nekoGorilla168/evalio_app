// 投稿内容のモデルクラス

import 'package:cloud_firestore/cloud_firestore.dart';

// ポートフォリオIDとフィールドのクラス
class PostModelDoc {
  String postId; // 投稿者id
  PostModel postModel; // フィールド

  // コンストラクタ
  PostModelDoc(this.postId, this.postModel);
}

// フィールドのデータ構造クラス
class PostModel {
  String postId; // ポートフォリオID
  String postUserId; // 投稿者ID
  String portfolioUrl; // ポートフォリオURL
  String title; // ポートフォリオタイトル
  String theme; // ポートフォリオ詳細
  int likesCount; // お気に入りにされた数
  List programmingLanguage; // 使用技術
  DateTime createdAt; // 投稿日
  DateTime updatedAt; // 更新日
  //UserModel userModel; // 投稿したユーザーのモデルクラス
  Map content; // 投稿内容
  String overview;
  String details;

  // コンストラクタ
  PostModel();
  // 名前付きコンストラクタ
  PostModel.fromMap(Map map) {
    this.postId = map[PostModelField.postId];
    //this.postUserId = map[PostModelField.postUserId];
    this.programmingLanguage = map[PostModelField.programmingLanguage];
    this.content = map[PostModelField.content];
    this.title = map[PostModelField.title];
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

  static const programmingLanguage = "programmingLanguage";
}
