import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyA27hMN6dvPIXmHsFJ5cozJweDOvak21j8",
        authDomain: "gastos-47fab.firebaseapp.com",
        projectId: "gastos-47fab",
        storageBucket: "gastos-47fab.appspot.com",
        messagingSenderId: "137916224459",
        appId: "1:137916224459:web:f39797e5b244e0b5165c4e",
        measurementId: "G-2RMP0WE1VM",
      ),
    );
  }
}
