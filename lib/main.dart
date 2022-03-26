import './data/preferences/preferences_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './provider/preferens_provider.dart';
import './data/api/api_service.dart';
import './provider/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './data/model/article.dart';
import './ui/article_detail_page.dart';
import './ui/article_web_view.dart';
import './ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(apiService: ApiService()),
        ),
        // ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: Consumer<PreferencesProvider>(builder: (context, provider, child) {
        return MaterialApp(
          title: 'News App',
          theme: provider.themeData,
          builder: (context, child) {
            return CupertinoTheme(
                data: const CupertinoThemeData(),
                child: Material(child: child));
          },
          initialRoute: HomePage.routeName,
          routes: {
            HomePage.routeName: (context) => const HomePage(),
            ArticleDetailPage.routeName: (context) => ArticleDetailPage(
                  article:
                      ModalRoute.of(context)?.settings.arguments as Article,
                ),
            ArticleWebView.routeName: (context) => ArticleWebView(
                  url: ModalRoute.of(context)?.settings.arguments as String,
                ),
          },
        );
      }),
    );
  }
}
