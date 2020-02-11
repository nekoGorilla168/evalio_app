import 'package:flutter/material.dart';

class TabbarViewBloc with ChangeNotifier {
  int _tabbarViewIndex = 0;
  int get curTabbarViewIndex => _tabbarViewIndex;

  //　現在のインデックスを設定する
  void setTabbarViewIndex(int index) => _tabbarViewIndex = index;
}
