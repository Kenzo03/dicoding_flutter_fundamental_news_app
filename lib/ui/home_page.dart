import 'dart:io';

import '../utils/notification_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './article_list_page.dart';
import '../widgets/platform_widgets.dart';
import './settings_page.dart';
import './article_detail_page.dart';
import './bookmarks_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  static const String _headlineText = 'Headline';
  final NotificationHelper _notificationHelper = NotificationHelper();

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.news : Icons.public),
      label: _headlineText,
    ),
    BottomNavigationBarItem(
        icon: Icon(Platform.isIOS
            ? CupertinoIcons.bookmark
            : Icons.collections_bookmark),
        label: BookmarksPage.bookmarksTitle),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: SettingsPage.settingsTitle,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  final List<Widget> _listWidget = [
    const ArticleListPage(),
    const BookmarksPage(),
    const SettingsPage(),
  ];

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        body: _listWidget[_bottomNavIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomNavIndex,
            items: _bottomNavBarItems,
            onTap: _onBottomNavTapped));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: _bottomNavBarItems),
        tabBuilder: (context, index) {
          return _listWidget[index];
        });
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(ArticleDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
