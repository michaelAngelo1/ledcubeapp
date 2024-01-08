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
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: SizedBox(
          height: 300,
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Coobie",
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
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  )
                ),
                const SizedBox(height: 50.0),
                Text(
                  "version 2.0",
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 241, 245, 255),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  )
                ),
              ]
            ),
          ),
        ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: const Color(0xff0D47A1),
        nextScreen: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              return const Text("Something went wrong.");
            }
            else if(snapshot.hasData){
              return const MyHomePage();
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
