import 'package:flutter/material.dart';
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
        TabItem.account: (_) => Container(),
      };

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: (item) {
        setState(() {
          _currentTab = item;
        });
      },
      widgetBuilders: _widgetBuilder,
    );
  }
}
