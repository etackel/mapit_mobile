import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapit/src/views/home/home_view.dart';
import 'package:mapit/src/widgets/google_auth_button.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../services/google_auth_service.dart';

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
