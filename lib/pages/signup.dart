import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
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

    const signUpSuccess = SnackBar(
      content: Text("Sign up success. Please login."),
    );

    const emptyField = SnackBar(
      content: Text("Please fill out the fields."),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Gigalux",
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            )
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Sign up to discover",
                    style: GoogleFonts.montserrat(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    label: Text(
                      "Enter email",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      )
                    ),
                  )
                )
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    label: Text(
                      "Enter password",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      )
                    ),
                  )
                )
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    )
                  )
                ),
                onPressed: () async {
                  if(_emailController.text.isEmpty && _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(emptyField);
                  }
                  else {
                    var bytes = utf8.encode(_emailController.text);
                    var digest = sha1.convert(bytes);
                    await userRef.update({
                      digest.toString(): {
                        'email': _emailController.text,
                        'password': _passwordController.text,
                      } 
                    });
                    ScaffoldMessenger.of(context).showSnackBar(signUpSuccess);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage()
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Text(
                    'Sign up',
                    style: GoogleFonts.montserrat(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    )
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Text(
                "Have an account?",
                style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                )
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    )
                  )
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    )
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Text(
                    'Login',
                    style: GoogleFonts.montserrat(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    )
                  ),
                ),
              ),
            ]
          )
        )
      )
    );
  }
}