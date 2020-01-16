import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ctrlUser = Provider.of<UserBloc>(context);

    return StreamBuilder<UserModel>(
        stream: _ctrlUser.getUser,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: 110.0,
                    height: 110.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(snapshot.data.photoUrl),
                        )),
                  ),
                  Column(
                    children: <Widget>[
                      Text(snapshot.data.userName),
                      Text(snapshot.data.createdAt.toString()),
                    ],
                  ),
                  Divider(
                    color: Colors.blueGrey,
                  )
                ],
              ),
            );
          }
        });
  }
}
