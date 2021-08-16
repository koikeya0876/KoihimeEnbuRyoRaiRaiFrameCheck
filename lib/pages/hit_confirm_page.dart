import 'package:flutter/material.dart';

class HitConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ヒット確認'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('確認画面', style: TextStyle(color: Colors.white)),
          onPressed: () {
            // "push"で新規画面に遷移
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                // 遷移先の画面としてリスト追加画面を指定
                return HitConfirmDetailPage();
              }),
            );
          },
        ),
      ),
    );
  }
}

class HitConfirmDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ヒット確認詳細'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('戻るボタン', style: TextStyle(color: Colors.white)),
          onPressed: () {
            // "push"で新規画面に遷移
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
