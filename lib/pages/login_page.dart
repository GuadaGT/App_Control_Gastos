import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gastos/login_state.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Login"),
          onPressed: () {
            Provider.of<LoginState>(context, listen: false).login();
          },
        ),
      ),
    );
  }
}
