import 'package:evalio_app/blocs/bottom-navibar-bloc.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:evalio_app/presentation/constant/posts_list_app_bar.dart';
import 'package:evalio_app/presentation/posts/posts_list.dart';
import 'package:evalio_app/presentation/profile/profile.dart';
import 'package:evalio_app/presentation/search/search.dart';
import 'package:evalio_app/presentation/settings/logout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  // ユーザーID
  final String id;

  // オプショナルコンストラクタ
  Home([this.id]);

  // BottomNavBar遷移先ウィジェットリスト
  static final _pageWidgets = [
    PostsList(),
    InputSearchCondition(),
    Profile(),
    Settings(),
  ];

  // 画面に応じたボタンを返す
  Widget _returnFloatingActBtn(
      int gamenIndex, BuildContext context, UserModelDoc userModelDoc) {
    final _postCtrl = Provider.of<PostsBloc>(context);
    switch (gamenIndex) {
      case 0: // 一覧画面
        return Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: FloatingActionButton(
                heroTag: "heroTag1",
                child: Icon(Icons.add),
                onPressed: () => Navigator.of(context).pushNamed("/editor"),
              ),
            ),
            FloatingActionButton(
              heroTag: "heroTag2",
              onPressed: () {
                _postCtrl.getTrendPostsList();
                _postCtrl.getNewPostsList();
              },
              child: Icon(Icons.update),
            )
          ],
        );
        break;
      case 2:
        return FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/profileEditor',
              arguments: userModelDoc),
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
      _ctrlUser.setUserId(id);
    }
    // ホーム画面
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('evalio'),
          centerTitle: true,
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
        body:
            IndexedStack(index: _ctrlIndex.getCurIndex, children: _pageWidgets),
        floatingActionButton: _returnFloatingActBtn(
            _ctrlIndex.getCurIndex, context, _ctrlUser.getUserDoc),
        bottomNavigationBar: BottomNavibarConst(),
      ),
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
      selectedItemColor: Colors.lightBlue,
    );
  }
}
