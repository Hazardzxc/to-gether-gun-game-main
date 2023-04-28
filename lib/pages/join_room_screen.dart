import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_gether_gun_game/common/widgets/custom_back_button.dart';
import 'package:to_gether_gun_game/common/widgets/join_room_form.dart';
import 'package:to_gether_gun_game/firebase_options.dart';
import 'package:to_gether_gun_game/res/custom_colors.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({Key? key}) : super(key: key);

  @override
  JoinRoomScreenState createState() => JoinRoomScreenState();
}

class JoinRoomScreenState extends State<JoinRoomScreen> {
  final FocusNode _roomIdFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _roomIdFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
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
                    FutureBuilder(
                      future: _initializeFirebase(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error initializing Firebase');
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return JoinRoomForm(
                            roomIdFocusNode: _roomIdFocusNode,
                            passwordFocusNode: _passwordFocusNode,
                          );
                        }
                        return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Palette.firebaseOrange,
                          ),
                        );
                      },
                    )
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
