import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/blocs/search_condition_bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/const_programming_language_model.dart';
import 'package:evalio_app/presentation/common/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputSearchCondition extends StatelessWidget {
  // 共通関数クラス
  final common = CommonProcessing();
  @override
  Widget build(BuildContext context) {
    // 検索条件
    final _condition = Provider.of<SearchConditionBloc>(context);
    //
    final _userCtrl = Provider.of<UserBloc>(context);
    // 投稿クラス
    final _postCtrl = Provider.of<PostsBloc>(context);
    // 端末幅
    final double _width = MediaQuery.of(context).size.width;

    return ListView(
      children: <Widget>[
        // 検索：名前
        // cardNo:0
        _searchByName(_width, _postCtrl, _condition, 0, context),

        // 検索；プログラミング言語
        // cardNo:1
        _searchByProgrammingLanguage(_width, _postCtrl, _condition, 1, context),

        // 検索：お気に入り
        // cardNo:2
        _searchByFavorite(_width, _userCtrl, _postCtrl, _condition, 2, context),
      ],
    );
  }

  // ユーザー名検索条件カード
  Widget _searchByName(double width, PostsBloc postsBloc,
      SearchConditionBloc bloc, int cardNo, BuildContext context) {
    return Container(
      width: width,
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.blueAccent,
              ),
              title: Text('ユーザー名で探す'),
            ),
            TextFormField(
              onChanged: (String inputData) {
                bloc.setUserName(inputData);
              },
              maxLines: 2,
              decoration: InputDecoration(labelText: 'ユーザー名'),
            ),
            _searchButton(
                postsBloc: postsBloc,
                searchConditionBloc: bloc,
                cardNo: cardNo,
                context: context),
          ],
        ),
      ),
    );
  }

  // 言語名検索条件カード
  Widget _searchByProgrammingLanguage(double width, PostsBloc postsBloc,
      SearchConditionBloc bloc, int cardNo, BuildContext context) {
    return Container(
      width: width,
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.language,
                color: Colors.blueAccent,
              ),
              title: Text('プログラミング言語で探す'),
            ),
            Wrap(
              children: _getFilterChipList(bloc),
            ),
            _searchButton(
                postsBloc: postsBloc,
                searchConditionBloc: bloc,
                cardNo: cardNo,
                context: context),
          ],
        ),
      ),
    );
  }

  // お気に入り検索カード
  Widget _searchByFavorite(
      double width,
      UserBloc userBloc,
      PostsBloc postsBloc,
      SearchConditionBloc searchConditionBloc,
      int cardNo,
      BuildContext context) {
    return Container(
      width: width,
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              title: Text('あなたのお気に入りを表示する'),
            ),
            _searchButton(
                userBloc: userBloc,
                postsBloc: postsBloc,
                searchConditionBloc: searchConditionBloc,
                cardNo: cardNo,
                context: context),
          ],
        ),
      ),
    );
  }

  // フィルターチップのリストを返す
  List<Widget> _getFilterChipList(SearchConditionBloc bloc) {
    List<Widget> filterChipList = ProgrammingLangMap.pLangNames.map((pLName) {
      return Transform.scale(
        scale: 0.85,
        child: FilterChip(
          label: Text(pLName),
          selected: bloc.getLanguage.contains(pLName),
          backgroundColor: Colors.blueGrey.shade100,
          checkmarkColor: Colors.blueAccent,
          selectedColor: Colors.lightBlueAccent.shade100,
          onSelected: (bool selected) {
            if (selected) {
              bloc.addLanguage(pLName);
            } else {
              bloc.removeLanguage(pLName);
            }
          },
        ),
      );
    }).toList();

    return filterChipList;
  }

  // 共通検索ボタン
  Widget _searchButton(
      {UserBloc userBloc,
      PostsBloc postsBloc,
      SearchConditionBloc searchConditionBloc,
      int cardNo,
      BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton.icon(
          onPressed: () {
            switch (cardNo) {
              case 0:
                String userName = searchConditionBloc.getUserName;
                postsBloc.getSerachResult(condition: userName, cardNo: cardNo);
                break;
              case 1:
                List<String> language = searchConditionBloc.getLanguage;
                postsBloc.getSerachResult(condition: language, cardNo: cardNo);
                break;
              case 2:
                List<String> postIds = userBloc.getMyFavorites;
                postsBloc.getSerachResult(condition: postIds, cardNo: cardNo);
                break;
              default:
                break;
            }
            Navigator.pushNamed(context, '/result');
          },
          icon: Icon((Icons.search)),
          label: Text('検索'),
        ),
      ],
    );
  }
}
