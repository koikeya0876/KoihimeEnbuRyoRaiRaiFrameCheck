import 'package:koihime_enbu_ryorairai_frame_check/utils/tab_helper.dart';
import 'package:koihime_enbu_ryorairai_frame_check/widget/bottom_navigator.dart';
import 'package:koihime_enbu_ryorairai_frame_check/widget/tab_navigator.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  TabItem _currentTab = TabItem.top;
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.top: GlobalKey<NavigatorState>(),
    TabItem.framedata: GlobalKey<NavigatorState>(),
    TabItem.situation: GlobalKey<NavigatorState>(),
    TabItem.hitconfirm: GlobalKey<NavigatorState>(),
    TabItem.memo: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildTabItem(
            TabItem.top,
            '/top',
          ),
          _buildTabItem(
            TabItem.framedata,
            '/framedata',
          ),
          _buildTabItem(
            TabItem.situation,
            '/situation',
          ),
          _buildTabItem(
            TabItem.hitconfirm,
            '/hitconfirm',
          ),
          _buildTabItem(
            TabItem.memo,
            '/memo',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentTab: _currentTab,
        onSelectTab: onSelect,
      ),
    );
  }

  Widget _buildTabItem(
    TabItem tabItem,
    String root,
  ) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigationKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
        routerName: root,
        key: UniqueKey(),
      ),
    );
  }

  void onSelect(TabItem tabItem) {
    if (_currentTab == tabItem) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }
}
