// ユーザー情報データ構造
import 'package:evalio_app/models/posts_model.dart';

class UserModelDoc {
  String userId;
  UserModel userModel;
  PostModelDoc postModelDoc;
  // コンストラクタ(ポートフォリオ未投稿ならPostModelDocはインスタンス化しない)
  UserModelDoc(this.userId, this.userModel, [this.postModelDoc]);
}

// ユーザー情報クラス
class UserModel {
  String userId; // ユーザーID
  String userName; // ユーザー名(Twitter DisplayName)
  String photoUrl; // ユーザーのプロフ写真URL
  List likedPost = []; // いいねしたポートフォリオ
  Map profile;
  String twitterLink; // Twitterへのリンク
  DateTime createdAt; // 作成日
  DateTime updatedAt; // 更新日

  // コンストラクタ
  UserModel({
    this.userId,
    this.userName,
    this.photoUrl,
  });

  // 名前付きコンストラクタ
  UserModel.fromMap(Map map) {
    this.userId = map[UserModelField.userId];
    this.userName = map[UserModelField.userName];
    this.photoUrl = map[UserModelField.photoUrl];
  }

  // 名前付きコンストラクタ
  UserModel.fromFire(Map map) {
    this.userName = map[UserModelField.userName];
    this.photoUrl = map[UserModelField.photoUrl];
    this.likedPost = map[UserModelField.likedPost];
    this.twitterLink = map[UserModelField.twitterLink];
    this.profile = map[UserModelField.profile];
  }

  // Firestore登録時変換用
  Map<String, Object> toMap() {
    return {
      UserModelField.userId: this.userId,
      UserModelField.userName: this.userName,
      UserModelField.photoUrl: this.photoUrl,
      UserModelField.likedPost: this.likedPost,
      UserModelField.updatedAt: this.updatedAt,
    };
  }
}

// フィールド名クラス
class UserModelField {
  static const userId = "userId";
  static const userName = "userName";
  static const photoUrl = "photoUrl";
  static const profile = "profile";
  static const selfIntroducation = "selfIntroducation";
  static const interest = "interest";
  static const twitterLink = "twitterLink";
  static const likedPost = "likedPost";
  static const updatedAt = "updatedAt";
  static const createdAt = "createdAt";
  static const likedPortfolioIdList = "likedPortfolioIdList";
}
