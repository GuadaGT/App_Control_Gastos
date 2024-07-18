import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesRepository {
  final String userId;
  ExpensesRepository(this.userId);
  get userRef => null;

  Stream<QuerySnapshot> queryByCategory(int month, String categoryName) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .where('month', isEqualTo: month)
        .where('category', isEqualTo: categoryName)
        .orderBy('day', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> queryByMonth(int month) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .where('month', isEqualTo: month)
        .snapshots();
  }

  delete(String documentId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(documentId)
        .delete();
  }

  add(String categoryName, int value, DateTime date) async {
    FirebaseFirestore.instance.collection('users').doc(userId);
    await userRef.collection('expenses').add({
      'category': categoryName,
      'value': value,
      'month': DateTime.now().month,
      'day': DateTime.now().day,
      'year': DateTime.now().year,
    });
  }
}
