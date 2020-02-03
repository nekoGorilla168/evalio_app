import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayPostsListBloc with ChangeNotifier {
  bool _isTrend = true; // トレンドボタン押下判定
  bool _isNew = false; // 最新順ボタン押下判定

  bool _isAddedMyFavorite;
  bool get getIsAddedMyFavorite => _isAddedMyFavorite;

  int _cutIndex = 0; // 表示ウィジェット管理

  bool get getISTrend => _isTrend;
  bool get getIsNew => _isNew;

  int get getCurIndex => _cutIndex;

  void selectedTrend() {
    _isTrend = true;
    _isNew = false;
    notifyListeners();
  }

  void selectedNew() {
    _isTrend = false;
    _isNew = true;
    notifyListeners();
  }

  void setHomeKet(bool state) {
    _isAddedMyFavorite = state;
    notifyListeners();
  }

  void selectedIndexChanged(int index) {
    _cutIndex = index;
    notifyListeners();
  }
}
