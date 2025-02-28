import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_or_register.dart';
import '../../screens/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return HomeScreen();
          }

          // user is NOT logged in
          return const LoginOrRegister();
        },
      ),
    );
  }
}
