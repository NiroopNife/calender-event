import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {}

  Future<User?> registerWithEmailAndPassword(String email, String password) async {}

  Future<void> logout() async {
    _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}