// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two_login_signup_provider/dashboard.dart';
import 'package:two_login_signup_provider/provider.dart';
import 'package:two_login_signup_provider/signup.dart';

class LOGIN extends StatefulWidget {
  const LOGIN({Key? key}) : super(key: key);

  @override
  State<LOGIN> createState() => _LOGINState();
}

class _LOGINState extends State<LOGIN> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProviderState providerState =
        Provider.of<ProviderState>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(50, 25, 0, 0),
                  child: Text(
                    'Syslify',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.blue),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.fromLTRB(111, 0, 0, 0),
                  child: Text(
                    '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),
                // Email Container
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                        )),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Email";
                      } else if (!value.contains('@')) {
                        return "Please Enter valid Email";
                      }
                      return null;
                    },
                  ),
                ),

                // Password Container
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                        )),
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Password";
                      }

                      return null;
                    },
                  ),
                ),

                // Button Container

                Container(
                    margin: const EdgeInsets.only(left: 110),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                userLogin(emailController.text,
                                    passwordController.text, context);
                              }
                            },
                            child: const Text('Login')),
                      ],
                    )),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Dont have an Account ?'),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SIGNUP()));
                        },
                        child: const Text('Sign UP'))
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

void userLogin(String email, String password, context) async {
  ProviderState providerState =
      Provider.of<ProviderState>(context, listen: false);

  try {
    if (await providerState.signIn(email, password)) {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const Dashboard())));
    }
  } on FirebaseAuthException catch (e) {
    // print(e);
    if (e.code == "user-not-found") {
      print("No User Found for that Email.");
      //  print("Wrong Password Provided by User");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "No User Found for a this Email",
            style: TextStyle(fontSize: 18.0, color: Colors.redAccent),
          ),
        ),
      );
    } else if (e.code == "wrong-password") {
      print('Wrong Password Provided');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "Wrong Password Provided",
            style: TextStyle(fontSize: 18.0, color: Colors.redAccent),
          ),
        ),
      );
    }
  }
}
