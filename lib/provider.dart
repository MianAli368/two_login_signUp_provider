import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:two_login_signup_provider/login.dart';

class ProviderState extends ChangeNotifier {
  late String _uId, _uEmail, _uPassword;

  String get getUid => _uId;
  String get getUemail => _uEmail;
  String get getUpassword => _uPassword;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create User
  Future<bool> registration(
      String emailF, String passwordF, confirmPasswordF) async {
    bool success = false;
    // if (passwordF == confirmPasswordF) {
    // try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailF.toString().trim(),
            password: passwordF.toString().trim());

    if (userCredential != null) {
      _uId = userCredential.user!.uid;
      _uEmail = userCredential.user!.email!;

      return success = true;
    }
    // }
    // on FirebaseAuthException catch (e) {
    //   if (e.code == "weak-password") {
    //     print('Entered Password is too weak');
    //   } else if (e.code == "email-already-in-use") {
    //     print("Account already exists");
    //   }
    // }
    // }
    // else {
    //   print("Password and Confirm Password does not matched");
    // }

    return success;
  }

  // User Login
  Future<bool> signIn(String emailF, String passwordF) async {
    bool success = false;
    // try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailF.toString().trim(), password: passwordF.toString().trim());
    if (userCredential != null) {
      return success = true;
    }
    return success;
  }
}
