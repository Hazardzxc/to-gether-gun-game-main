import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_gether_gun_game/common/widgets/custom_back_button.dart';
import 'package:to_gether_gun_game/pages/pay_game.dart';
import 'package:to_gether_gun_game/pages/sign_in_screen.dart';
import 'package:to_gether_gun_game/res/custom_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
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
                            .collection('history')
                            .where('player', isEqualTo: box.read('email'))
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
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

                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> mem =
                                    document.data()! as Map<String, dynamic>;
                                print(mem);
                                return Text(
                                  box.read('name') +
                                      ' score: ' +
                                      mem['score'].toString(),
                                  style: TextStyle(
                                    color: Palette.firebaseYellow,
                                    fontSize: 20,
                                  ),
                                );
                              }).toList());
                        }),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
              const CustomBackButton(),
            ],
          ),
        ),
      ),
    );
  }
}
