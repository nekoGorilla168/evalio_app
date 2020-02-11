import 'dart:async';
import 'dart:io';

import 'package:evalio_app/models/posts_model.dart';
import 'package:evalio_app/repository/posts_repository.dart';

class PostsBloc {
  // 投稿リストリポジトリ
  final _postRepository = PostsRepositpry();

  // いいね
  final _trendPostsController =
      StreamController<List<PostModelDoc>>.broadcast();
  Stream<List<PostModelDoc>> get getTrendPosts => _trendPostsController.stream;
  // 最新順
  final _newPostsController = StreamController<List<PostModelDoc>>.broadcast();
  Stream<List<PostModelDoc>> get getNewPosts => _newPostsController.stream;
  // 検索結果
  final _searchResultController =
      StreamController<List<PostModelDoc>>.broadcast();
  Stream<List<PostModelDoc>> get getSearchResult =>
      _searchResultController.stream;
  // お気に入り判定
  final _isMyFavorite = StreamController<int>();
  Stream<int> get getIsMyFavorite => _isMyFavorite.stream;

  // 最新投稿クラス
  List<PostModelDoc> _postTrendModelDoc;
  List<PostModelDoc> get getPostTrendModelDoc => _postTrendModelDoc;

  // トレンド
  List<PostModelDoc> _postNewModelDoc;
  List<PostModelDoc> get getPostNewModelDoc => _postNewModelDoc;

  // コンストラクタ
  PostsBloc() {
    getTrendPostsList();
    getNewPostsList();
  }

  //　トレンド取得
  void getTrendPostsList() async {
    List<PostModelDoc> _postModelDoc = await _postRepository.getTrendPosts();
    if (_postModelDoc != null) {
      _trendPostsController.sink.add(_postModelDoc);
      _postTrendModelDoc = _postModelDoc;
    }
  }

  // 最新リスト取得
  void getNewPostsList() async {
    List<PostModelDoc> _postModelDoc = await _postRepository.getNewPosts();
    if (_postModelDoc != null) {
      _newPostsController.sink.add(_postModelDoc);
      _postNewModelDoc = _postModelDoc;
    }
  }

  // 検索
  void getSerachResult({dynamic condition, int cardNo}) async {
    List<PostModelDoc> _resultList = [];
    if (condition != null) {
      switch (cardNo) {
        case 0:
          // 名前から検索
          _resultList = await _postRepository.getPortFolioByName(condition);
          break;
        case 1:
          // プログラミング言語から検索
          _resultList = await _postRepository.getPortfolioByLanag(condition);
          break;
        default:
          // お気に入りのリストから検索
          for (int i = 0; i < condition.length; i++) {
            PostModelDoc postModelDoc =
                await _postRepository.getPortfolioById(condition[i]);
            if (postModelDoc != null) {
              _resultList.add(postModelDoc);
            }
          }
          break;
      }
      if (_resultList != null) _searchResultController.sink.add(_resultList);
    }
  }

  // ポートフォリオを登録
  void addPostData(
    String postId,
    String title,
    List<String> langNames,
    File file,
    String portfolioUrl,
    String imageName,
    String overview,
    String details,
    String userId,
  ) async {
    _postRepository.addPortfolio(postId, title, langNames, file, portfolioUrl,
        imageName, overview, details, userId);
  }

  // いいね加算
  void addLikesCount(String postId, String userId) async {
    int addLikes = await _postRepository.addLikes(postId, userId);
    if (addLikes != -1) _isMyFavorite.sink.add(addLikes);
  }

  // 投稿削除
  void deletePOrtfolio(String userId, String postId) {
    _postRepository.delete(userId, postId);
  }

  // コントローラーの破棄
  void dispose() {
    _isMyFavorite.close();
    _trendPostsController.close();
    _newPostsController.close();
    _searchResultController.close();
  }
}
