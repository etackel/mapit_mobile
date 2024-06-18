import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleAuthButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.google,
      onPressed: onPressed,
      text: "Sign in with Google",
    );
  }
}