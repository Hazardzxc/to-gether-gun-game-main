import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_gether_gun_game/pages/pay_game.dart';
import 'package:to_gether_gun_game/pages/sign_in_screen.dart';
import 'package:to_gether_gun_game/res/custom_colors.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key, required String roomDocId})
      : _roomDocId = roomDocId,
        super(key: key);

  final String _roomDocId;

  @override
  RoomScreenState createState() => RoomScreenState();
}

class RoomScreenState extends State<RoomScreen> {
  late String _roomDocId;
  late String _createBy;
  List? member = [];

  @override
  void initState() {
    _roomDocId = widget._roomDocId;

    super.initState();
  }

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Palette.firebaseNavy,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 20.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Image.asset(
                              'assets/world-logo.png',
                              height: 150,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '2 Gether',
                            style: TextStyle(
                              color: Palette.firebaseYellow,
                              fontSize: 30,
                            ),
                          ),
                          const Text(
                            'Gun Game',
                            style: TextStyle(
                              color: Palette.firebaseOrange,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(_roomDocId)
                            .snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading");
                          }
                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          if (data['status'] == 0) {
                            _createBy = data['create_by'];
                            member = data['member'] is Iterable
                                ? List.from(data['member'])
                                : null;
                            List<Widget> xx = [];
                            xx.add(
                              const Text(
                                'Welcome !',
                                style: TextStyle(
                                  color: Palette.firebaseGrey,
                                  fontSize: 26,
                                ),
                              ),
                            );
                            for (int i = 0; i < member!.length; i++) {
                              Map<String, dynamic> mem =
                                  member![i] as Map<String, dynamic>;
                              xx.add(
                                Text(
                                  mem['name'],
                                  style: TextStyle(
                                    color: Palette.firebaseYellow,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }

                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [...xx]);
                          } else {
                            return const Text(
                              'เกมส์ได้เริ่ม หรือห้องถูกยกเลิกไปแล้ว !',
                              style: TextStyle(
                                color: Palette.firebaseOrange,
                                fontSize: 26,
                              ),
                            );
                          }
                        }),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Palette.firebaseOrange,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(_roomDocId)
                            .update({'status': 1});

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => PayGameScreen(
                              roomDocId: _roomDocId,
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'START',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Palette.firebaseGrey,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.black26,
                      child: InkWell(
                        splashColor: Colors.black,
                        onTap: () {
                          if (_createBy == box.read('email')) {
                            FirebaseFirestore.instance
                                .collection('rooms')
                                .doc(_roomDocId)
                                .update({'status': 3});
                          } else {
                            member?.removeWhere((element) =>
                                element.email == box.read('email'));
                            FirebaseFirestore.instance
                                .collection('rooms')
                                .doc(_roomDocId)
                                .update({'member': member});
                          }
                          Navigator.of(context).pop();
                        },
                        child: const SizedBox(
                          width: 52,
                          height: 52,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
