import 'dart:io';

import 'package:flutter/material.dart';

class MarkDownBloc with ChangeNotifier {
  // アプリケーションタイトル
  String appTitle = "";
  String get getAppTitle => appTitle;

  // アプリケーションの概要
  String appOverVeiw = "";
  String get getAppOverView => appOverVeiw;

  // マークダウン形式で書かれたデータ
  String markDownDate = "";
  String get getMarkDownData => markDownDate;

  // 端末の写真取得
  File image;
  File get getImage => image;

  // ポートフォリオサイトのURL
  String portfolioUrl = "";
  String get getUrl => portfolioUrl;

  // フィルターチップの選択されたチップリスト
  List<String> filters = <String>[];
  List<String> get getFilters => filters;

  // アプリケーションタイトルセット
  void setAppTitle(String title) {
    appTitle = title;
    notifyListeners();
  }

  // アプリケーションの概要セット
  void setAppOverView(String overview) {
    appOverVeiw = overview;
    notifyListeners();
  }

  // マークダウンデータを保持する
  void setDescriptionData(String data) {
    markDownDate = data;
    notifyListeners();
  }

  // ストレージ内の写真を保持する
  void setPhoto(File image) {
    this.image = image;
    notifyListeners();
  }

  // ポートフォリオサイトのURLを追加する
  void setUrl(String url) {
    portfolioUrl = url;
    notifyListeners();
  }

  // リストに選択した言語名を追加するメソッド
  void addFilters(String pLName) {
    filters.add(pLName);
    notifyListeners();
  }

  // 追加された言語をリストから取り除くメソッド
  void removeFilters(String pLName) {
    filters.remove(pLName);
    notifyListeners();
  }

  // 未入力のデータが存在するかチェックする
  bool checkData() {
    if (appTitle == "" ||
        image == null ||
        filters == [] ||
        appOverVeiw == "" ||
        markDownDate == "") {
      return false;
    } else {
      return true;
    }
  }
}
