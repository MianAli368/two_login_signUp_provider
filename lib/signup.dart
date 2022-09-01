import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two_login_signup_provider/provider.dart';
import 'login.dart';

class SIGNUP extends StatefulWidget {
  const SIGNUP({Key? key}) : super(key: key);

  @override
  State<SIGNUP> createState() => _SIGNUPState();
}

class _SIGNUPState extends State<SIGNUP> {
  final _formKey = GlobalKey<FormState>();

  var displayName = "";
  var email = "";
  var password = "";
  var confirmPassword = "";

  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when widget is disposed.
    displayNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  clearText() {
    displayNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
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
                padding: EdgeInsets.fromLTRB(55, 25, 0, 0),
                child: Text(
                  'Syslify',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      // fontFamily: itali,
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
              // Name Container
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter Name',
                      labelStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                      )),
                  controller: displayNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Name";
                    }
                    return null;
                  },
                ),
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

              // Confirm Password Container
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                      )),
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Confirm Password";
                    }
                    return null;
                  },
                ),
              ),

              // Button Container
              Container(
                  margin: const EdgeInsets.only(left: 100),
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              registerUser(
                                  emailController.text,
                                  passwordController.text,
                                  confirmPasswordController.text,
                                  context);
                            }
                          },
                          child: const Text('Sign Up')),
                    ],
                  )),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an Account ?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LOGIN()));
                      },
                      child: const Text('Login'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void registerUser(
    String email, String password, String confirmPassword, context) async {
  ProviderState providerState =
      Provider.of<ProviderState>(context, listen: false);

  if (password == confirmPassword) {
    try {
      if (await providerState.registration(email, password, confirmPassword)) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LOGIN()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        print('Entered Password is too weak');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Entered Password is too weak.',
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
        ));
      } else if (e.code == "email-already-in-use") {
        print("Account already exists");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            'Account already exists.',
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
        ));
      }
    }
  } else {
    print("Password and Confirm doesn't matched");
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        "Password and Confirm doesn't matched.",
        style: TextStyle(fontSize: 18, color: Colors.redAccent),
      ),
    ));
  }

  // try {
  //   if (await providerState.registration(email, password, confirmPassword)) {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: ((context) => const LOGIN())));
  //   }
  // }

  // on FirebaseAuthException catch (e) {
  //   if (e.code == "weak-password") {
  //     print('Entered Password is too weak');
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       backgroundColor: Colors.black,
  //       content: Text(
  //         'Entered Password is too weak.',
  //         style: TextStyle(fontSize: 18, color: Colors.redAccent),
  //       ),
  //     ));
  //   } else if (e.code == "email-already-in-use") {
  //     print("Account already exists");
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       backgroundColor: Colors.black,
  //       content: Text(
  //         'Account already exists.',
  //         style: TextStyle(fontSize: 18, color: Colors.redAccent),
  //       ),
  //     ));
  //   }
  //   }

  // else {
  //     print("Password and Confirm doesn't matched");
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       backgroundColor: Colors.black,
  //       content: Text(
  //         "Password and Confirm doesn't matched.",
  //         style: TextStyle(fontSize: 18, color: Colors.redAccent),
  //       ),
  //     ));
  //   }
  // }

  // on FirebaseAuthException catch (e) {
  //   if (e.code == "weak-password") {
  //     print('Entered Password is too weak');
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       backgroundColor: Colors.black,
  //       content: Text(
  //         'Entered Password is too weak.',
  //         style: TextStyle(fontSize: 18, color: Colors.redAccent),
  //       ),
  //     ));
  //   } else if (e.code == "email-already-in-use") {
  //     print("Account already exists");
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       backgroundColor: Colors.black,
  //       content: Text(
  //         'Account already exists.',
  //         style: TextStyle(fontSize: 18, color: Colors.redAccent),
  //       ),
  //     ));
  //   }

  //   // notifylisteners
  // }

  // catch (e) {
  //   print('Error Sign Up : $e');
  // }
}
