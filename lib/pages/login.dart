import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
    const snackbar = SnackBar(
      content: Text("Account not found. Please sign up."),
    );

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Login Page"),
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
                  final emailSnapshot = await userRef.child('users/email').get();
                  final passwordSnapshot = await userRef.child('users/password').get();
                  if(emailSnapshot.value.toString() == _emailController.text && passwordSnapshot.value.toString() == _passwordController.text) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(title: "LED Cube App"),
                      )
                    );
                  }
                  else {
                    print("user not found");
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 5.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Text("Don't have an account?"),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    )
                  );
                },
                child: const Text('Sign up'),
              ),
            ]
          )
        )
      )
    );
  }
}