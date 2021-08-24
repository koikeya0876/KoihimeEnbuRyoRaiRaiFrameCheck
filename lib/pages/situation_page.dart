import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//状況設定画面
class SituationPage extends StatefulWidget {
  @override
  _SituationPage createState() => _SituationPage();
}

class _SituationPage extends State<SituationPage> {
//キャラクター選択肢
  List<String> _character = [
    '未選択',
    '関羽',
    '張飛',
    '趙雲',
    '馬超',
    '曹操',
    '夏侯惇',
    '夏侯淵',
    '楽進',
    '徐晃',
    '孫権',
    '孫尚香',
    '甘寧',
    '周泰',
    '呂布',
    '張遼',
  ];
  //技選択肢
  List<String> _move = [];
  //状況選択肢
  List<String> _situation = ['未選択', 'ガード', 'ノーマルヒット', 'カウンターヒット'];
  //ボタン表示用リスト
  List<DropdownMenuItem<String>> _characters = [];
  List<DropdownMenuItem<String>> _moves = [];
  List<DropdownMenuItem<String>> _situations = [];
  //選択された状況
  String _selectedAttackCharacter = '';
  String _selectedDefenceCharacter = '';
  String? _selectedMove;
  String? _selectedSituation;
  bool _setCompleted = false;

  @override
  //初期化
  void initState() {
    super.initState();
    //キャラクターリスト設定
    setCharacters();
    //状況リスト設定
    setSituations();
    _selectedAttackCharacter = '未選択';
    _selectedDefenceCharacter = '未選択';
  }

  void setCharacters() {
    for (String character in _character) {
      _characters
        ..add(DropdownMenuItem(
          child: Text(
            character,
            style: TextStyle(fontSize: 24.0),
          ),
          value: character,
        ));
    }
  }

  void setMoves(List<String> list) {
    _moves = [];
    for (String move in list) {
      _moves
        ..add(DropdownMenuItem(
          child: Text(
            move,
            style: TextStyle(fontSize: 24.0),
          ),
          value: move,
        ));
    }
    _setCompleted = true;
  }

  void setSituations() {
    for (String situation in _situation) {
      _situations
        ..add(DropdownMenuItem(
          child: Text(
            situation,
            style: TextStyle(fontSize: 24.0),
          ),
          value: situation,
        ));
    }
  }

//選択したキャラクターの技名一覧取得
  void setMoveList(String character) async {
    final snapshots = await FirebaseFirestore.instance
        .collection(character)
        .orderBy('表示順')
        .get();
    List<DocumentSnapshot> documentlist = snapshots.docs;
    _move = ['未選択'];
    documentlist.forEach((element) {
      if (!element.id.contains('移動')) _move.add(element.id);
    });
    setMoves(_move);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('状況選択'),
      ),
      //各状況設定項目をカラムで表示
      body: Column(
        children: <Widget>[
          //選択肢の名称とドロップダウンをロウで表示
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                '防御側キャラクター',
                style: TextStyle(fontSize: 24),
              ),
              DropdownButton(
                items: _characters,
                value: _selectedDefenceCharacter,
                onChanged: (String? value) => {
                  setState(() {
                    _selectedDefenceCharacter = value!;
                  }),
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                '攻撃側キャラクター',
                style: TextStyle(fontSize: 24),
              ),
              DropdownButton(
                items: _characters,
                value: _selectedAttackCharacter,
                onChanged: (String? value) => {
                  setState(() {
                    _setCompleted = false;
                    _selectedAttackCharacter = value!;
                    _selectedMove = '未選択';
                    _selectedSituation = '未選択';
                    setMoveList(_selectedAttackCharacter);
                  }),
                },
              ),
            ],
          ),
          (_selectedSituation != null && _selectedAttackCharacter != '未選択')
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '状況選択',
                      style: TextStyle(fontSize: 24),
                    ),
                    DropdownButton(
                      items: _situations,
                      value: _selectedSituation,
                      onChanged: (String? value) => {
                        setState(() {
                          _selectedSituation = value!;
                        }),
                      },
                    ),
                  ],
                )
              : Container(),
          (_selectedMove != null &&
                  _selectedAttackCharacter != '未選択' &&
                  _setCompleted)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '技選択',
                      style: TextStyle(fontSize: 24),
                    ),
                    DropdownButton(
                      items: _moves,
                      value: _selectedMove,
                      onChanged: (String? value) => {
                        setState(() {
                          _selectedMove = value!;
                        }),
                      },
                    ),
                  ],
                )
              : Container(),
          ElevatedButton(
            child: Text('状況表示', style: TextStyle(color: Colors.white)),
            onPressed: !(_selectedAttackCharacter != '未選択' &&
                    _selectedDefenceCharacter != '未選択' &&
                    _selectedMove != '未選択' &&
                    _selectedMove != null &&
                    _selectedSituation != '未選択')
                ? null
                : () {
                    // "push"で新規画面に遷移
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        // 遷移先の画面としてリスト追加画面を指定
                        return SituationDetailPage(
                            _selectedAttackCharacter,
                            _selectedDefenceCharacter,
                            _selectedMove,
                            _selectedSituation);
                      }),
                    );
                  },
          ),
        ],
      ),
    );
  }
}

