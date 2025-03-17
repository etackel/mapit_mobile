import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapit/src/presentation/pages/home/home_view.dart';
import 'package:provider/provider.dart';

import '../../../shared/services/google_auth_service.dart';
import '../../providers/user_provider.dart';

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleAuthButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/google_logo.png', // Make sure you have this asset
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            'Sign in with Google',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    final User? user = await SignInService.getCurrentUser();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {

    await SignInService.signInWithGoogle(context);

    final User? user = await SignInService.getCurrentUser();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
      context.read<UserProvider>().setUserDetails(
        user.displayName ?? '',
        user.email ?? '',
        user.photoURL ?? '',
        0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 36,
              child: Column(
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    userProvider.name != null
                        ? 'Welcome, ${userProvider.name}!'
                        : 'Sign in to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF101828),
                      fontSize: 16,
                      fontFamily: 'Gilroy-SemiBold',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  GoogleAuthButton(
                    onPressed: () => _signInWithGoogle(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
