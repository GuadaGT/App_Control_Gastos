import 'package:flutter/material.dart';
import 'package:flutter_gastos/repository/expenses_repository.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_gastos/utils/login_state.dart';
import 'package:flutter_gastos/pages/login_page.dart';
import 'package:flutter_gastos/pages/add_page.dart';
import 'package:flutter_gastos/pages/home_page.dart';
import 'package:flutter_gastos/pages/details_page.dart';
import 'package:flutter_gastos/config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeFirebase();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginState>(create: (context) => LoginState()),
        ProxyProvider<LoginState, ExpensesRepository>(
          update: (context, loginState, previous) =>
              ExpensesRepository(loginState.user?.uid ?? ''),
        ),
      ],
      child: Consumer<LoginState>(
        builder: (context, loginState, child) {
          return MaterialApp(
            title: "Save It!",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            ],
            home: loginState.loggedIn ? const HomePage() : const LoginPage(),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/details':
                  DetailsParams params = settings.arguments as DetailsParams;
                  return MaterialPageRoute(
                    builder: (BuildContext conetxt) =>
                        DetailsPageContainer(params: params),
                  );
                case '/add':
                  return MaterialPageRoute(
                    builder: (context) => const AddPage(),
                  );
                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}
