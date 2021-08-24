import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HitConfirmPage extends StatefulWidget {
  @override
  _HitConfirmPage createState() => _HitConfirmPage();
}

class _HitConfirmPage extends State<HitConfirmPage> {
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
  List<String> _move = [];
  List<String> _cancelMove = [];
  List<String> _situation = ['未選択', 'ノーマルヒット', 'カウンターヒット'];
  List<DropdownMenuItem<String>> _characters = [];
  List<DropdownMenuItem<String>> _moves = [];
  List<DropdownMenuItem<String>> _cancelMoves = [];
  List<DropdownMenuItem<String>> _situations = [];
  String _selectedCharacter = '';
  String? _selectedMove;
  String? _selectedCancelMove;
  String? _selectedSituation;
  bool _setCompleted = false;

  @override
  void initState() {
    super.initState();
    setCharacters();
    setSituations();
    _selectedCharacter = '未選択';
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

  void setMoveList(String character) async {
    final snapshots = await FirebaseFirestore.instance
        .collection(character)
        .orderBy('表示順')
        .get();
    List<DocumentSnapshot> documentlist = snapshots.docs;
    _move = ['未選択'];
    documentlist.forEach((element) {
      element.data()!.forEach((key, value) {
        if (key == 'ヒットストップF' && value != null) _move.add(element.id);
      });
    });
    convertList(_move, _moves);
  }

  void convertList(List<String> list, List<DropdownMenuItem<String>> menu) {
    menu = [];
    for (String move in list) {
      menu
        ..add(DropdownMenuItem(
          child: Text(
            move,
            style: TextStyle(fontSize: 24.0),
          ),
          value: move,
        ));
    }
    setState(() {
      _setCompleted = true;
      _moves = menu;
    });
  }

  void setCancelMoveList(String character, String move) async {
    final snapshots = await FirebaseFirestore.instance
        .collection(character)
        .orderBy('表示順')
        .get();
    List<DocumentSnapshot> documentlist = snapshots.docs;
    String cancel = '';
    documentlist.forEach((element) {
      if (element.id == move) {
        element.data()!.forEach((key, value) {
          if (key == 'キャンセル') cancel = value;
        });
      }
    });
    _cancelMove = ['未選択'];
    documentlist.forEach((element) {
      bool canceled = false;
      bool unguardable = false;
      bool air = false;
      bool atemi = false;
      element.data()!.forEach((key, value) {
        if (key == 'コマンド' &&
            value is int &&
            value >= 10 &&
            cancel.contains('必殺')) canceled = true;
        if (key == 'ガード' && value == 'ガード不能' && cancel.contains('必殺'))
          unguardable = true;
        if (key == '攻撃高さ' && value == '空中' && cancel.contains('必殺')) air = true;
        if (key == 'シェイク属性' && value == '当て身') atemi = true;
        if (key == '技名' &&
            (value == '立ち小' || value == 'しゃがみ小') &&
            cancel.contains('連打')) canceled = true;
        if (key == '技名' &&
            (value.contains('追加') || value.contains('派生')) &&
            cancel.contains('C')) canceled = true;
        if (key == '技名' && value.contains('キャンセル移行') && cancel.contains('通常'))
          canceled = true;
        if (key == '技名' &&
            value.contains('追加入力') &&
            cancel.contains('追加入力') &&
            !element.id.contains('追加入力2')) canceled = true;
      });
      if ((element.id.contains('冥誘斬・派生') || element.id.contains('冥誘斬・EX・派生')) &&
          cancel.contains('必殺技')) canceled = true;
      if (canceled &&
          !unguardable &&
          !air &&
          !atemi &&
          !element.id.contains('秘奥義')) {
        if (element.id.contains('・移動')) {
          _cancelMove.add(element.id.replaceAll('・移動', ''));
        } else {
          if (element.id != '冥誘斬・小' &&
              element.id != '冥誘斬・中' &&
              element.id != '冥誘斬・大' &&
              element.id != '冥誘斬・EX') {
            if (!(element.id.contains('返し刃') &&
                !element.id.contains(_selectedMove.toString())))
              _cancelMove.add(element.id);
          }
        }
      }
    });
    convertCancelList(_cancelMove);
  }

  void convertCancelList(List<String> list) {
    List<DropdownMenuItem<String>> menu = [];
    _cancelMoves = [];
    for (String move in list) {
      menu
        ..add(DropdownMenuItem(
          child: Text(
            move,
            style: TextStyle(fontSize: 24.0),
          ),
          value: move,
        ));
    }
    setState(() {
      _setCompleted = true;
      _cancelMoves = menu;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ヒット確認状況設定'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'キャラクター選択',
                style: TextStyle(fontSize: 24),
              ),
              DropdownButton(
                items: _characters,
                value: _selectedCharacter,
                onChanged: (String? value) => {
                  setState(() {
                    _selectedCharacter = value!;
                    _setCompleted = false;
                    setMoveList(_selectedCharacter);
                    _selectedMove = '未選択';
                  }),
                },
              ),
            ],
          ),
          (_selectedMove != null &&
                  _selectedCharacter != '未選択' &&
                  _setCompleted)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'キャンセル元技選択',
                      style: TextStyle(fontSize: 24),
                    ),
                    DropdownButton(
                      items: _moves,
                      value: _selectedMove,
                      onChanged: (String? value) => {
                        setState(() {
                          _selectedMove = value!;
                          _selectedCancelMove = '未選択';
                          setCancelMoveList(_selectedCharacter, _selectedMove!);
                        }),
                      },
                    ),
                  ],
                )
              : Container(),
          (_selectedCancelMove != null &&
                  _selectedCharacter != '未選択' &&
                  _selectedMove != '未選択' &&
                  _setCompleted)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'キャンセル先技選択',
                      style: TextStyle(fontSize: 24),
                    ),
                    DropdownButton(
                      items: _cancelMoves,
                      value: _selectedCancelMove,
                      onChanged: (String? value) => {
                        setState(() {
                          _selectedCancelMove = value!;
                          _selectedSituation = '未選択';
                        }),
                      },
                    ),
                  ],
                )
              : Container(),
          (_selectedSituation != null &&
                  _selectedCharacter != '未選択' &&
                  _selectedMove != '未選択' &&
                  _selectedCancelMove != '未選択' &&
                  _setCompleted)
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
          ElevatedButton(
            child: Text('状況表示', style: TextStyle(color: Colors.white)),
            onPressed: !(_selectedCharacter != '未選択' &&
                    _selectedMove != '未選択' &&
                    _selectedCancelMove != '未選択' &&
                    _selectedSituation != '未選択')
                ? null
                : () {
                    // "push"で新規画面に遷移
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        // 遷移先の画面としてリスト追加画面を指定
                        return HitConfirmDetailPage(
                            _selectedCharacter,
                            _selectedMove!,
                            _selectedCancelMove,
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

class HitConfirmDetailPage extends StatefulWidget {
  HitConfirmDetailPage(
      this._character, this._move, this._cancelMove, this._situation);
  final String _character;
  final String _move;
  final String? _cancelMove;
  final String? _situation;
  @override
  _HitConfirmDetailPage createState() => _HitConfirmDetailPage();
}

class _HitConfirmDetailPage extends State<HitConfirmDetailPage> {
  int _confirmGrace = 0;
  int _cancelGrace = 0;
  int _hitstop = 0;
  int _attackLv = 0;
  int _hitFrame = 0;
  int _activeFrame = 0;
  int _counterFrame = 0;
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
  void initState() {
    super.initState();
    calcConfirmGrace();
  }

  void calcConfirmGrace() async {
    final snapshots = await FirebaseFirestore.instance
        .collection(widget._character)
        .orderBy('表示順')
        .get();
    List<DocumentSnapshot> documentlist = snapshots.docs;
    documentlist.forEach((element) {
      if (element.id == widget._move || element.id == widget._cancelMove) {
        element.data()!.forEach((key, value) {
          if (element.id == widget._move) {
            if (key == '持続F')
              _cancelGrace +=
                  int.parse(value.toString().split('/')[0].split('(')[0]);
            if (key == '硬化F')
              _cancelGrace +=
                  int.parse(value.toString().split('/')[0].split('(')[0]);
            if (key == 'ヒットストップF') _hitstop = value;
            if (key == 'アタックLV') _attackLv = value;
            if (key == 'ヒット硬化差') {
              String strHitFrame = value;
              strHitFrame = strHitFrame.replaceAll('- ', '-');
              strHitFrame = strHitFrame.replaceAll('+ ', '+');
              strHitFrame = strHitFrame.replaceAll('± ', '');
              _hitFrame = int.parse(strHitFrame);
            }
          }
          if (element.id == widget._cancelMove) {
            if (key == '発生F') _activeFrame = value;
          }
        });
      }
    });
    if (widget._cancelMove == '暴虎馮河・小') _activeFrame = 21;
    if (widget._cancelMove == '暴虎馮河・中') _activeFrame = 22;
    if (widget._cancelMove == '暴虎馮河・大') _activeFrame = 23;
    if (widget._cancelMove == '怒髪衝天・小') _activeFrame = 10;
    if (widget._cancelMove == '怒髪衝天・中') _activeFrame = 22;
    if (widget._cancelMove == '怒髪衝天・大') _activeFrame = 39;
    if (widget._cancelMove!.contains('冥誘斬・派生')) _activeFrame += 10;
    if (widget._cancelMove!.contains('冥誘斬・EX・派生')) _activeFrame += 7;
    if (widget._cancelMove!.contains('伏撃射・発生')) _activeFrame += 8;
    if (widget._cancelMove!.contains('伏撃射・EX・発生')) _activeFrame += 7;
    if (widget._situation == 'カウンターヒット')
      _counterFrame = _attackLevel[_attackLv];
    setState(() {
      _confirmGrace += _counterFrame +
          _cancelGrace +
          _hitstop +
          _hitFrame -
          (_activeFrame + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ヒット確認猶予表示'),
      ),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(36.0),
          children: <Widget>[
            Card(
              elevation: 0,
              color: Colors.white.withOpacity(0),
              child: Container(
                width: double.infinity,
                child: Text('状況設定',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: Container(
                width: double.infinity,
                child: Text(
                    'キャラクター：' +
                        widget._character +
                        '\nキャンセル元技：' +
                        widget._move +
                        '\nキャンセル先技：' +
                        widget._cancelMove! +
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
                child: Text('ヒット確認猶予',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: _confirmGrace >= 0
                  ? Container(
                      width: double.infinity,
                      child: Text(_confirmGrace.toString() + 'F',
                          style: TextStyle(height: 1.5, fontSize: 18)),
                    )
                  : Container(
                      width: double.infinity,
                      child: Text('この技はつながりません',
                          style: TextStyle(height: 1.5, fontSize: 18)),
                    ),
            ),
            Text(
                'ヒットストップは製作者がゲーム画面を録画して測定したものになります。誤りがある場合には指摘お願いします。\nまた、確認猶予は以下の式で計算しています。計算方法に誤りがある場合にも指摘お願いします。\n（確認猶予）＝（攻撃の持続と硬直F）＋（ヒット硬化差）＋（カウンター時の増加F）＋（ヒットストップF）ー（キャンセル先の発生F＋１）',
                style: TextStyle(height: 1.5, fontSize: 18)),
            Card(
              elevation: 0,
              color: Colors.white.withOpacity(0),
              child: Container(
                width: double.infinity,
                child: Text('使用パラメータ',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: Container(
                width: double.infinity,
                child: Text(
                    '持続+硬直：' +
                        _cancelGrace.toString() +
                        '\nカウンター時の増加F：' +
                        _counterFrame.toString() +
                        '\nヒット硬化差：' +
                        _hitFrame.toString() +
                        '\nヒットストップF：' +
                        _hitstop.toString() +
                        '\nキャンセル先の発生F：' +
                        _activeFrame.toString(),
                    style: TextStyle(height: 1.5, fontSize: 18)),
              ),
            ),
          ]),
    );
  }
}
