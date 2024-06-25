import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onPressed;

  GoogleAuthButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: SignInButton(
        Buttons.googleDark,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8),
        elevation: 4,
        text: '    Sign in with Google',
      ),
    );
  }
}
