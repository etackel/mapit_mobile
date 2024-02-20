import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapit/src/widgets/google_auth_button.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Get user details
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save user details in the provider
        context.read<UserProvider>().setUserDetails(
          user.displayName ?? '',
          user.email ?? '',
          // You can get the user's age through some additional logic
          // or ask the user to input it during the sign-up process.
          // For now, let's assume age is not directly available.
          0,
        );
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      // Handle error (show a message, log the error, etc.)
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
