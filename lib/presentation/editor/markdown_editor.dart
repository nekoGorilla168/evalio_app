import 'dart:io';

import 'package:evalio_app/blocs/markdown_bloc.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/firebase/admob_manage.dart';
import 'package:evalio_app/models/const_programming_language_model.dart';
import 'package:evalio_app/models/posts_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionPortfolioEditor extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _markdownCtrl = Provider.of<MarkDownBloc>(context);
    final _postCtrl = Provider.of<PostsBloc>(context);
    final _userCtrl = Provider.of<UserBloc>(context);

    final _width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          key: _key,
          appBar: AppBar(
            title: const Text('ポートフォリオ編集'),
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
          body: TabBarView(children: [
            ListView(
              children: <Widget>[
                //
                _applicationTitleInputArea(),
                Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Colors.green,
                  ),
                  title: Text('使用技術を選択してください'),
                ),
                Wrap(
                  // プログラミング言語のフィルターチップリストを返す
                  children: _getFilterChipList(_markdownCtrl),
                ),
                Divider(
                  color: Colors.grey,
                ),
                // ローカルストレージから写真を選択する
                _photoFromLocalStorage(_markdownCtrl),
                // 選択された写真を表示する領域
                _displayPhotoField(_markdownCtrl),
                Divider(
                  color: Colors.grey,
                ),
                // リンクを貼る
                _portfolioLink(),
                Divider(
                  color: Colors.grey,
                ),
                //　アプリケーションの概要を入力するエリア
                _inputOverview(),
                // ポートフォリオの詳細を入力するエリア
                _inputDetails(),
              ],
            ),
            ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  child: FlatButton.icon(
                    onPressed: () {
                      if (_markdownCtrl.checkData() == false) {
                        _key.currentState.showSnackBar(
                            const SnackBar(content: Text('未入力の項目があります。')));
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text('Confirmation'),
                              content: Text('あなたのポートフォリオを投稿しますが本当によろしいですか？'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                FlatButton(
                                  child: Text('OK'),
                                  onPressed: () async {
                                    // ポートフォリオ登録
                                    _postCtrl.addPostData(
                                        _userCtrl.getPostId,
                                        _markdownCtrl.getAppTitle,
                                        _markdownCtrl.getFilters,
                                        _markdownCtrl.getImage,
                                        _markdownCtrl.getUrl,
                                        _userCtrl
                                            .getUserDoc
                                            .postModelDoc
                                            .postModel
                                            .content[PostModelField.imageName],
                                        _markdownCtrl.getAppOverView,
                                        _markdownCtrl.getMarkDownData,
                                        _userCtrl.getId);
                                    _userCtrl.getUserInfo(_userCtrl.getId);

                                    if (await AdmobManage
                                        .interstitialAd.isLoaded) {
                                      AdmobManage.interstitialAd.show();
                                    }
                                    Navigator.popUntil(
                                        context, ModalRoute.withName('/home'));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    icon: Icon(Icons.navigate_next),
                    label: Text('投稿する'),
                  ),
                ),

                // アプリタイトル表示
                showTitle(_width, _markdownCtrl.getAppTitle),
                // 使用技術のリスト
                Wrap(
                  alignment: WrapAlignment.center,
                  children: createChipList(_markdownCtrl.getFilters),
                ),
                // 写真表示領域
                _displayPhotoField(_markdownCtrl),
                // URLを開く
                _launchUrl(_markdownCtrl.getUrl),
                Divider(
                  color: Colors.grey,
                ),
                //
                _overviewTitle(),
                _displayOverview(_width, _markdownCtrl.getAppOverView),
                Divider(
                  color: Colors.grey,
                ),
                _detailsTitle(),
                _displayDetails(_width, _markdownCtrl.getMarkDownData),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  // アプリのタイトルの入力域
  Widget _applicationTitleInputArea() {
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Builder(
          builder: (BuildContext context) {
            final _markdownCtrl = Provider.of<MarkDownBloc>(context);
            return TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 2,
              maxLength: 30,
              initialValue: _markdownCtrl.getAppTitle ?? "",
              decoration: InputDecoration(
                  hintMaxLines: 30,
                  border: UnderlineInputBorder(),
                  icon: Icon(
                    Icons.web,
                    color: Colors.blueAccent,
                  ),
                  hintText: '書籍管理共有アプリケーション',
                  labelText: 'アプリケーショ名(タイトル)'),
              onChanged: (String data) {
                _markdownCtrl.setAppTitle(data);
              },
            );
          },
        ));
  }

  // フィルターチップのリストを返す
  List<Widget> _getFilterChipList(MarkDownBloc bloc) {
    List<Widget> filterChipList = ProgrammingLangMap.pLangNames.map((pLName) {
      return Transform.scale(
        scale: 0.85,
        child: FilterChip(
            label: Text(pLName),
            selected: bloc.getFilters.contains(pLName),
            backgroundColor: Colors.blueGrey.shade100,
            checkmarkColor: Colors.blueAccent,
            selectedColor: Colors.lightBlueAccent.shade100,
            onSelected: (bool selected) {
              if (selected) {
                bloc.addFilters(pLName);
              } else {
                bloc.removeFilters(pLName);
              }
            }),
      );
    }).toList();
    return filterChipList;
  }

  // ローカルストレージ内の写真を選択する
  Widget _photoFromLocalStorage(MarkDownBloc bloc) {
    return ListTile(
      leading: Icon(
        Icons.photo,
        color: Colors.blue,
      ),
      title: Text(
        '＋写真を選択する',
        style: TextStyle(color: Colors.lightBlue),
      ),
      onTap: () async {
        File image = await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 80);

        bloc.setPhoto(image);
      },
    );
  }

  // 写真の表示領域
  Widget _displayPhotoField(MarkDownBloc bloc) {
    return Container(
      width: 340,
      child: bloc.getImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                bloc.getImage,
                fit: BoxFit.cover,
              ),
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Container(
                height: 240,
                child: Center(
                  child: Text('サムネイルとなる写真を投稿してみよう'),
                ),
              ),
            ),
    );
  }

