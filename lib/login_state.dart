import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '137916224459-u482i1h4132movnri1f14d9mans86dvn.apps.googleusercontent.com'
        : null,
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  User? get user => _user;

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<User?> login() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        _user = user;
        _loggedIn = true;
        notifyListeners();
        print("Signed in " + user.displayName!);
        return user;
      }
    } catch (error) {
      print("Error in sign in: $error");
      return null;
    }
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();

    _user = null;
    _loggedIn = false;
    notifyListeners();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
