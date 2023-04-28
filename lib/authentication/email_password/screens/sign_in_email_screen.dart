import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_gether_gun_game/firebase_options.dart';
import 'package:to_gether_gun_game/pages/home.dart';
import 'package:to_gether_gun_game/pages/sign_in_screen.dart';
import 'package:to_gether_gun_game/res/custom_colors.dart';

import '../widgets/sign_in_form.dart';

class SignInEmailScreen extends StatefulWidget {
  const SignInEmailScreen({Key? key}) : super(key: key);

  @override
  SignInEmailScreenState createState() => SignInEmailScreenState();
}

class SignInEmailScreenState extends State<SignInEmailScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (!mounted) return firebaseApp;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _emailFocusNode.unfocus();
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
                          return SignInForm(
                            emailFocusNode: _emailFocusNode,
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
                    // SignInForm(
                    //   emailFocusNode: _emailFocusNode,
                    //   passwordFocusNode: _passwordFocusNode,
                    // ),
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
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
