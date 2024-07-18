import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gastos/utils/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TapGestureRecognizer _recognizer1;
  late final TapGestureRecognizer _recognizer2;

  @override
  void initState() {
    super.initState();
    _recognizer1 = TapGestureRecognizer()..onTap = _onTermsOfServiceTapped;
    _recognizer2 = TapGestureRecognizer()..onTap = _onPrivacyPolicyTapped;
  }

  @override
  void dispose() {
    _recognizer1.dispose();
    _recognizer2.dispose();
    super.dispose();
  }

  void _onTermsOfServiceTapped() {}

  void _onPrivacyPolicyTapped() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Container(),
            ),
            Text(
              "Save It",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset('assets/undraw_Investment_data_re_sh9x.png'),
            ),
            Text(
              "Your personal finance app",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Flexible(
              child: Container(),
            ),
            Consumer<LoginState>(
              builder: (BuildContext context, LoginState value, Widget? child) {
                if (value.isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return child!;
                }
              },
              child: ElevatedButton(
                child: const Text(
                  "Sign in with Google",
                  style: TextStyle(color: Color.fromARGB(255, 71, 187, 172)),
                ),
                onPressed: () {
                  Provider.of<LoginState>(context, listen: false).login();
                },
              ),
            ),
            Flexible(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall,
                  text: "To use this app you need to agree to our ",
                  children: [
                    TextSpan(
                      text: "Terms of Service",
                      recognizer: _recognizer1,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      recognizer: _recognizer2,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
