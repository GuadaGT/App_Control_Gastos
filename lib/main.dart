import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gastos/utils/add_page_transition.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_gastos/utils/login_state.dart';
import 'package:flutter_gastos/pages/login_page.dart';
import 'package:flutter_gastos/pages/add_page.dart';
import 'package:flutter_gastos/pages/home_page.dart';
import 'config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeFirebase();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (context) => LoginState(),
      child: Consumer<LoginState>(
        builder: (context, loginState, child) {
          return MaterialApp(
            title: "Gastos",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            ],
            home: loginState.loggedIn ? HomePage() : LoginPage(),
            onGenerateRoute: (settings) {
              if (settings.name == '/add') {
                return AddPageTransition(
                  AddPage(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
