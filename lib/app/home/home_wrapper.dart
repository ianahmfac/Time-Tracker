import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/account/account_page.dart';
import 'package:time_tracker/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker/app/home/jobs/jobs_page.dart';
import 'package:time_tracker/app/home/tab_item.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  TabItem _currentTab = TabItem.jobs;

  Map<TabItem, WidgetBuilder> get _widgetBuilder => {
        TabItem.jobs: (_) => JobsPage(),
        TabItem.entries: (_) => Container(),
        TabItem.account: (_) => AccountPage(),
      };

  final Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await _navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: (item) {
          setState(() {
            _currentTab = item;
          });
        },
        widgetBuilders: _widgetBuilder,
        navigatorKey: _navigatorKeys,
      ),
    );
  }
}
