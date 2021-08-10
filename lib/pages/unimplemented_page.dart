import 'package:flutter/material.dart';

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
