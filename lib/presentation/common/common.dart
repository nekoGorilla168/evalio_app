import 'package:evalio_app/models/const_programming_language_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonProcessing {
  // チップリストを返すウィジェット
  List<Widget> createChipList(List<String> programmingLanguage, double scale) {
    List<Widget> _chipList = programmingLanguage.map((langKey) {
      // 言語名を取得
      String langName = ProgrammingLangMap.plMap[langKey];

      return Transform.scale(
        scale: scale,
        child: Chip(
          label: Text(langName),
          backgroundColor: Colors.blueGrey.shade100,
        ),
      );
    }).toList();

    return _chipList;
  }

  // 日付けの計算
  String postedTime(String date, DateFormat format) {
    // 今日と投稿日を取得
    var today = DateTime.now();
    var createdAt = DateTime.parse(date);
    // 差分を取得
    var isDiffTime = today.difference(createdAt);

    // 差分により表記が変わる
    if (isDiffTime.inDays != 0) {
      if (isDiffTime.inDays > 30) {
        // 日付のフォーマット(yyyyMMdd)
        return format.format(createdAt);
      } else {
        return "${isDiffTime.inDays} days ago";
      }
    } else if (isDiffTime.inHours != 0) {
      return "${isDiffTime.inHours} hours ago";
    } else {
      return "${isDiffTime.inMinutes} minutes ago";
    }
  }
}
