import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Expanse extends GetxController {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> deleteExpense(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .doc(docId)
          .delete();
      Get.snackbar('Success', 'Expense deleted successfully');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateExpense(String docId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .doc(docId)
          .update(data);

      Get.snackbar("Success", "Expense updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
