import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:get_storage/get_storage.dart';

import 'pages/sign_in_screen.dart';
import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return MaterialApp(
        title: 'Emergency Accident Alert',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'OpenSans',
        ),
        home: (const SignInScreen()));
    // home: ((box.read('email') != '' || box.read('email') != null)
    //     ? const LoginPage(title: 'Login UI')
    //     : const HomePage(title: 'HomePage UI')));
  }
}
