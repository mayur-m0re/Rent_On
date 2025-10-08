import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _user;
  AppUser? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      notifyListeners();
      return;
    }
    final doc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    if (doc.exists) {
      _user = AppUser.fromMap(doc.data()!);
    } else {
      _user = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? '',
        role: 'renter',
      );
      await _firestore.collection('users').doc(_user!.uid).set(_user!.toMap());
    }
    notifyListeners();
  }

  Future<String?> signUpWithEmail(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      final res = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = res.user!;
      final appUser = AppUser(
        uid: user.uid,
        email: email,
        name: name,
        role: role,
      );
      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInWithGoogle(String role) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return 'Cancelled';
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final res = await _auth.signInWithCredential(credential);
      final user = res.user!;
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        final appUser = AppUser(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          role: role,
          photoUrl: user.photoURL ?? '',
        );
        await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
