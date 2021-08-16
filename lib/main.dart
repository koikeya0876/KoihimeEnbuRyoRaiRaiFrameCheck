import 'package:flutter/material.dart';
import 'package:koihime_enbu_ryorairai_frame_check/widget/app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '恋姫演武遼来来フレームデータチェック',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: App(),
    );
  }
}
