import 'package:flutter/material.dart';

class NavigationBarBloc with ChangeNotifier {
  // 選択ナビのインデックス
  int _navBarIndex = 0;
  int get getCurIndex => _navBarIndex;

  void selectedNavBarIndexChanged(int index) {
    _navBarIndex = index;
    notifyListeners();
  }
}
