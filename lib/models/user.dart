// ユーザー情報クラス
class CurrentUser {
  final String userId; // ユーザーID
  final String userName; // ユーザー名(Twitter DisplayName)
  final String photoUrl; // ユーザーのプロフ写真URL
  final bool isAnonymous; //

  CurrentUser({
    this.userId,
    this.userName,
    this.photoUrl,
    this.isAnonymous,
  });
}
