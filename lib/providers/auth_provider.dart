import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  FirebaseAuth? get auth => _auth;
  FirebaseFirestore? get firestore => _firestore;

  /// Google Sign In
  Future<bool> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    final signInAccount = await googleSignIn.signIn();

    if (signInAccount == null) return false;

    final googleAuth = await signInAccount.authentication;
    final oAuthCredential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    try {
      final result = await _auth!.signInWithCredential(oAuthCredential);
      final user = result.user;

      await _firestore!.collection('users').doc(user?.uid).set({
        'username': user?.displayName,
        'email': user?.email,
        'userId': user?.uid,
        'imgUrl': user?.photoURL,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Logout
  Future<void> signOut() async {
    await Future.wait([
      // _auth.signOut(),
      GoogleSignIn().signOut(),
    ]);
  }
}
