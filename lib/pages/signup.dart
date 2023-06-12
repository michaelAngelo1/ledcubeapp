import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ledcubeapp/constants.dart';
import 'package:ledcubeapp/firebase/db_instance.dart';
import 'home.dart';
import 'login.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // Ref user child
    final userRef = rtdb.ref().child("users");

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Sign Up Page"),
        )
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  )
                )
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  )
                )
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () async {
                  var bytes = utf8.encode(_emailController.text);
                  var digest = sha1.convert(bytes);
                  await userRef.update({
                    digest.toString(): {
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    } 
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(title: "LED Cube App"),
                    )
                  );
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 5.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Text("Have an account?"),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    )
                  );
                },
                child: const Text('Log in'),
              ),
            ]
          )
        )
      )
    );
  }
}