import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInService {
    static Future<void> signInWithGoogle(BuildContext context) async {
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
        } catch (e) {
            print('Error signing in with Google: $e');
            // Handle error (show a message, log the error, etc.)
        }
    }

    static Future<User?> getCurrentUser() async {
        return FirebaseAuth.instance.currentUser;
    }
}
