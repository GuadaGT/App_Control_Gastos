import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gastos/pages/ui/day_expenses_list_tile.dart';
import 'package:flutter_gastos/repository/expenses_repository.dart';
import 'package:provider/provider.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams({required this.categoryName, required this.month});
}

class DetailsPageContainer extends StatefulWidget {
  final DetailsParams params;

  const DetailsPageContainer({super.key, required this.params});

  @override
  State<DetailsPageContainer> createState() => _DetailsPageContainerState();
}

class _DetailsPageContainerState extends State<DetailsPageContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.params.categoryName),
      ),
      body: Consumer<ExpensesRepository>(
        builder: (BuildContext context, ExpensesRepository db, Widget? child) {
          var query = db.queryByCategory(
              widget.params.month, widget.params.categoryName);
          return StreamBuilder<QuerySnapshot>(
            stream: query,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No data available'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var document = snapshot.data!.docs[index];
                  return Dismissible(
                    key: Key(document.id),
                    onDismissed: (direction) {
                      db.delete(document.id);
                    },
                    child: DayExpensesListTile(document),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
