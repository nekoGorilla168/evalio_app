import 'package:flutter/material.dart';

class BottomNaviBarBloc with ChangeNotifier {
  // 選択ナビのインデックス
  int _curIndex = 0;
  int get getCurIndex => _curIndex;

  void selectedIndexChanged(int index) {
    _curIndex = index;
    notifyListeners();
  }
}
