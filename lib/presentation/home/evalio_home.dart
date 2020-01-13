import 'package:evalio_app/blocs/bottom-navibar-bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/presentation/constant/posts_list_app_bar.dart';
import 'package:evalio_app/presentation/posts/posts_list.dart';
import 'package:evalio_app/presentation/settings/logout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // インデックスコントロール
    final _ctrlIndex = Provider.of<BottomNaviBarBloc>(context);
    final _ctrlUser = Provider.of<UserBloc>(context);

    return Scaffold(
      appBar: AppBarList().appBarList.elementAt(_ctrlIndex.getCurIndex),
      body: IndexedStack(
        index: _ctrlIndex.getCurIndex,
        children: NaviList().pageWidgets,
      ),
      bottomNavigationBar: BottomNavibarConst(),
    );
  }
}

// テスト用
class PageWidget extends StatelessWidget {
  final Color color;
  final String title;

  PageWidget({Key key, this.color, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}

// appBarリスト
class AppBarList {
  final appBarList = [
    PostsListAppBar(),
    PostsListAppBar(),
    PostsListAppBar(),
  ];
}

// ナビゲーションリスト
class NaviList {
  final pageWidgets = [
    PostsList(),
    PageWidget(color: Colors.blue, title: 'プロフィール'),
    Settings(),
  ];
}

// ボトムナビバークラス
class BottomNavibarConst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ctrlIndex = Provider.of<BottomNaviBarBloc>(context);

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.view_list), title: Text('一覧')),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), title: Text('プロフィール')),
        BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('その他'))
      ],
      onTap: (int index) {
        _ctrlIndex.selectedIndexChanged(index);
      },
      type: BottomNavigationBarType.fixed,
      currentIndex: _ctrlIndex.getCurIndex,
    );
  }
}
