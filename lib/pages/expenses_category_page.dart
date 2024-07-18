import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gastos/utils/category_icons_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gastos/repository/expenses_repository.dart';

class ExpensesByCategoryPage extends StatelessWidget {
  ExpensesByCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final expensesRepository = Provider.of<ExpensesRepository>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          "Expenses by category",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: expensesRepository.queryAllExpensesGroupedByCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No expenses found'));
          }

          Map<String, List<DocumentSnapshot>> expensesByCategory = {};

          for (var doc in snapshot.data!.docs) {
            String category = doc['category'];
            if (!expensesByCategory.containsKey(category)) {
              expensesByCategory[category] = [];
            }
            expensesByCategory[category]!.add(doc);
          }

          return ListView(
            children: expensesByCategory.entries.map((entry) {
              return Column(
                children: [
                  ExpansionTile(
                    leading: Icon(categoryIcons[entry.key] ?? Icons.category),
                    title: Text(
                      entry.key,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    children: entry.value.map((doc) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text('${doc['value']} €',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14)),
                            subtitle: Text(
                                '${doc['day']}/${doc['month']}/${doc['year']}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 63, 185, 169),
                                )),
                          ),
                          const Divider(
                              color: Color.fromARGB(255, 186, 105, 240)),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
