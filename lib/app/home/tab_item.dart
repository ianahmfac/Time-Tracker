import 'package:flutter/material.dart';

enum TabItem { jobs, entries, account }

class TabItemData {
  final String label;
  final IconData icon;
  const TabItemData({
    required this.label,
    required this.icon,
  });

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(label: 'Jobs', icon: Icons.work),
    TabItem.entries: TabItemData(label: 'Entries', icon: Icons.view_headline),
    TabItem.account: TabItemData(label: 'Account', icon: Icons.person),
  };
}
