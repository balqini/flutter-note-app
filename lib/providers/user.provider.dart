import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppUser extends ChangeNotifier {
  // User? user;

  update() {
    notifyListeners();
  }

  AppUser.instance() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      // if (user != null)
      //   this.user = user;
      // else
      //   this.user = null;
      // print(this.user);
      notifyListeners();
    });
  }

  User? get user => FirebaseAuth.instance.currentUser;

  factory AppUser() => AppUser.instance();

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  signIn({required String email, required String password}) async {
    print('Email: $email');
    print('Password: $password');

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('Sign in Succesful');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else
        print(e.toString());
    }
  }
}
