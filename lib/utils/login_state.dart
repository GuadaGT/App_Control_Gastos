import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '137916224459-u482i1h4132movnri1f14d9mans86dvn.apps.googleusercontent.com'
        : null,
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences? _prefs;

  User? _user;
  User? get user => _user;

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginState() {
    _initLoginState();
  }

  Future<void> _initLoginState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs!.containsKey("isLoggedIn") && _prefs!.getBool("isLoggedIn")!) {
      _user = _auth.currentUser;
      _loggedIn = _user != null;
      notifyListeners();
    }
  }

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
        await _prefs?.setBool("isLoggedIn", true);
        notifyListeners();
        print("Signed in " + user.displayName!);
        return user;
      }
    } catch (error) {
      print("Error in sign in: $error");
      rethrow;
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _user = null;
      _loggedIn = false;
      await _prefs?.setBool("isLoggedIn", false);
      notifyListeners();
    } catch (error) {
      print("Error in sign out: $error");
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
