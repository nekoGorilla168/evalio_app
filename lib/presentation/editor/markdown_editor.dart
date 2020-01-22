import 'package:evalio_app/blocs/markdown_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

class DescriptionPortfolioEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _markdownCtrl = Provider.of<MarkDownBloc>(context);

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Markdown Editor'),
            centerTitle: true,
            bottom: TabBar(tabs: [
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
            Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 2,
                  decoration: InputDecoration(
                      hintMaxLines: 30,
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.web),
                      hintText: '書籍管理共有アプリケーション',
                      labelText: 'アプリケーショ名(タイトル)'),
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.description),
                      hintText: 'このアプリケーションは普段よんでいる本をみんなで共有するためのアプリケーションです',
                      labelText: 'アプリケーションの概要'),
                ),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 70,
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
            Container(child: MarkdownBody(data: _markdownCtrl.getMarkDownData)),
          ]),
        ),
      ),
    );
  }
}