class SituationDetailPage extends StatefulWidget {
  SituationDetailPage(this._attackCharacter, this._defenceCharacter, this._move,
      this._situation);
  final String _attackCharacter;
  final String _defenceCharacter;
  final String? _move;
  final String? _situation;

  @override
  _SituationDetailPage createState() => _SituationDetailPage();
}

class _SituationDetailPage extends State<SituationDetailPage> {
  int? _situationFrame = 0;
  String _situation = '';
  bool _cancelPossible = false;
  List<int> _attackLevel = [
    2,
    3,
    3,
    4,
    4,
    4,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
  ];
  List<Map<String, String>> _punishMove = [];

  @override
  void initState() {
    super.initState();
    setParameter();
  }

  void setParameter() async {
    int? attackLV;
    String? blockF;
    String? hitF;
    int blockParameter = 0;
    int hitParameter = 0;
    final snapshot = await FirebaseFirestore.instance
        .collection(widget._attackCharacter)
        .doc(widget._move)
        .get();
    snapshot.data()!.forEach((key, value) {
      if (key == 'アタックLV') attackLV = value;
      if (key == 'ガード硬化差') blockF = value;
      if (key == 'ヒット硬化差') hitF = value;
      if (key == 'キャンセル') {
        if (value == '×' || value == 'D') {
          _cancelPossible = false;
        } else {
          _cancelPossible = true;
        }
      }
    });
    if (blockF == "-" && widget._situation == "ガード") {
      _situationFrame = null;
      setSituation();
    } else {
      blockParameter = moldingString(blockF!);
      hitParameter = moldingString(hitF!);
      _situationFrame =
          calcSituationFrame(blockParameter, hitParameter, attackLV!);
      setSituation();
    }
  }

  void setSituation() async {
    String situation = '';
    if (_situationFrame == null) {
      situation = 'この技は防御できません';
    } else if (_situationFrame! > 0) {
      situation = '防御側は' + _situationFrame!.abs().toString() + 'F有利です';
    } else if (_situationFrame! < 0) {
      situation = '防御側は' + _situationFrame!.abs().toString() + 'F不利です';
    } else if (_situationFrame! == 0) {
      situation = '状況五分です';
    } else {
      situation = '計算に失敗しました';
    }
    if ((_situationFrame! >= 0 || _situationFrame! < 0) && _cancelPossible)
      situation = situation + '（キャンセル可能）';
    setState(() {
      _situation = situation;
    });
    setPunishMove();
  }

