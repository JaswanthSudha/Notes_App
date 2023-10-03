import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/auth/login_view.dart';
import 'package:todo/auth/register_view.dart';
import 'package:todo/auth/verify_email.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/routes/routes.dart';
import 'package:todo/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                bool isEmailVerified = user?.emailVerified ?? false;
                if (user != null) {
                  if (isEmailVerified) {
                    return const HomePage();
                  }
                  return const VerifyEmailView();
                } else {
                  return const RegisterView();
                }
              default:
                return const Center(
                    child: SizedBox(
                  height: 50,
                  child: CircularProgressIndicator(),
                ));
            }
          }),
      routes: {
        loginRoute: (context) => const LoginPage(),
        homeRoute: (context) => const HomePage(),
      },
    );
  }
}
