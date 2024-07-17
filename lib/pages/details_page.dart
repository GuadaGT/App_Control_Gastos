import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gastos/utils/login_state.dart';
import 'package:provider/provider.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams({required this.categoryName, required this.month});
}

class DetailsPage extends StatefulWidget {
  final DetailsParams params;

  const DetailsPage({required this.params});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.params.categoryName),
      ),
      body: Consumer<LoginState>(
        builder: (BuildContext context, LoginState loginState, Widget? child) {
          var user = loginState.user;
          if (user == null) {
            return Center(child: Text('User not logged in'));
          }
          var query = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('expenses')
              .where('month', isEqualTo: widget.params.month)
              .where('category', isEqualTo: widget.params.categoryName)
              .orderBy('day', descending: true)
              .snapshots();
          return StreamBuilder<QuerySnapshot>(
            stream: query,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No data available'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var document = snapshot.data!.docs[index];
                  return Dismissible(
                    key: Key(document.id),
                    onDismissed: (direction) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('expenses')
                          .doc(document.id)
                          .delete()
                          .then((value) => print("Expense deleted"))
                          .catchError((error) =>
                              print("Failed to delete expense: $error"));
                    },
                    child: ListTile(
                      leading: Stack(
                        children: <Widget>[
                          Icon(Icons.calendar_today, size: 40),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 8,
                            child: Text(
                              document["day"].toString(),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      title: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 71, 187, 172)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${document["value"]} \€",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
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
