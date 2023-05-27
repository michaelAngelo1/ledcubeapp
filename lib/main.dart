import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ledcubeapp/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            print("ERROR FLUTTER: ${snapshot.error.toString()}");
            return const Text("Something went wrong.");
          }
          else if(snapshot.hasData){
            return const MyHomePage(title: "LED Cube App");
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final db = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    // final testRef = db.child("test");
    final testRefChild = db.child("ledState");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     testRef.set("Hello World ${Random().nextInt(100)}");
              //   },
              //   child: Text("Send to Firebase")
              // ),
              const SizedBox(height: 5.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    testRefChild
                      .set({
                        'on': true,
                        'off': false,
                      });
                  } catch (e) {
                    print("ERROR: $e");
                  }
                },
                child: Text("Set LED State")
              ),
            ],
          )
        )
      )
    );
  }

  
}
