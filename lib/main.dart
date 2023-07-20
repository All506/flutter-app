// ignore_for_file: avoid_print
import 'package:dartstarter/views/login_view.dart';
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
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
        future: //Initialize firebase to use it later on!
            Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              print(FirebaseAuth.instance.currentUser);
              //Verification of email has to be true
              final user = FirebaseAuth.instance.currentUser;
              final emailVerified = user?.emailVerified ?? false;
              if (emailVerified) {
                print('Email has been verified');
              } else {
                print('Email has not been verified');
              }
              return Text('Done');
            default:
              return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
