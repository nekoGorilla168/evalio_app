import 'package:evalio_app/blocs/bottom-navibar-bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ctrlIndex = Provider.of<BottomNaviBarBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('evalio'),
      ),
      body: NaviList().pageWidgets.elementAt(_ctrlIndex.getCurIndex),
      bottomNavigationBar: BottomNavibarConst(),
    );
  }
}

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

class NaviList {
  final pageWidgets = [
    PageWidget(color: Colors.white, title: '一覧'),
    PageWidget(color: Colors.blue, title: 'プロフィール'),
    PageWidget(color: Colors.orange, title: 'その他'),
  ];
}

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
