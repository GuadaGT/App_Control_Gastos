import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesRepository {
  final String userId;
  ExpensesRepository(this.userId);

  CollectionReference get userRef => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('expenses');

  Stream<QuerySnapshot> queryByCategory(int month, String categoryName) {
    return userRef
        .where('month', isEqualTo: month)
        .where('category', isEqualTo: categoryName)
        .orderBy('day', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> queryByMonth(int month) {
    return userRef.where('month', isEqualTo: month).snapshots();
  }

  Stream<QuerySnapshot> queryAllExpensesGroupedByCategory() {
    return userRef.snapshots();
  }

  Future<void> delete(String documentId) {
    return userRef.doc(documentId).delete();
  }

  Future<void> add(String categoryName, int value, DateTime date) async {
    await userRef.add({
      'category': categoryName,
      'value': value,
      'month': date.month,
      'day': date.day,
      'year': date.year,
    });
  }
}
