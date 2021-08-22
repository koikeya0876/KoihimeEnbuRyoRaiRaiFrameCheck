import 'package:koihime_enbu_ryorairai_frame_check/pages/top_page.dart';
import 'package:koihime_enbu_ryorairai_frame_check/pages/frame_data_page.dart';
import 'package:koihime_enbu_ryorairai_frame_check/pages/situation_page.dart';
import 'package:koihime_enbu_ryorairai_frame_check/pages/hit_confirm_page.dart';
import 'package:koihime_enbu_ryorairai_frame_check/pages/memo_page.dart';
import 'package:koihime_enbu_ryorairai_frame_check/pages/unimplemented_page.dart';
import 'package:koihime_enbu_ryorairai_frame_check/utils/tab_helper.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    required Key key,
    required this.tabItem,
    required this.routerName,
    required this.navigationKey,
  }) : super(key: key);

  final TabItem tabItem;
  final String routerName;
  final GlobalKey<NavigatorState> navigationKey;

  Map<String, Widget Function(BuildContext)> _routerBuilder(
          BuildContext context) =>
      {
        '/top': (context) => TopPage(),
        '/framedata': (context) => FrameDataPage(),
        '/situation': (context) => SituationPage(),
        '/hitconfirm': (context) => HitConfirmPage(),
        //'/memo': (context) => MemoPage(),
        '/memo': (context) => UnimplementedPage(),
      };

  @override
  Widget build(BuildContext context) {
    final routerBuilder = _routerBuilder(context);

    return Navigator(
      key: navigationKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute<Widget>(
          builder: (context) {
            return routerBuilder[routerName]!(context);
          },
        );
      },
    );
  }
}
