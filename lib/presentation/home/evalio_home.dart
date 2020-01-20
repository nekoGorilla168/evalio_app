import 'package:evalio_app/blocs/bottom-navibar-bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/presentation/constant/posts_list_app_bar.dart';
import 'package:evalio_app/presentation/posts/posts_list.dart';
import 'package:evalio_app/presentation/profile/profile.dart';
import 'package:evalio_app/presentation/settings/logout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final String id;

  // オプショナルコンストラクタ
  Home([this.id]);

  // ユーザー情報取得

  // AppBarリスト
  static final _appBarList = [
    PostsListAppBar(),
    PostsListAppBar(),
    PostsListAppBar(),
    PostsListAppBar(),
    PostsListAppBar(),
  ];

  // BottomNavBar遷移先ウィジェットリスト
  static final _pageWidgets = [
    PostsList(),
    Profile(),
    Profile(),
    Profile(),
    Settings(),
  ];

  // 画面に応じたボタンを返す
  Widget _returnFloatingActBtn(int gamenIndex) {
    switch (gamenIndex) {
      case 0:
        return Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 50.0),
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
              ),
            ),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.update),
            )
          ],
        );
        break;
      case 1:
        return FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.search),
        );
        break;
      case 2:
        return FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.mode_edit),
        );
        break;
      default:
        return null;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // インデックスコントロール
    final _ctrlIndex = Provider.of<NavigationBarBloc>(context);
    final _ctrlUser = Provider.of<UserBloc>(context);
    if (id != null) {
      _ctrlUser.getUserInfo(id);
    }

//    final List<Widget> _floatingButtons = [
//      Container(
//        margin: EdgeInsets.only(top: 10.0),
//        child: FloatingActionButton(
//          onPressed: () {},
//          child: Icon(Icons.add),
//        ),
//      ),
//      FloatingActionButton(
//        onPressed: () {},
//        child: Icon(Icons.update),
//      )
//    ];

    return Scaffold(
      appBar: _appBarList.elementAt(_ctrlIndex.getCurIndex),
      body: IndexedStack(index: _ctrlIndex.getCurIndex, children: _pageWidgets),
      floatingActionButton: _returnFloatingActBtn(_ctrlIndex.getCurIndex),
//          _ctrlIndex.getCurIndex == 0 || _ctrlIndex.getCurIndex == 1
//              ? Column(
//                  verticalDirection: VerticalDirection.up,
//                  children: _ctrlIndex.getCurIndex == 0
//                      ? _floatingButtons
//                      : <Widget>[
//                          FloatingActionButton(
//                            onPressed: () {},
//                            child: Icon(Icons.mode_edit),
//                          )
//                        ],
//                )
//              : null,
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
        BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('検索')),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), title: Text('プロフィール')),
        BottomNavigationBarItem(
            icon: Icon(Icons.star_border), title: Text('お気に入り')),
        BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('その他'))
      ],
      onTap: (int index) {
        _ctrlIndex.selectedNavBarIndexChanged(index);
      },
      type: BottomNavigationBarType.fixed,
      currentIndex: _ctrlIndex.getCurIndex,
      selectedItemColor: Colors.lightBlue,
    );
  }
}
