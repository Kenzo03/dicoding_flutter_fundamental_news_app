import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../provider/preferens_provider.dart';
import '../provider/scheduling_provider.dart';
import '../widgets/platform_widgets.dart';
import '../widgets/custom_dialog.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(builder: (context, provider, child) {
      return ListView(
        children: [
          Material(
            child: ListTile(
              title: const Text('Dark Theme'),
              trailing: Switch.adaptive(
                  value: provider.isDarkTheme,
                  onChanged: (value) => provider.enableDarkTheme(value)),
            ),
          ),
          Material(
              child: ListTile(
                  title: const Text('Scheduling News'),
                  trailing: Consumer<SchedulingProvider>(
                      builder: (context, scheduled, _) {
                    return Switch.adaptive(
                        value: provider.isDailyNewsActive,
                        onChanged: (value) async {
                          if (Platform.isIOS) {
                            customDialog(context);
                          } else {
                            scheduled.scheduledNews(value);
                            provider.enableDailyNews(value);
                          }
                        });
                  })))
        ],
      );
    });
  }
}
