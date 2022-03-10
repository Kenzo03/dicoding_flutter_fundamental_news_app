import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './article_list_page.dart';
import './widgets/platform_widgets.dart';
import './settings_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomNavIndex = 0;

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        body: bottomNavIndex == 0
            ? const ArticleListPage()
            : const SettingsPage(),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: bottomNavIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.public), label: 'Headline'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
            onTap: (selected) {
              setState(() {
                bottomNavIndex = selected;
              });
            }));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: const [
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Headline'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ]),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return const ArticleListPage();
            case 1:
              return const SettingsPage();
            default:
              return const ArticleListPage();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('News App'),
    //   ),
    //   body: _buildList(context),
    // );
  }
}
