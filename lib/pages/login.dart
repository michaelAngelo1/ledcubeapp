import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledcubeapp/constants.dart';
import 'package:ledcubeapp/firebase/db_instance.dart';
import 'package:ledcubeapp/pages/home.dart';
import 'package:ledcubeapp/pages/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Ref user child
    final userRef = rtdb.ref();

    // snackbar failed
    const accountNotFound = SnackBar(
      content: Text("Account not found. Please sign up."),
    );

    // empty field
    const emptyField = SnackBar(
      content: Text("Please fill out the fields."),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Coobie",
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
                    "Log in to discover",
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
              // const SizedBox(height: 15.0),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    )
                  )
                ),
                onPressed: () async {
                  var bytes = utf8.encode(_emailController.text);
                  var digest = sha1.convert(bytes);
                  var id = digest.toString();
                  final emailSnapshot = await userRef.child('users/$id/email').get();
                  final passwordSnapshot = await userRef.child('users/$id/password').get();

                  var passwordBytes = utf8.encode(_passwordController.text);
                  var passwordDigest = sha1.convert(bytes);

                  if(_emailController.text.isEmpty && _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(emptyField);
                  }
                  else if(emailSnapshot.value.toString() == _emailController.text && passwordSnapshot.value.toString() == passwordDigest.toString()) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(),
                      )
                    );
                  }
                  else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(accountNotFound);
                  }
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
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Text(
                "Don't have an account?",
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
                      builder: (context) => const SignUpPage(),
                    )
                  );
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
            ]
          )
        )
      )
    );
  }
}