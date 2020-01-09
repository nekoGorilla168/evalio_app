import 'package:evalio_app/blocs/bottom-navibar-bloc.dart';
import 'package:evalio_app/presentation/home/evalio_home.dart';
import 'package:evalio_app/presentation/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  // 環境変数Load
  await DotEnv().load('.env');
  runApp(EvalioApp());
}

// ルートクラス
class EvalioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNaviBarBloc>(
          create: (_) => BottomNaviBarBloc(),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/loggedIn',
        routes: {
          '/loggedIn': (context) => LoggedIn(),
          '/home': (context) => Home(),
        },
      ),
    );
  }
}
