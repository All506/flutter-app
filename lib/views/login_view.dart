import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
import 'package:logger/logger.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _pass;
  var logger = Logger();

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
        title: const Text('LogIn'),
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
                            .signInWithEmailAndPassword(
                                email: email, password: pass);
                      } on FirebaseAuthException catch (e) {
                        print(e.code);
                        if (e.code == 'user-not-found') {
                          logger.e('User not found');
                        } else if (e.code == 'wrong-password') {
                          logger.e('Wrong credentials');
                        }
                      }
                    },
                    child: const Text('LogIn'),
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
