import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../widgets/my_textfield.dart';
import '../widgets/my_button.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  final void Function()? onTap;

  LoginScreen({super.key, required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60.0,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50.0),

            // welcome back message
            const Text('Welcome back, you have been missed'),

            const SizedBox(height: 25.0),

            // email text field
            MyTextField(
              hintText: 'Email',
              controller: _emailController,
            ),

            const SizedBox(height: 10.0),

            // password text field
            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
            ),

            const SizedBox(height: 25.0),

            // login button
            MyButton(
              text: 'Login',
              onTap: () => login(context),
            ),

            const SizedBox(height: 25.0),

            // register now text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member ? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Register now',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
