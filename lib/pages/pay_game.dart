import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_gether_gun_game/pages/end_game.dart';
import 'package:to_gether_gun_game/pages/sign_in_screen.dart';
import 'package:to_gether_gun_game/res/custom_colors.dart';
import 'dart:async';

class PayGameScreen extends StatefulWidget {
  const PayGameScreen({Key? key, required String roomDocId})
      : _roomDocId = roomDocId,
        super(key: key);

  final String _roomDocId;

  @override
  PayGameScreenState createState() => PayGameScreenState();
}

class PayGameScreenState extends State<PayGameScreen> {
  late String _roomDocId;
  late String _createBy;
  List? member = [];
  List? newMember = [];

  int COUNT_ROW = 14;
  int COUNT_COL = 10;
  double SIZE_AREA_UNIT = 36;

  late Timer _timer;
  int _start = 0;
  int _score = 0;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });

          FirebaseFirestore.instance
              .collection('rooms')
              .doc(_roomDocId)
              .get()
              .then(
            (docSnapshot) {
              final data = docSnapshot.data() as Map<String, dynamic>;
              member =
                  data['member'] is Iterable ? List.from(data['member']) : null;
              for (int i = 0; i < member!.length; i++) {
                Map<String, dynamic> mem = member![i] as Map<String, dynamic>;
                if (mem['email'] == box.read('email')) {
                  final dataHistory = {
                    'player': mem['email'],
                    'score': _score,
                    // 'member': member,
                    'pay_date': DateTime.now(),
                    'room': {
                      'room_id': data['room_id'],
                      'playing_duration': data['playing_duration'],
                      'create_by': data['create_by']
                    }
                  };

                  FirebaseFirestore.instance
                      .collection('history')
                      .add(dataHistory);
                }
              }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => EndGameScreen(
                    roomDocId: _roomDocId,
                  ),
                ),
              );
            },
            onError: (e) => print("Error completing: $e"),
          );

          FirebaseFirestore.instance
              .collection('rooms')
              .doc(_roomDocId)
              .update({'status': 2});
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _roomDocId = widget._roomDocId;
    FirebaseFirestore.instance.collection('rooms').doc(_roomDocId).get().then(
      (docSnapshot) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        _start = int.parse(data['playing_duration']);
        startTimer();
      },
      onError: (e) => print("Error completing: $e"),
    );
    super.initState();
  }

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print('Tapped' + _score.toString());
          _score++;
        },
        child: Scaffold(
          body: Container(
              color: Palette.firebaseNavy,
              child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 12, color: Palette.firebaseGrey),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...buildGameArea(),
                            Text(
                              "$_start",
                              style: TextStyle(
                                color: Palette.firebaseGrey,
                                fontSize: 26,
                              ),
                            ),
                            Text(
                              "score : $_score",
                              style: TextStyle(
                                color: Palette.firebaseGrey,
                                fontSize: 20,
                              ),
                            )
                          ])))),
        ));
  }

  List<Widget> buildGameArea() {
    List<Widget> list = [];
    for (int i = 0; i < COUNT_ROW; i++) {
      list.add(buildRow());
    }
    return list;
  }

  Row buildRow() {
    List<Widget> list = [];
    for (int i = 0; i < COUNT_COL; i++) {
      list.add(buildAreaUnit());
    }
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: list);
  }

  Widget buildAreaUnit() {
    return Container(
        width: SIZE_AREA_UNIT,
        height: SIZE_AREA_UNIT,
        decoration: BoxDecoration(
            color: Palette.firebaseNavy,
            border: Border.all(width: 1, color: Palette.firebaseNavy)));
  }
}
