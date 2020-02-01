import 'package:flutter/material.dart';

class SearchConditionBloc with ChangeNotifier {
  // ユーザー名
  String _userName;
  String get getUserName => _userName;

  // プログラミング言語のリスト
  List<String> _programmingLanguage = [];
  List<String> get getLanguage => _programmingLanguage;

  // ユーザー名
  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

// 言語名追加
  void addLanguage(String pLName) {
    _programmingLanguage.add(pLName);
    notifyListeners();
  }

// 言語名削除
  void removeLanguage(String pLName) {
    _programmingLanguage.remove(pLName);
    notifyListeners();
  }
}
