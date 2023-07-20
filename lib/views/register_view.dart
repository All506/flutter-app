// ignore_for_file: avoid_print
import 'package:dartstarter/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

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
      body: FutureBuilder(
        future: //Initialize firebase to use it later on!
            Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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
                        final userCredential = FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: pass);
                      } on FirebaseAuthException catch (e) {
                        print(e);
                        if (e.code == 'weak-password') {
                          print("Password is weak. Try a new one");
                        } else if (e.code == "email-already-in-use") {
                          print("This email already exists");
                        } else if (e.code == 'invalid-email') {
                          print("This email is not valid. Try a new one");
                        }
                      }
                    },
                    child: const Text('SignUp'),
                  ),
                ],
              );
            default:
              return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
