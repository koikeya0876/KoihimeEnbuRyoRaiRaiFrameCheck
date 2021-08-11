import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final character = [
  '夏侯惇',
  '夏侯淵',
  '楽進',
  '甘寧',
  '関羽',
  '軍師',
  '周泰',
  '徐晃',
  '曹操',
  '孫権',
  '孫尚香',
  '張飛',
  '張遼',
  '馬超',
  '呂布',
  '趙雲',
];

List<String> framecolumns = [
  '技名',
  '状態',
  'コマンド',
  'ボタン',
  '発生条件1',
  '発生条件2',
  '発生距離',
  'シェイク属性',
  '攻撃高さ',
  'ガード',
  '補足',
  'ヒット数',
  'アタックLv',
  '発生F',
  '持続F',
  '硬化F',
  '全体F',
  'カウンターF',
  'ヒット硬化差',
  'ガード硬化差',
  '攻撃リーチ',
  'ダメージ',
  '削りダメージ',
  'ダメージ保証',
  'ゲージ',
  '受け身',
  'キャンセル',
  'C猶予',
  '通常やられ',
  'カウンターやられ',
  '空中やられ',
  '空中カウンターやられ',
  '崩撃コンボ中',
  '崩撃コンボ中空中',
  '崩撃コンボ中2度目',
  '崩撃コンボ中2度目空中',
  '無敵フレーム',
  '備考',
];

class FrameDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('キャラ選択画面'),
      ),
      body: ListView.builder(
        itemCount: character.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            child: Text(character[index],
                style: TextStyle(color: Colors.white, fontSize: 22)),
            onPressed: () {
              // "push"で新規画面に遷移
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  // 遷移先の画面としてリスト追加画面を指定
                  return FrameDataDetailPage(character[index]);
                }),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue, //ボタンの背景色
              side: BorderSide(
                //color: Colors.blue, //枠線!
                color: Colors.white, //枠線!
                width: 1, //枠線！
              ),
            ),
          );
        },
      ),
    );
  }
}

class FrameDataDetailPage extends StatelessWidget {
  FrameDataDetailPage(this.character);
  final String character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('フレーム表（' + character + '）'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection(character)
                    .orderBy('表示順')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  columns: <DataColumn>[
                                    DataColumn(label: Text(framecolumns[0])),
                                    DataColumn(label: Text(framecolumns[1])),
                                    DataColumn(label: Text(framecolumns[2])),
                                    DataColumn(label: Text(framecolumns[3])),
                                    DataColumn(label: Text(framecolumns[4])),
                                    DataColumn(label: Text(framecolumns[5])),
                                    DataColumn(label: Text(framecolumns[6])),
                                    DataColumn(label: Text(framecolumns[7])),
                                    DataColumn(label: Text(framecolumns[8])),
                                    DataColumn(label: Text(framecolumns[9])),
                                    DataColumn(label: Text(framecolumns[10])),
                                    DataColumn(label: Text(framecolumns[11])),
                                    DataColumn(label: Text(framecolumns[12])),
                                    DataColumn(label: Text(framecolumns[13])),
                                    DataColumn(label: Text(framecolumns[14])),
                                    DataColumn(label: Text(framecolumns[15])),
                                    DataColumn(label: Text(framecolumns[16])),
                                    DataColumn(label: Text(framecolumns[17])),
                                    DataColumn(label: Text(framecolumns[18])),
                                    DataColumn(label: Text(framecolumns[19])),
                                    DataColumn(label: Text(framecolumns[20])),
                                    DataColumn(label: Text(framecolumns[21])),
                                    DataColumn(label: Text(framecolumns[22])),
                                    DataColumn(label: Text(framecolumns[23])),
                                    DataColumn(label: Text(framecolumns[24])),
                                    DataColumn(label: Text(framecolumns[25])),
                                    DataColumn(label: Text(framecolumns[26])),
                                    DataColumn(label: Text(framecolumns[27])),
                                    DataColumn(label: Text(framecolumns[28])),
                                    DataColumn(label: Text(framecolumns[29])),
                                    DataColumn(label: Text(framecolumns[30])),
                                    DataColumn(label: Text(framecolumns[31])),
                                    DataColumn(label: Text(framecolumns[32])),
                                    DataColumn(label: Text(framecolumns[33])),
                                    DataColumn(label: Text(framecolumns[34])),
                                    DataColumn(label: Text(framecolumns[35])),
                                    DataColumn(label: Text(framecolumns[36])),
                                    DataColumn(label: Text(framecolumns[37]))
                                  ],
                                  rows: documents
                                      .map(
                                        (document) => DataRow(
                                          cells: [
                                            DataCell(Text((document.data()![
                                                        framecolumns[0]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[1]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[2]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[3]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[4]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[5]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[6]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[7]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[8]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[9]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[10]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[11]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[12]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[13]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[14]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[15]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[16]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[17]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[18]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[19]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[20]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[21]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[22]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[23]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[24]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[25]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[26]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[27]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[28]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[29]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[30]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[31]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[32]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[33]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[34]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[35]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[36]] ??
                                                    '-')
                                                .toString())),
                                            DataCell(Text((document.data()![
                                                        framecolumns[37]] ??
                                                    '-')
                                                .toString()))
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ))));
                  }
                  return Center(
                    child: Text('読込中...'),
                  );
                }),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              child: Text('キャラ一覧に戻る', style: TextStyle(color: Colors.white)),
              onPressed: () {
                // "push"で新規画面に遷移
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
