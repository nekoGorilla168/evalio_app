import 'package:evalio_app/blocs/bottom-navibar-bloc.dart';
import 'package:evalio_app/blocs/display_post_list_bloc.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
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
        // ナビバープロバイダ
        ChangeNotifierProvider<NavigationBarBloc>(
          create: (_) => NavigationBarBloc(),
        ),
        ChangeNotifierProvider<DisplayPostsListBloc>(
          create: (_) => DisplayPostsListBloc(),
        ),
        // ユーザー情報プロバイダ
        Provider<UserBloc>(
          create: (_) => UserBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        // 投稿一覧プロバイダ
        Provider<PostsBloc>(
          create: (_) => PostsBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/loggedIn',
        routes: {
//          '/': (context) => Loading();
          '/loggedIn': (context) => LoggedIn(),
          '/home': (context) => Home(),
        },
      ),
    );
  }
}
