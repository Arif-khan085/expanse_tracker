import 'package:cloud_firestore/cloud_firestore.dart';

class Expanse {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create wallet if not exists
  Future<void> createWallet(String uid, double salary) async {
    final walletRef = _db.collection('users').doc(uid).collection('wallet').doc('data');
    final snap = await walletRef.get();

    if (!snap.exists) {
      await walletRef.set({
        'salary': salary,
        'balance': salary,
        'totalExpense': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Add Expense
  Future<void> addExpense(String uid, Map<String, dynamic> expense) async {
    final walletRef = _db.collection('users').doc(uid).collection('wallet').doc('data');
    final expenseRef = _db.collection('users').doc(uid).collection('expenses').doc();

    await _db.runTransaction((txn) async {
      final walletSnap = await txn.get(walletRef);
      if (!walletSnap.exists) throw Exception("Wallet not found");

      double balance = walletSnap['balance'];
      double totalExpense = walletSnap['totalExpense'];
      double expenseAmount = expense['amount'];

      if (balance < expenseAmount) throw Exception("Not enough balance");

      // Update wallet
      txn.update(walletRef, {
        'balance': balance - expenseAmount,
        'totalExpense': totalExpense + expenseAmount,
      });

      // Add expense
      txn.set(expenseRef, {
        ...expense,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Update Expense
  Future<void> updateExpense(String uid, String docId, Map<String, dynamic> updatedData) async {
    final expenseRef = _db.collection('users').doc(uid).collection('expenses').doc(docId);
    await expenseRef.update(updatedData);
  }
}
