import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_gether_gun_game/pages/pay_game.dart';
import 'package:to_gether_gun_game/pages/sign_in_screen.dart';
import 'package:to_gether_gun_game/res/custom_colors.dart';

class EndGameScreen extends StatefulWidget {
  const EndGameScreen({Key? key, required String roomDocId})
      : _roomDocId = roomDocId,
        super(key: key);

  final String _roomDocId;

  @override
  EndGameScreenState createState() => EndGameScreenState();
}

class EndGameScreenState extends State<EndGameScreen> {
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

                          _createBy = data['create_by'];
                          member = data['member'] is Iterable
                              ? List.from(data['member'])
                              : null;
                          List<Widget> xx = [];
                          xx.add(
                            const Text(
                              'Score !',
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
                                mem['name'] + ' : ' + mem['score'].toString(),
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
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text(
                          'END GAME',
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
            ],
          ),
        ),
      ),
    );
  }
}
