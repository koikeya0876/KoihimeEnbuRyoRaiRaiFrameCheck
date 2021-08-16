import 'package:flutter/material.dart';

enum TabItem {
  top,
  framedata,
  situation,
  hitconfirm,
  memo,
}

Map<TabItem, String> tabName = {
  TabItem.top: 'トップ',
  TabItem.framedata: 'フレーム表',
  TabItem.situation: '状況表示',
  TabItem.hitconfirm: 'ヒット確認猶予',
  TabItem.memo: '対策メモ',
};

Map<TabItem, MaterialColor> activeTabColor = {
  TabItem.top: Colors.lightBlue,
  TabItem.framedata: Colors.lightBlue,
  TabItem.situation: Colors.lightBlue,
  TabItem.hitconfirm: Colors.lightBlue,
  TabItem.memo: Colors.lightBlue,
};

class TabHelper {
  TabHelper();

  MaterialColor color(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.top:
        return Colors.lightBlue;
      case TabItem.framedata:
        return Colors.lightBlue;
      case TabItem.situation:
        return Colors.lightBlue;
      case TabItem.hitconfirm:
        return Colors.lightBlue;
      case TabItem.memo:
        return Colors.lightBlue;
    }
  }

  Widget description(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.top:
        return Text('トップ画面');
      case TabItem.framedata:
        return Text('フレーム表');
      case TabItem.situation:
        return Text('状況表示');
      case TabItem.hitconfirm:
        return Text('ヒット確認猶予');
      case TabItem.memo:
        return Text('対策メモ');
    }
  }
}
