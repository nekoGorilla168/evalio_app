import 'package:cached_network_image/cached_network_image.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsListAppBar extends StatelessWidget with PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    final _ctrlUser = Provider.of<UserBloc>(context);
    var _postsCtrl = Provider.of<PostsBloc>(context);

    print('Buid ConstAppBar');
    return SafeArea(
        child: StreamBuilder<UserModel>(
            stream: _ctrlUser.getUser,
            builder: (context, snapshot) {
              if (snapshot.data == null) return _loadingAppBar();
              return AppBar(
                leading: Container(), // 「（←）戻る」を非表示にできる
                title: Text('evalio'),
                centerTitle: true,
                actions: <Widget>[
                  CachedNetworkImage(
                    imageUrl: snapshot.data.photoUrl,
                    imageBuilder: (context, imgProvider) => Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imgProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                ],
              );
            }));
  }

  // 読み込み中のappbar
  Widget _loadingAppBar() {
    return SafeArea(
      child: AppBar(
        leading: CircularProgressIndicator(),
        title: Text('loading…'),
        centerTitle: true,
      ),
    );
  }
}
