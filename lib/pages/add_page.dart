import 'package:flutter/material.dart';
import 'package:flutter_gastos/utils/category_selection_widget.dart';
import 'package:flutter_gastos/utils/login_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String? category;
  final TextEditingController _valueController = TextEditingController();

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
        valueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Text(
        "${_valueController.text} \€",
        style: TextStyle(
          fontSize: 50.0,
          color: Color.fromARGB(255, 48, 151, 137),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _addDigit(String digit) {
    setState(() {
      if (digit == "backspace") {
        if (_valueController.text.isNotEmpty) {
          _valueController.text = _valueController.text
              .substring(0, _valueController.text.length - 1);
        }
      } else {
        _valueController.text += digit;
      }
    });
  }

  Widget _num(String text, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _addDigit(text);
      },
      child: Container(
        height: height,
        child: Center(
          child: text == "backspace"
              ? Icon(Icons.backspace, color: Colors.grey, size: 40)
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.grey,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _numPad() {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var height = constraints.biggest.height / 4;
          return Table(
            border: TableBorder.all(color: Colors.grey, width: 1.0),
            children: [
              TableRow(children: [
                _num("1", height),
                _num("2", height),
                _num("3", height),
              ]),
              TableRow(children: [
                _num("4", height),
                _num("5", height),
                _num("6", height),
              ]),
              TableRow(children: [
                _num("7", height),
                _num("8", height),
                _num("9", height),
              ]),
              TableRow(children: [
                _num(".", height),
                _num("0", height),
                _num("backspace", height),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _submit() {
    return Hero(
      tag: "add_button",
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 71, 187, 172),
        ),
        child: MaterialButton(
          child: Text(
            "Add expenses",
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          onPressed: () async {
            final user = Provider.of<LoginState>(context, listen: false).user;
            double? value = double.tryParse(_valueController.text);
            if (user != null &&
                value != null &&
                value > 0 &&
                category != null &&
                category!.isNotEmpty) {
              final userRef =
                  FirebaseFirestore.instance.collection('users').doc(user.uid);
              await userRef.collection('expenses').add({
                'category': category,
                'value': value,
                'month': DateTime.now().month,
                'day': DateTime.now().day,
                'year': DateTime.now().year,
              });
              Navigator.of(context).pop();
            } else {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content:
                            Text("You need to select a category and a value."),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                color: Color.fromARGB(255, 71, 187, 172),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            }
          },
        ),
      ),
    );
  }
}
