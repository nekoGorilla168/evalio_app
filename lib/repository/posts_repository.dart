import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evalio_app/dao/posts_dao.dart';
import 'package:evalio_app/dao/user-dao.dart';
import 'package:evalio_app/firebase/firebase_storage.dart';
import 'package:evalio_app/models/const_programming_language_model.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/models/user_model.dart';

class PostsRepositpry {
  final _postDao = PostsDao();
  final _userDao = UserDao();
  final _storage = FireStorage();

  // トレンド
  Future<List<PostModelDoc>> getTrendPosts() async {
    List<DocumentSnapshot> _postDocs = await _postDao.getTrendPostsList();
    List<DocumentSnapshot> _userDocs;
    var userDocs = _postDocs.map((doc) async {
      DocumentSnapshot dqs = await _userDao
          .getUserInfo(doc.data[PostModelField.postUserIdRef].documentID);
      return dqs;
    }).toList();
    _userDocs = await Future.wait(userDocs);

    List<PostModelDoc> posts = [];
    for (int i = 0; i < _postDocs.length; i++) {
      posts.add(PostModelDoc(
          _postDocs[i].documentID,
          PostModel.fromMap(_postDocs[i].data),
          UserModelDoc(
              _userDocs[i].documentID, UserModel.fromFire(_userDocs[i].data))));
    }
    return posts;
  }

  // 最新
  Future<List<PostModelDoc>> getNewPosts() async {
    List<DocumentSnapshot> _postDocs = await _postDao.getNewPostsList();
    List<DocumentSnapshot> _userDocs;
    var userDocs = _postDocs.map((doc) async {
      DocumentSnapshot dqs = await _userDao
          .getUserInfo(doc.data[PostModelField.postUserIdRef].documentID);
      return dqs;
    }).toList();
    _userDocs = await Future.wait(userDocs);

    List<PostModelDoc> posts = [];
    for (int i = 0; i < _postDocs.length; i++) {
      posts.add(PostModelDoc(
          _postDocs[i].documentID,
          PostModel.fromMap(_postDocs[i].data),
          UserModelDoc(
              _userDocs[i].documentID, UserModel.fromFire(_userDocs[i].data))));
    }
    return posts;
  }

  // 自分のポートフォリオを取得
  Future<PostModelDoc> getPortfolio(String userId) async {
    DocumentSnapshot _doc = await _postDao.getMyPortfolio(userId);
    PostModelDoc postModelDoc;
    if (_doc != null) {
      postModelDoc =
          PostModelDoc(_doc.documentID, PostModel.fromMap(_doc.data));
      return postModelDoc;
    } else {
      return postModelDoc;
    }
  }

  // 投稿処理
  void addPortfolio(
      String postId,
      String title,
      List<String> langNames,
      File file,
      String portfplioUrl,
      String overview,
      String details,
      String userId) async {
    // ストレージのチェック
    bool isExist = _storage.checkMyStorage(userId);
    if (isExist) {
      _storage.deleteImage(userId);
    }
    // 画像をストレージへ保存し、ダウンロードURLを取得する
    String imageUrl = await _storage.uploadImage(file, userId);
    // 言語名からKeyを取得する
    List<String> langKey = [];
    ProgrammingLangMap.plMap.forEach((key, value) {
      if (langNames.contains(value)) langKey.add(key);
    });

    // 登録処理
    _postDao.insertPortfolio(
        PostModelDoc(
            postId ?? null,
            PostModel(
                title: title,
                programmingLanguage: langKey,
                imageUrl: imageUrl,
                portfolioUrl: portfplioUrl,
                overview: overview,
                details: details)),
        userId);
  }

  // いいねカウント
  void addLikes(String postId, String userId) =>
      _postDao.addLikesCount(postId, userId);
}
