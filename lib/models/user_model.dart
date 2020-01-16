// ユーザー情報クラス
class UserModel {
  String userId; // ユーザーID
  String userName; // ユーザー名(Twitter DisplayName)
  String photoUrl; // ユーザーのプロフ写真URL
  List likedPortfolio; // いいねしたポートフォリオ
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

  // Firestore登録時変換用
  Map<String, Object> toMap() {
    return {
      UserModelField.userId: this.userId,
      UserModelField.userName: this.userName,
      UserModelField.photoUrl: this.photoUrl,
      UserModelField.likedPortfolio: this.likedPortfolio,
      UserModelField.updatedAt: this.updatedAt,
    };
  }
}

class UserModelField {
  static const userId = "userId";
  static const userName = "userName";
  static const photoUrl = "photoUrl";
  static const likedPortfolio = "likedPortfolio";
  static const updatedAt = "updatedAt";
  static const createdAt = "createdAt";
  static const likedPortfolioIdList = "likedPortfolioIdList";
}
