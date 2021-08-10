import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('トップページ v1.0'),
      ),
      body: ListView(
        children: <Widget>[
          Text('アプリ概要',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(
              '本Webアプリは恋姫†演武～遼来来～ v3.10のフレーム表を使用し、状況を設定することで確定反撃や有利不利を確認することを目的としたものになります。\nあくまで非公式なものであるため、問題がある場合には削除等の対応を行う可能性があります。また、Firebaseと呼ばれるプラットフォームの無料プランの範囲内で作成しており、1日当たりのアクセス量によっては何らかの不具合が発生する可能性があります。',
              style: TextStyle(height: 1.5, fontSize: 18)),
          Text('使用方法',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(
              '本Webアプリは大きく分けて3種類の使用方法を想定しています。\nフレーム表：フレームを確認したいキャラを選択すれば公式のフレーム表が表示されます。\n状況表示：攻撃側キャラ、防御側キャラ、技、ヒット状況（ガードorノーマルヒットorカウンターヒット）を選択すれば、有利不利の状況と技の振り合いでの勝ち負けを表示します。あくまでフレーム表をもとに計算しているため、持続当てや技のリーチによっては勝敗は変化する可能性があります。\n対策メモ：メモを記入したいキャラを選択すれば調べた内容をもとにキャラ別のメモを記入することができます。対策メモを使用するためにはログインする必要があります。\n対策メモ機能に関しては現在作成中のため、今後のアップデートをお待ちください。',
              style: TextStyle(height: 1.5, fontSize: 18)),
          Text('今後のアップデート予定',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(
              'v1.1: ログイン機能と対策メモ機能の実装\n   TwitterアカウントもしくはGoogleアカウントを用いたログイン機能を実装予定\nv1.2: ヒット確認猶予の確認機能\n    各キャラのキャンセル可能通常技のヒットストップを調査し、そのデータをもとにヒット確認の猶予フレームを計算する機能を追加する予定です。\nそのほか不具合の修正やいただいた改善案への対応はその間のマイナーアップデートにて行う想定です。',
              style: TextStyle(height: 1.5, fontSize: 18)),
          Text('製作者への問い合わせ先',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ElevatedButton(
              onPressed: () {
                launch(
                    'https://mail.google.com/mail/?view=cm&to=solluc17@gmail.com&su=【恋姫演武遼来来フレームデータチェック】問い合わせメール');
              },
              child: Text('Gmail')),
          ElevatedButton(
              onPressed: () {
                launch(
                    'https://twitter.com/messages/compose?recipient_id=yama_p0876');
              },
              child: Text('Twitter')),
        ],
      ),
    );
  }
}
