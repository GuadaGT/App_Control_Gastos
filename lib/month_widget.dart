import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gastos/graph_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MonthWidget extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  MonthWidget({required this.documents});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          _expenses(),
          _graph(),
          Container(
            color: Colors.grey.withOpacity(0.15),
            height: 16.0,
          ),
          _list(),
        ],
      ),
    );
  }

  Widget _expenses() {
    // Ejemplo de procesamiento de documentos
    double totalExpenses = 0;
    documents.forEach((doc) {
      totalExpenses +=
          doc['value']; // Ajusta esto según tu estructura de documentos
    });

    return Column(
      children: <Widget>[
        Text(
          "\$${totalExpenses.toStringAsFixed(2)}", // Formatea el total como desees
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        Text(
          "Total expenses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color.fromARGB(255, 228, 86, 173),
          ),
        ),
      ],
    );
  }

  Widget _graph() {
    return Container(height: 250.0, child: GraphWidget());
  }

  Widget _item(IconData icon, String name, int percent, double value) {
    return ListTile(
      leading: Icon(icon, size: 32.0),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      subtitle: Text("$percent% of expenses"),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.pink.withOpacity(0.25),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          "\$$value",
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: documents.length,
        itemBuilder: (BuildContext context, int index) {
          // Asume que cada documento tiene 'category', 'day', 'month' y 'value'
          return _item(
            FontAwesomeIcons.shoppingCart,
            documents[index]['category'],
            14, // Calcula el porcentaje de gastos
            documents[index]['value']
                .toDouble(), // Convierte a double si es necesario
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.pink.withOpacity(0.15),
            height: 8.0,
          );
        },
      ),
    );
  }
}
