import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:time_tracker/app/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKey;
  const CupertinoHomeScaffold({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
    required this.widgetBuilders,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildNavbarItem(TabItem.jobs),
          _buildNavbarItem(TabItem.entries),
          _buildNavbarItem(TabItem.account),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
        activeColor: Colors.indigo,
        inactiveColor: Colors.grey,
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          builder: (context) {
            return widgetBuilders[item]!(context);
          },
          navigatorKey: navigatorKey[item],
        );
      },
    );

    // For Material Bottom Navbar
    // return Scaffold(
    //   body: widgetBuilders[currentTab]!(context),
    //   bottomNavigationBar: BottomAppBar(
    //     child: BottomNavigationBar(
    //       elevation: 0,
    //       backgroundColor: Colors.white,
    //       items: [
    //         _buildNavbarItem(TabItem.jobs),
    //         _buildNavbarItem(TabItem.entries),
    //         _buildNavbarItem(TabItem.account),
    //       ],
    //       onTap: (value) => onSelectTab(TabItem.values[value]),
    //       selectedItemColor: Colors.indigo,
    //       unselectedItemColor: Colors.grey,
    //       currentIndex: currentTab.index,
    //     ),
    //   ),
    // );
  }

  BottomNavigationBarItem _buildNavbarItem(TabItem tabItem) {
    final tabData = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(tabData?.icon),
      label: tabData?.label,
    );
  }
}
