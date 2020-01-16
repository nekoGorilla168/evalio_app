import 'package:evalio_app/blocs/bottom-navibar-bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/presentation/constant/posts_list_app_bar.dart';
import 'package:evalio_app/presentation/posts/posts_list.dart';
import 'package:evalio_app/presentation/profile/profile.dart';
import 'package:evalio_app/presentation/settings/logout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  // AppBarリスト
  static final _appBarList = [
    PostsListAppBar(),
    PostsListAppBar(),
    PostsListAppBar(),
  ];

  // BottomNavBar遷移先ウィジェットリスト
  static final _pageWidgets = [
    PostsList(),
    Profile(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    // インデックスコントロール
    final _ctrlIndex = Provider.of<NavigationBarBloc>(context);
    final _ctrlUser = Provider.of<UserBloc>(context);

    return Scaffold(
      appBar: _appBarList.elementAt(_ctrlIndex.getCurIndex),
      body: IndexedStack(index: _ctrlIndex.getCurIndex, children: _pageWidgets),
      bottomNavigationBar: BottomNavibarConst(),
    );
  }
}

// ボトムナビバークラス
class BottomNavibarConst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ctrlIndex = Provider.of<NavigationBarBloc>(context);

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.view_list), title: Text('一覧')),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), title: Text('プロフィール')),
        BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('その他'))
      ],
      onTap: (int index) {
        _ctrlIndex.selectedNavBarIndexChanged(index);
      },
      type: BottomNavigationBarType.fixed,
      currentIndex: _ctrlIndex.getCurIndex,
    );
  }
}
