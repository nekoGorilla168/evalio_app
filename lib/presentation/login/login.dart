import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:evalio_app/presentation/home/evalio_home.dart';
import 'package:evalio_app/repository/base_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoggedIn extends StatelessWidget {
  final _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    final _ctrlUser = Provider.of<UserBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
        leading: Container(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              color: Colors.lightBlue, // デフォルトの色
              splashColor: Colors.blue, // 押下時の色
              child: Text(
                'Twitter Login',
                style: TextStyle(color: Colors.white), // 文字色(白)
              ),
              onPressed: () async {
                // ログイン情報取得
                UserModel userModel =
                    await _authRepository.getFromFirebaseAuth();
                bool isLogin =
                    await _authRepository.checkLoginRireki(userModel.userId);
                if (isLogin) {
                  Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(userModel.userId)));
                } else {
                  _ctrlUser.shinkiToroku(userModel);
                  Navigator.popAndPushNamed(context, '/home');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
