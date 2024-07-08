import 'package:flutter/material.dart';
import 'package:flutter_gastos/category_selection_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Category",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelector(),
        _currentValue(),
        _numPad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector() {
    return Container(
      height: 80.0,
      child: CategorySelectionWidget(
        categories: {
          "Shopping": Icons.shopping_bag,
          "Gaming": FontAwesomeIcons.gamepad,
          "Bills": FontAwesomeIcons.wallet,
          "Food": FontAwesomeIcons.bowlFood
        },
      ),
    );
  }

  Widget _currentValue() => Placeholder(
        fallbackHeight: 120,
      );

  Widget _numPad() => Expanded(child: Placeholder());

  Widget _submit() => Placeholder(
        fallbackHeight: 50,
      );
}
