import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/dao/posts_dao.dart';
import 'package:evalio_app/dao/user-dao.dart';
import 'package:evalio_app/firebase/firebase_storage.dart';
import 'package:evalio_app/models/user_model.dart';

class UserRepository {
  final _fireStorage = FireStorage();

  final _userDao = UserDao();
  final _postDao = PostsDao();

  // ユーザープロフィール
  updateUser(String userId, String introducation, String interest,
      String twitterLink) {
    Map<String, String> profile = {
      UserModelField.selfIntroducation: introducation,
      UserModelField.interest: interest,
      UserModelField.twitterLink: twitterLink,
    };
    _userDao.updateProfile(userId, profile);
  }

  // お気に入りのリストを更新する
  Future<List<String>> getMyFavoriteList(String userId) async {
    DocumentSnapshot doc = await _userDao.getUserInfo(userId);
    List<String> likedPost;
    if (doc != null) {
      likedPost = doc.data[UserModelField.likedPost].cast<String>();
    }
    return likedPost;
  }

  // 全てのデータを削除する
  void deleteAllData(String userId, String postId, String imageName) {
    _fireStorage.deleteImageFolder(userId, imageName);
    _userDao.deleteAllData(userId, postId);
  }
}