  void setPunishMove() async {
    if (_situationFrame == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection(widget._defenceCharacter)
        .orderBy("発生F")
        .get();
    List<DocumentSnapshot> documentlist = snapshot.docs;
    _punishMove = [];
    List<String> punishList = [];
    documentlist.forEach((element) {
      element.data()!.forEach((key, value) {
        if (key == '発生F' &&
            value != '-' &&
            value != '' &&
            value <= _situationFrame &&
            !element.id.contains('追加') &&
            !element.id.contains('派生') &&
            !element.id.contains('中断') &&
            !element.id.contains('最終段') &&
            !element.id.contains('5段目') &&
            !element.id.contains('３段目') &&
            !element.id.contains('４段目') &&
            !element.id.contains('５段目') &&
            !element.id.contains('・2段目') &&
            !element.id.contains('移動') &&
            !element.id.contains('秘奥義') &&
            !element.id.contains('威信斬・中') &&
            !element.id.contains('威信斬・大') &&
            !element.id.contains('威信斬・当て身成功') &&
            !element.id.contains('キャンセル') &&
            !element.id.contains('不惜身命') &&
            !element.id.contains('3段目')) {
          if (element.id.contains('怒髪衝天')) {
            if (element.id.contains('・小・') && value + 5 <= _situationFrame)
              punishList.add(element.id);
            if (element.id.contains('中') && value + 17 <= _situationFrame)
              punishList.add(element.id);
            if (element.id.contains('・大・') && value + 34 <= _situationFrame)
              punishList.add(element.id);
          } else if (element.id.contains('暴虎')) {
            if (element.id.contains('・小・') && value + 19 <= _situationFrame)
              punishList.add(element.id);
            if (element.id.contains('中') && value + 20 <= _situationFrame)
              punishList.add(element.id);
            if (element.id.contains('・大・') && value + 21 <= _situationFrame)
              punishList.add(element.id);
          } else if (element.id.contains('冥誘斬')) {
            if (element.id.contains('・小・') &&
                16 <= int.parse(_situationFrame.toString()))
              punishList.add(element.id);
            if (element.id.contains('中') &&
                24 <= int.parse(_situationFrame.toString()))
              punishList.add(element.id);
            if (element.id.contains('・大・') &&
                30 <= int.parse(_situationFrame.toString()))
              punishList.add(element.id);
          } else {
            if (value != '-') punishList.add(element.id);
          }
        }
      });
    });
    documentlist.forEach((element) {
      if (punishList.indexOf(element.id) != -1) {
        element.data()!.forEach((key, value) {
          if (key == '状態' && value == '空中') punishList.remove(element.id);
        });
      }
    });
    documentlist.forEach((element) {
      if (punishList.indexOf(element.id) != -1) {
        String moveName = '';
        String startUp = '';
        String reach = '';
        String cancel = '';
        element.data()!.forEach((key, value) {
          if (key == '技名') {
            moveName = value;
          }
          if (key == '発生F') {
            startUp = value.toString();
          }
          if (key == '攻撃リーチ') {
            if (value == "-") {
              reach = value;
            } else if (value is String) {
              List individualreach = value.split('/');
              reach = individualreach[0];
            } else {
              reach = value.toString();
            }
          }
          if (key == 'キャンセル') {
            cancel = value;
          }
        });
        if (moveName == '怒髪衝天・小・攻撃') startUp = '10';
        if (moveName == '怒髪衝天・中・攻撃') startUp = '22';
        if (moveName == '怒髪衝天・大・攻撃') startUp = '39';
        if (moveName == '暴虎馮河・小・攻撃') startUp = '21';
        if (moveName == '暴虎馮河・中・攻撃') startUp = '22';
        if (moveName == '暴虎馮河・大・攻撃') startUp = '23';
        if (moveName == '冥誘斬・小') startUp = '16';
        if (moveName == '冥誘斬・中') startUp = '24';
        if (moveName == '冥誘斬・大') startUp = '30';
        setState(() {
          if (moveName != '' && startUp != '' && reach != '' && cancel != '')
            _punishMove.add({
              "技名": moveName,
              "発生F": startUp,
              "攻撃リーチ": reach,
              "キャンセル": cancel
            });
          print(moveName + " " + startUp + " " + reach + " " + cancel);
        });
      }
    });
  }

  int moldingString(String frame) {
    frame = frame.replaceAll('- ', '-');
    frame = frame.replaceAll('+ ', '+');
    frame = frame.replaceAll('± ', '');
    return int.parse(frame);
  }

  int calcSituationFrame(int block, int hit, int level) {
    int parameter = 0;
    if (widget._situation == 'ガード') {
      parameter = block;
    } else if (widget._situation == 'ノーマルヒット') {
      parameter = hit;
    } else if (widget._situation == 'カウンターヒット') {
      parameter = hit + _attackLevel[level];
    } else {
      parameter = 0;
    }
    return -parameter;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('状況表示'),
      ),
      body:
          ListView(shrinkWrap: true, padding: EdgeInsets.all(36.0), children: <
              Widget>[
        Card(
          elevation: 0,
          color: Colors.white.withOpacity(0),
          child: Container(
            width: double.infinity,
            child: Text('状況設定',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
        ),
        Card(
          child: Container(
            width: double.infinity,
            child: Text(
                '防御側キャラクター：' +
                    widget._defenceCharacter +
                    '\n攻撃側キャラクター：' +
                    widget._attackCharacter +
                    '\n技：' +
                    widget._move! +
                    '\n状況：' +
                    widget._situation!,
                style: TextStyle(height: 1.5, fontSize: 18)),
          ),
        ),
        Card(
          elevation: 0,
          color: Colors.white.withOpacity(0),
          child: Container(
            width: double.infinity,
            child: Text('有利不利',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
        ),
        Card(
          child: Container(
            width: double.infinity,
            child:
                Text(_situation, style: TextStyle(height: 1.5, fontSize: 18)),
          ),
        ),
        Card(
          elevation: 0,
          color: Colors.white.withOpacity(0),
          child: Container(
            width: double.infinity,
            child: Text('確反リスト',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
        ),
        (widget._situation == "ガード" && _cancelPossible)
            ? Card(
                child: Container(
                  width: double.infinity,
                  child: Text(
                      'ガードした技はキャンセル可能技です。\n現在表示している確反リストはキャンセルしない場合の確反です。キャンセルされた場合はキャンセル後の技の確反を改めて確認してください。',
                      style: TextStyle(height: 1.5, fontSize: 18)),
                ),
              )
            : Card(),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: <DataColumn>[
                  DataColumn(label: Text('技名')),
                  DataColumn(label: Text('発生F')),
                  DataColumn(label: Text('攻撃リーチ')),
                  DataColumn(label: Text('キャンセル')),
                ],
                rows: _punishMove
                    .map(
                      ((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(element["技名"]!)),
                              DataCell(Text(element["発生F"]!)),
                              DataCell(Text(element["攻撃リーチ"]!)),
                              DataCell(Text(element["キャンセル"]!)),
                            ],
                          )),
                    )
                    .toList(),
              ),
            ))),
        ElevatedButton(
          child: Text('状況選択に戻る', style: TextStyle(color: Colors.white)),
          onPressed: () {
            // "push"で新規画面に遷移
            Navigator.of(context).pop();
          },
        ),
      ]),
    );
  }
}
