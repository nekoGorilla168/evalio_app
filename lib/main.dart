import 'package:evalio_app/blocs/bottom-navibar-bloc.dart';
import 'package:evalio_app/blocs/display_post_list_bloc.dart';
import 'package:evalio_app/blocs/markdown_bloc.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/presentation/editor/markdown_editor.dart';
import 'package:evalio_app/presentation/home/evalio_home.dart';
import 'package:evalio_app/presentation/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  // 環境変数Load
  await DotEnv().load('.env');
  String userInfo = await checkLoggedIn();
  runApp(EvalioApp(userInfo));
}

// ログインチェック
Future<String> checkLoggedIn() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString(DotEnv().env['TWITTER_REGISTERED']);
}

// ルートクラス
class EvalioApp extends StatelessWidget {
  final userInfo;

  EvalioApp(this.userInfo);

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
        ChangeNotifierProvider<MarkDownBloc>(
          create: (_) => MarkDownBloc(),
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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ja', ''),
        ],
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: userInfo == null ? '/loggedIn' : '/home',
        routes: {
          '/loggedIn': (context) => LoggedIn(),
          '/home': (context) => Home(userInfo),
          '/editor': (context) => DescriptionPortfolioEditor(),
        },
      ),
    );
  }
}
