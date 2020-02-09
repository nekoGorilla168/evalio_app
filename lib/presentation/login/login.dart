import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/models/user_model.dart';
import 'package:evalio_app/presentation/home/evalio_home.dart';
import 'package:evalio_app/repository/base_auth_repository.dart';
import 'package:evalio_app/repository/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoggedIn extends StatelessWidget {
  // 認証操作
  final _authRepository = AuthRepository();
  // ユーザー情報更新
  final _userRepository = UserRepository();

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
                bool isLoggedIn =
                    await _authRepository.checkLoginRireki(userModel.userId);
                if (isLoggedIn == true) {
                  // ユーザー情報を更新し、ログインする
                  _userRepository.updateUserInfo(userModel);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Home(userModel.userId)));
                } else {
                  // 新規登録
                  _ctrlUser.shinkiToroku(userModel);
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
