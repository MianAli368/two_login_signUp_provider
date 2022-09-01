import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:two_login_signup_provider/login.dart';
import 'package:two_login_signup_provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ProviderState())],
    child: const MyProviderApp(),
    // )
  ));
}

class MyProviderApp extends StatelessWidget {
  const MyProviderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LOGIN(),
    );
  }
}
