import 'package:flutter/material.dart';

//未実装のページの遷移を指定した場合に表示する画面
class UnimplementedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('未実装ページ'),
      ),
      body: Center(
        child: Text('今バージョンでは未実装のページです。\n今後のバージョンアップをお待ちください。'),
      ),
    );
  }
}
