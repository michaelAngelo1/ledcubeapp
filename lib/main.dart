import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/db_instance.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

// Splash screen libs
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'pages/home.dart';
import 'pages/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Gigalux",
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 241, 245, 255),
                fontSize: 36.0,
                fontWeight: FontWeight.w600,
              )
            ),
            Text(
              "Innovative Advertising",
              style: GoogleFonts.cookie(
                color: const Color.fromARGB(255, 241, 245, 255),
                fontSize: 19.0,
                fontWeight: FontWeight.w400,
              )
            ),
          ]
        ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.blue,
        nextScreen: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              debugPrint("ERROR FLUTTER: ${snapshot.error.toString()}");
              return const Text("Something went wrong.");
            }
            else if(snapshot.hasData){
              return const LoginPage();
            }
            else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        ),
      )
    );
  }
}
