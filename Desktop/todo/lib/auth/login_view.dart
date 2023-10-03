import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/auth/register_view.dart';
import 'package:todo/auth/verify_email.dart';
import 'package:todo/dialogs/error_dialog.dart';
import 'package:todo/routes/routes.dart';
import 'package:todo/screens/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: "Enter email"),
            controller: _email,
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Enter password"),
            controller: _password,
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _email.text, password: _password.text);
                final user = FirebaseAuth.instance.currentUser;
                final isEmailVerified = user!.emailVerified ?? false;
                print(user);
                if (user != null) {
                  if (isEmailVerified) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const HomePage()));
                  } else {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerifyEmailView()));
                  }
                }
              } catch (e) {
                // ignore: unused_local_variable, use_build_context_synchronously
                errorDialogShow(context);
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterView()));
              },
              child: const Text("Not Registered Yet? Register here"))
        ],
      ),
    );
  }
}
