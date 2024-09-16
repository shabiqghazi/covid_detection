import 'package:covid_detection/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserServices _userServices = UserServices();

  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        await _userServices.createUser(
          userCredential.user!.uid,
          userCredential.user!.email,
          '',
        );
      }

      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future createUserWithEmailAndPassword(
      BuildContext context, emailAddress, password, name) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await _userServices.createUser(
        userCredential.user!.uid,
        userCredential.user!.email,
        name,
      );

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbarMessage(context, 'Password terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        showSnackbarMessage(
            context, 'Email telah terdaftar. Gunakan email lain!');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signInWithEmailAndPassword(
      BuildContext context, emailAddress, password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        showSnackbarMessage(context, 'Email atau password salah.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
