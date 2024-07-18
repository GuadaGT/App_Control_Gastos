import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

ListTile DayExpensesListTile(QueryDocumentSnapshot<Object?> document) {
  return ListTile(
    leading: Stack(
      children: <Widget>[
        const Icon(Icons.calendar_today, size: 40),
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
        color: const Color.fromARGB(255, 71, 187, 172).withOpacity(0.2),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${document["value"]} €",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
    ),
  );
}
