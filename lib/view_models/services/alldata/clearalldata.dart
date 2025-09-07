import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ExpenseService {
  Future<void> clearAllData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final firestore = FirebaseFirestore.instance;

      final expenses = await firestore
          .collection("users")
          .doc(uid)
          .collection("expenses")
          .get();

      for (var doc in expenses.docs) {
        await doc.reference.delete();
      }

      Get.snackbar("Success", "All expenses cleared successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
