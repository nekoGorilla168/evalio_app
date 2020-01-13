import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ポストブロック
    var _postsCtrl = Provider.of<PostsBloc>(context);

    return StreamBuilder(
      stream: _postsCtrl.getPostsList,
      builder: (context, AsyncSnapshot snapshot) {
        return (snapshot.hasData)
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(''),
                    ),
                    title: Text(snapshot.data[index].title),
                    subtitle: Text.rich(TextSpan(children: [
                      TextSpan(text: '投稿者:${snapshot.data[index].title}'),
                      WidgetSpan(child: Icon(Icons.star)),
                    ])),
                    isThreeLine: true,
                    onTap: () {},
                  );
                })
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
