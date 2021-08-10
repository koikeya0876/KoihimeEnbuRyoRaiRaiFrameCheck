import 'package:flutter/material.dart';

class FrameDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('フレーム表'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('キャラボタン', style: TextStyle(color: Colors.white)),
          onPressed: () {
            // "push"で新規画面に遷移
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                // 遷移先の画面としてリスト追加画面を指定
                return FrameDataDetailPage();
              }),
            );
          },
        ),
      ),
    );
  }
}

class FrameDataDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('フレーム表詳細'),
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
