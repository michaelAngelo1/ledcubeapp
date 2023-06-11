import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ledcubeapp/pages/home.dart';
import 'package:ledcubeapp/pages/login.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            print("LOGGED IN");
            return MyHomePage(title: "LED Cube App");
          }
          else {
            return LoginPage();
          }
        }
      )
    );
  }
}