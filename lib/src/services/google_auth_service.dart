import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    Future<GoogleSignInAccount?> signInWithGoogle() async {
        try {
            final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
            return googleUser;
        } catch (error) {
            print('Error signing in with Google: $error');
            return null;
        }
    }

    Future<void> signOut() async {
        await _googleSignIn.signOut();
    }
}