// ポートフォリオサイトへのリンクをセットする
  Widget _portfolioLink() {
    return Consumer<MarkDownBloc>(
      builder: (_, bloc, __) {
        return Container(
          margin: EdgeInsets.all(10.0),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: null,
            maxLength: 100,
            initialValue: bloc.getUrl,
            decoration: InputDecoration(
              hintMaxLines: 200,
              icon: Icon(
                Icons.link,
                color: Colors.indigo,
              ),
              labelText: 'ポートフォリオへのリンク',
            ),
            onChanged: (String inputData) {
              bloc.setUrl(inputData);
            },
          ),
        );
      },
    );
  }

  // ポートフォリオの概要を入力
  Widget _inputOverview() {
    return Consumer<MarkDownBloc>(
      builder: (_, bloc, __) {
        return Container(
          margin: EdgeInsets.all(10.0),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: null,
            maxLength: 100,
            initialValue: bloc.getAppOverView,
            decoration: InputDecoration(
                border: UnderlineInputBorder(),
                icon: Icon(
                  Icons.description,
                  color: Colors.green,
                ),
                hintText: 'このアプリケーションは普段よんでいる本をみんなで共有するためのアプリケーションです',
                labelText: 'ポートフォリオの概要'),
            onChanged: (String overview) {
              bloc.setAppOverView(overview);
            },
          ),
        );
      },
    );
  }

  // ポートフォリオの詳細を記述
  Widget _inputDetails() {
    return Consumer<MarkDownBloc>(
      builder: (_, bloc, __) {
        return Container(
          margin: EdgeInsets.all(10.0),
          height: 100,
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: null,
            maxLength: 800,
            initialValue: bloc.getMarkDownData,
            decoration: InputDecoration(
                border: UnderlineInputBorder(),
                icon: Icon(
                  Icons.text_fields,
                  color: Colors.blueAccent,
                ),
                hintText: 'Markdown形式可(自由)',
                labelText: 'ポートフォリオの詳細'),
            onChanged: (String inputData) {
              bloc.setDescriptionData(inputData);
            },
          ),
        );
      },
    );
  }

  // タイトルを表示する
  Widget showTitle(double width, String title) {
    // タイトルのスタイルを決定
    final _titleStyle = TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.w600,
    );

    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      alignment: Alignment.center,
      width: width,
      child: Text(
        '$title',
        style: _titleStyle,
      ),
    );
  }

  // チップリストを返すウィジェット
  List<Widget> createChipList(List<String> programmingLanguage) {
    List<Widget> _chipList = programmingLanguage.map((langName) {
      return Transform.scale(
        scale: 0.85,
        child: Chip(
          label: Text(langName),
          backgroundColor: Colors.blueGrey.shade100,
        ),
      );
    }).toList();
    return _chipList;
  }

  // URLを開く
  Widget _launchUrl(String portfolioUrl) {
    final _portfolioUrlStyle = TextStyle(color: Colors.lightBlue);

    return GestureDetector(
      onTap: () async {
        if (await canLaunch(portfolioUrl)) {
          await launch(portfolioUrl);
        } else {}
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          portfolioUrl,
          style: _portfolioUrlStyle,
        ),
      ),
    );
  }

  // アプリケーション概要のタイトル表示
  Widget _overviewTitle() {
    final _overviewStyle = TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.solid);
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 15.0),
      child: Text(
        'Overview',
        style: _overviewStyle,
      ),
    );
  }

  // アプリケーション概要の本文を表示
  Widget _displayOverview(double width, String overview) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: width,
      child: Text(overview),
    );
  }

  // 詳細のタイトル
  Widget _detailsTitle() {
    final _detailsStyle = TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.solid);
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 5.0, left: 10.0, bottom: 15.0),
      child: Text(
        'Details',
        style: _detailsStyle,
      ),
    );
  }

  // アプリケーション詳細の表示
  Widget _displayDetails(double width, String details) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: width,
      child: MarkdownBody(
        data: details,
      ),
    );
  }
}
