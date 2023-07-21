// ignore_for_file: avoid_print
import 'package:dartstarter/views/login_view.dart';
import 'package:dartstarter/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() {
  //Initialize connections for asyncs comms before program is ran
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),

      //Defines named routes
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: //Initialize firebase to use it later on!
          Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            //Verification of email has to be true
            final user = FirebaseAuth.instance.currentUser;
            var message = "";
            if (user != null) {
              if (user.emailVerified) message = "User has been logged.";
            } else {
              message = "Logging did not work correctly";
            }
            return Text(message);
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
