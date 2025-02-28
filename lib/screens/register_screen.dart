import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../widgets/my_textfield.dart';
import '../widgets/my_button.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  final void Function()? onTap;

  RegisterScreen({super.key, required this.onTap});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void register(BuildContext context) {
    final authService = AuthService();

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        authService.signUpWithEmailPassword(
            _emailController.text, _passwordController.text);
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
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            'Passwords don\'t match',
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
            const Text('Let\'s create a new account for you'),

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

            const SizedBox(height: 10.0),

            // confirm password text field
            MyTextField(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmPasswordController,
            ),

            const SizedBox(height: 25.0),

            // login button
            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),

            const SizedBox(height: 25.0),

            // register now text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account ? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
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
