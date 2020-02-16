import 'package:evalio_app/blocs/bottom-navibar-bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/firebase/admob_manage.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:evalio_app/presentation/posts/post_list_tab.dart';
import 'package:evalio_app/presentation/profile/profile.dart';
import 'package:evalio_app/presentation/search/search.dart';
import 'package:evalio_app/presentation/settings/logout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  // ユーザーID
  final String id;
  // オプショナルコンストラクタ
  Home([this.id]) {
    //AdmobManage.initAdInfo();
  }

  // BottomNavBar遷移先ウィジェットリスト
  static final _pageWidgets = [
    PostListTabView(),
    InputSearchCondition(),
    Profile(),
    Settings(),
  ];

  // 画面に応じたボタンを返す
  Widget _returnFloatingActBtn(
      int gamenIndex, BuildContext context, UserModelDoc userModelDoc) {
    switch (gamenIndex) {
      case 0: // 一覧画面
        return FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("/editor");
            });
        break;
      case 2:
        return FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/profileEditor',
              arguments: userModelDoc),
          backgroundColor: Colors.white,
          child: Icon(
            Icons.mode_edit,
            color: Colors.black,
          ),
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
      _ctrlUser.setUserId(id);
    }
    // ホーム画面
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('evalio'),
            centerTitle: true,
            bottom: _ctrlIndex.getCurIndex == 0
                ? const TabBar(
                    indicatorPadding: EdgeInsets.all(0.0),
                    indicator: ShapeDecoration(
                      shape: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 4.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 10.0,
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.trending_up,
                          color: Colors.redAccent,
                        ),
                        child: Text('Trend'),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.new_releases,
                          color: Colors.blueAccent,
                        ),
                        child: Text('New'),
                      ),
                    ],
                  )
                : null,
            actions: <Widget>[
              StreamBuilder<UserModelDoc>(
                stream: _ctrlUser.getUser,
                builder: (context, snapsot) {
                  if (snapsot.hasData) {
                    return CircleAvatar(
                      child: ClipOval(
                        child: Image.network(snapsot.data.userModel.photoUrl),
                      ),
                    );
                  } else {
                    return CircleAvatar(
                      child: Icon(Icons.person),
                    );
                  }
                },
              ),
            ],
          ),
          body: IndexedStack(
              index: _ctrlIndex.getCurIndex, children: _pageWidgets),
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _returnFloatingActBtn(
              _ctrlIndex.getCurIndex, context, _ctrlUser.getUserDoc),
          bottomNavigationBar: BottomNavibarConst(),
        ),
      ),
    );
  }
}

// ボトムナビバークラス
class BottomNavibarConst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ctrlIndex = Provider.of<NavigationBarBloc>(context);

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      clipBehavior: Clip.antiAlias,
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          // 投稿一覧画面
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text('一覧'),
          ),
          // プロフィール検索画面
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('検索'),
          ),
          // プロフィール画面
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('プロフィール'),
          ),
          // 設定画面
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('その他'),
          )
        ],
        // 画面のインデックスを管理する
        onTap: (int index) {
          _ctrlIndex.selectedNavBarIndexChanged(index);
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: _ctrlIndex.getCurIndex,
        selectedItemColor: Colors.blueAccent,
      ),
    );
  }
}
