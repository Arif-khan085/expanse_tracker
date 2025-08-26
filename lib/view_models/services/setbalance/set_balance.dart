import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> setBalance(double salary) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('balance')
      .doc('mainBalance') // only one doc
      .set({
    "salary": salary,
    "balance": salary,
    "createdAt": DateTime.now(),
  });
}

Future<void> updateBalance(double amount, {bool isExpense = true}) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('balance')
      .doc('mainBalance');

  final doc = await docRef.get();

  if (doc.exists) {
    double currentBalance = doc['balance'] ?? 0;
    double newBalance = isExpense
        ? currentBalance - amount
        : currentBalance + amount;

    await docRef.update({
      "balance": newBalance,
      "updatedAt": DateTime.now(),
    });
  }
}

Stream<DocumentSnapshot> getBalanceStream() {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('balance')
      .doc('mainBalance')
      .snapshots();
}
