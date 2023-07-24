import 'package:dartstarter/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text("LogIn"),
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
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: pass,
                );
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(notesRoute, (route) => false);
              } on FirebaseAuthException catch (e) {
                print(e.code);
                //Exception handling
                switch (e.code) {
                  case 'user-not-found':
                    await showErrorDialog(context, 'User not found');
                    break;
                  case 'wrong-password':
                    await showErrorDialog(context, 'Wrong credentials');
                    break;
                  case 'channel-error':
                    await showErrorDialog(context, 'All fields are required');
                    break;
                  case 'invalid-email':
                    await showErrorDialog(
                        context, 'Please write a valid email');
                    break;
                  default:
                    await showErrorDialog(context, 'Error ${e.code}');
                    break;
                }
              } catch (e) {
                //Exceptions related with system
                await showErrorDialog(context, 'Error ${e.toString()}');
              }
            },
            child: const Text('LogIn'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Not registered yet? Register here!"))
        ],
      ),
    );
  }
}
