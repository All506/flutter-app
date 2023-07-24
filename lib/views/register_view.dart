import 'dart:math';

import 'package:dartstarter/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _pass;

  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join us now!'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          TextField(
            controller: _pass,
            decoration: const InputDecoration(hintText: 'Password'),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final pass = _pass.text;
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: pass);
              } on FirebaseAuthException catch (e) {
                devtools.log(e.code);
                if (e.code == 'weak-password') {
                  await showErrorDialog(
                      context, 'Password is weak, please try a new one');
                } else if (e.code == "email-already-in-use") {
                  await showErrorDialog(context, 'Email is already in use');
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(context, 'This email is invalid');
                } else {
                  await showErrorDialog(context, 'Error: ${e.code}');
                }
              }
            },
            child: const Text('SignUp'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Go Back"))
        ],
      ),
    );
  }
}
