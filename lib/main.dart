import 'package:evalio_app/blocs/bottom-navibar-bloc.dart';
import 'package:evalio_app/blocs/display_post_list_bloc.dart';
import 'package:evalio_app/blocs/markdown_bloc.dart';
import 'package:evalio_app/blocs/posts_bloc.dart';
import 'package:evalio_app/blocs/search_condition_bloc.dart';
import 'package:evalio_app/blocs/tabbar_view_bloc.dart';
import 'package:evalio_app/blocs/user-bloc.dart';
import 'package:evalio_app/firebase/admob_manage.dart';
import 'package:evalio_app/firebase/firebase_auth.dart';
import 'package:evalio_app/presentation/constant/portfolio_details.dart';
import 'package:evalio_app/presentation/editor/markdown_editor.dart';
import 'package:evalio_app/presentation/home/evalio_home.dart';
import 'package:evalio_app/presentation/login/login.dart';
import 'package:evalio_app/presentation/posts/search_result_posts_list.dart';
import 'package:evalio_app/presentation/profile/other_user_profile.dart';
import 'package:evalio_app/presentation/profile/profile_editor.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

Future main() async {
  // 環境変数Load
  await DotEnv().load('.env');
  FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
  String id = await FireAuth().getCurrentUser();
  runApp(EvalioApp(id));
}

// ルートクラス
class EvalioApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final String id;
  EvalioApp([this.id]);

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
        ChangeNotifierProvider<SearchConditionBloc>(
            create: (_) => SearchConditionBloc()),
        // ユーザー情報プロバイダ
        ChangeNotifierProvider<TabbarViewBloc>(
          create: (_) => TabbarViewBloc(),
        ),
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
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
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
        initialRoute: id == null ? '/loggedIn' : '/home',
        routes: {
          '/loggedIn': (context) => LoggedIn(),
          '/home': (context) => Home(id),
          '/editor': (context) => DescriptionPortfolioEditor(),
          '/profileEditor': (context) => ProfileEditor(),
          '/result': (context) => SearcResultPosts(),
          '/details': (context) => PortfolioDetails(),
          '/otherUserProfile': (context) => OtherUserProfile(),
        },
      ),
    );
  }
}
