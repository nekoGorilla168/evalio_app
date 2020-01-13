import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostsListAppBar extends StatelessWidget with PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    final _ctrlUser = Provider.of<UserBloc>(context);
    print('Buid ConstAppBar');
    return SafeArea(
        child: StreamBuilder<UserModel>(
            stream: _ctrlUser.getUser,
            builder: (context, snap) {
              return AppBar(
                leading: Container(), // 「（←）戻る」を非表示にできる
                title: Text('evalio'),
                centerTitle: true,
                actions: <Widget>[
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(''),
                  ),
                ],
              );
            }));
  }
}
