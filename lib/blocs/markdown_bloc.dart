import 'dart:io';

import 'package:flutter/material.dart';

class MarkDownBloc with ChangeNotifier {
  // アプリケーションタイトル
  String _appTitle = "";
  String get getAppTitle => _appTitle;

  // アプリケーションの概要
  String _appOverVeiw = "";
  String get getAppOverView => _appOverVeiw;

  // マークダウン形式で書かれたデータ
  String _markDownDate = "";
  String get getMarkDownData => _markDownDate;

  // 端末の写真取得
  File _image;
  File get getImage => _image;

  // フィルターチップの選択されたチップリスト
  List<String> _filters = <String>[];
  List<String> get getFilters => _filters;

  // アプリケーションタイトルセット
  void setAppTitle(String title) {
    _appTitle = title;
    notifyListeners();
  }

  // アプリケーションの概要セット
  void setAppOverView(String overview) {
    _appOverVeiw = overview;
    notifyListeners();
  }

  // マークダウンデータを保持する
  void setDescriptionData(String data) {
    _markDownDate = data;
    notifyListeners();
  }

  // ストレージ内の写真を保持する
  void setPhoto(File image) {
    _image = image;
    notifyListeners();
  }

  // リストに選択した言語名を追加するメソッド
  void addFilters(String pLName) {
    _filters.add(pLName);
    notifyListeners();
  }

  // 追加された言語をリストから取り除くメソッド
  void removeFilters(String pLName) {
    _filters.remove(pLName);
    notifyListeners();
  }

  // 未入力のデータが存在するかチェックする
  bool checkData() {
    if (_appTitle == "" ||
        _image == null ||
        _filters == [] ||
        _appOverVeiw == "" ||
        _markDownDate == "") {
      return false;
    } else {
      return true;
    }
  }
}
