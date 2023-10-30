import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
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

      final uid = user!.uid;
      final userExists = await doesUserExist(uid);

      if (!userExists) {
        await usersCollection.doc(uid).set({
          'displayName' : user.displayName,
          'email' : user.email
        });
      }

      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> doesUserExist(String uid) async {
    final DocumentSnapshot userDoc = await usersCollection.doc(uid).get();
    return userDoc.exists;
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