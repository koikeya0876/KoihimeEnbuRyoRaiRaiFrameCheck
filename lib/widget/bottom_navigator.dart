import 'package:koihime_enbu_ryorairai_frame_check/utils/tab_helper.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: TabItem.top),
        _buildItem(tabItem: TabItem.framedata),
        _buildItem(tabItem: TabItem.situation),
        _buildItem(tabItem: TabItem.memo),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
    );
  }

  BottomNavigationBarItem _buildItem({required TabItem tabItem}) {
    String text = tabName[tabItem] ?? 'bug';
    IconData icon = Icons.layers;
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }

  Color _colorTabMatching({required TabItem item}) {
    final Color returncolor = activeTabColor[item] ?? Colors.grey;
    return currentTab == item ? returncolor : Colors.grey;
  }
}
