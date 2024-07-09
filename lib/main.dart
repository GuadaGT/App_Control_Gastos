import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gastos/pages/add_page.dart';
import 'package:flutter_gastos/pages/home.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeFirebase();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gastos",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      routes: {
        '/': (BuildContext context) => HomePage(),
        '/add': (BuildContext context) => AddPage(),
      },
    );
  }
}
