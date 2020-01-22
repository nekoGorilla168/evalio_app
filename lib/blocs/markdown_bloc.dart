import 'package:flutter/material.dart';

class MarkDownBloc with ChangeNotifier {
  String _markDownDate = "";

  String get getMarkDownData => _markDownDate;

  void setDescriptionData(String data) {
    _markDownDate = data;
    notifyListeners();
  }
}
