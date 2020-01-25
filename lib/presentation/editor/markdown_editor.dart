import 'package:evalio_app/blocs/markdown_bloc.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/models/const_programming_language_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DescriptionPortfolioEditor extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _markdownCtrl = Provider.of<MarkDownBloc>(context);
    final _postCtrl = Provider.of<PostsBloc>(context);

    // フィルターチップのリストを返す
    List<Widget> _getFilterChipList() {
      List<Widget> filterChipList = ProgrammingLangMap.pLangNames.map((pLName) {
        return Transform.scale(
          scale: 0.85,
          child: FilterChip(
            label: Text(pLName),
            selected: _markdownCtrl.getFilters.contains(pLName),
            backgroundColor: Colors.blueGrey.shade100,
            checkmarkColor: Colors.blueAccent,
            selectedColor: Colors.lightBlueAccent.shade100,
            onSelected: (bool selected) {
              if (selected) {
                _markdownCtrl.addFilters(pLName);
              } else {
                _markdownCtrl.removeFilters(pLName);
              }
            },
          ),
        );
      }).toList();

      return filterChipList;
    }

    // アプリのタイトルの入力域
    Widget _applicationTitleInputArea() {
      return Container(
        height: 100,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 2,
          decoration: InputDecoration(
              hintMaxLines: 30,
              border: UnderlineInputBorder(),
              icon: Icon(Icons.web),
              hintText: '書籍管理共有アプリケーション',
              labelText: 'アプリケーショ名(タイトル)'),
          onChanged: (String data) {
            _markdownCtrl.setAppTitle(data);
          },
        ),
      );
    }

    // ローカルストレージ内の写真を選択する
    Widget _photoFromLocalStorage() {
      return GestureDetector(
        onTap: () async {
          var image = await ImagePicker.pickImage(source: ImageSource.gallery);
          _markdownCtrl.setPhoto(image);
        },
        child: Container(
          height: 100,
          child: Row(
            children: <Widget>[Icon(Icons.photo), Text('+写真を選択する')],
          ),
        ),
      );
    }

    // 写真の表示領域
    Widget _displayPhotoField() {
      return Container(
        width: 360,
        height: 200,
        child: _markdownCtrl.getImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  _markdownCtrl.getImage,
                  fit: BoxFit.fill,
                ),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: GestureDetector(
                  onTap: () async {
                    var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                    _markdownCtrl.setPhoto(image);
                  },
                  child: Center(
                    child: Text('サムネイルとなる写真を投稿してみよう'),
                  ),
                ),
              ),
      );
    }

    // 画面内のアンダーバー付き項目を生成
    Widget _createKoumoku(String title, double size) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
        ),
      );
    }

    // 選択された技術をプレビューに表示する
    List<Widget> _displayChipList(List<String> pLNames) {
      List<Widget> _chipList = pLNames.map((langName) {
        return Transform.scale(
          scale: 1.0,
          child: Chip(
            label: Text(langName),
            backgroundColor: Colors.blueGrey.shade100,
          ),
        );
      }).toList();
      return _chipList;
    }

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          appBar: AppBar(
            title: const Text('Portfolio Editor'),
            centerTitle: true,
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.add),
                text: "Edit",
              ),
              Tab(
                icon: Icon(Icons.remove_red_eye),
                text: "Preview",
              )
            ]),
          ),
          body: TabBarView(
            children: [
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: Column(
                      children: <Widget>[
                        _applicationTitleInputArea(),
                        Row(
                          children: <Widget>[
                            Icon(Icons.check),
                            Text("使用技術を選択してください"),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Container(
                          child: Wrap(
                            children: _getFilterChipList(),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        _photoFromLocalStorage(),
                        _displayPhotoField(),
                        Container(
                          height: 100,
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.description),
                                hintText:
                                    'このアプリケーションは普段よんでいる本をみんなで共有するためのアプリケーションです',
                                labelText: 'アプリケーションの概要'),
                            onChanged: (String overview) {
                              _markdownCtrl.setAppOverView(overview);
                            },
                          ),
                        ),
                        Container(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 300,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                icon: Icon(Icons.text_fields),
                                hintText:
                                    'Markdown形式であなたのアプリケーションの詳細やアピールポイント、工夫点、苦労した点など自由に書いてみよう',
                                labelText: 'アプリケーションの詳細'),
                            onChanged: (String inputData) {
                              _markdownCtrl.setDescriptionData(inputData);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton.icon(
                            onPressed: () {
                              if (_markdownCtrl.checkData() == false) {
                                _key.currentState.showSnackBar(const SnackBar(
                                    content: Text('未入力の項目があります。')));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content:
                                          Text('あなたのポートフォリオを投稿しますが本当によろしいですか？'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Cancel'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            icon: Icon(Icons.navigate_next),
                            label: Text('投稿する'),
                          ),
                        ],
                      ),
                      _createKoumoku(_markdownCtrl.getAppTitle, 20),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 0.0,
                          children: _displayChipList(_markdownCtrl.getFilters),
                        ),
                      ),
                      _displayPhotoField(),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: _createKoumoku("アプリケーション概要", 14),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(_markdownCtrl.getAppOverView),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: _createKoumoku("アプリケーション詳細", 14),
                      ),
                      Container(
                        child:
                            MarkdownBody(data: _markdownCtrl.getMarkDownData),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
