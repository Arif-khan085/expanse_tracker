import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class AmountService  extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Get Available Balance Stream
  Stream<DocumentSnapshot> getAvailableBalance(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('summary')
        .doc('availableBalanceDoc')
        .snapshots();
  }

  // ✅ Get Salary Stream
  Stream<DocumentSnapshot> getSalary(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('salary')
        .doc('salaryDoc')
        .snapshots();
  }

  // ✅ Get Expense Stream
  Stream<DocumentSnapshot> getExpenseSummary(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('summary')
        .doc('expenseDoc')
        .snapshots();
  }

  // ✅ Get Expenses List Stream
  Stream<QuerySnapshot> getExpenses(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ✅ Update Summary (expense + availableBalance)
  Future<void> updateSummary(String uid, List<QueryDocumentSnapshot> expenses) async {
    double totalExpense = expenses.fold(
      0,
          (sum, doc) => sum + (doc['amount'] as num).toDouble(),
    );

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('summary')
        .doc('expenseDoc')
        .set({
      'amount': totalExpense,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final balanceSnap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('balance')
        .doc('balanceDoc')
        .get();

    double totalBalance =
    balanceSnap.exists ? (balanceSnap['amount'] as num).toDouble() : 0;

    double availableBalance = totalBalance - totalExpense;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('summary')
        .doc('availableBalanceDoc')
        .set({
      'amount': availableBalance,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ✅ Update Balance
  Future<void> updateBalance(String uid, double balance) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('balance')
        .doc('balanceDoc')
        .set({
      'amount': balance,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ✅ Update Salary
  Future<void> updateSalary(String uid, double salary) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('salary')
        .doc('salaryDoc')
        .set({
      'amount': salary,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

