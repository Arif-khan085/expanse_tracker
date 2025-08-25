import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;

  // ✅ Register user
  Future<void> registerUser(UserModel user, VoidCallback onSuccess) async {
    isLoading.value = true;
    try {
      // Save the credential
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      // Save user to Firestore
      await saveUser(credential.user!, name: user.name);

      Utils.toastMessage('Account Created Successfully');
      onSuccess();
    } on FirebaseAuthException catch (e) {
      Utils.toastMessage(e.message ?? 'Register Error');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Sign in user
  Future<void> signInUser(UserModel user, VoidCallback onSuccess) async {
    isLoading.value = true;
    try {
      await auth.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      onSuccess();
      Get.snackbar('Congrats', 'Logged in Successfully');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login Error');
    } catch (e) {
      Get.snackbar('Unexpected', 'Unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Sign out user
  Future<void> signOutUser() async {
    await auth.signOut();
    Get.snackbar('Logout', 'You have been logged out');
  }
}

Future<void> saveUser(User user, {String? name}) async {
  try {
    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final snapshot = await ref.get();
    if (!snapshot.exists) {
      final fullName =
          name ??
          user.displayName?.trim() ??
          user.email?.split('@').first ??
          'user_${user.uid.substring(0, 5)}';

      await ref.set({
        'uid': user.uid,
        'name': fullName,
        'email': user.email ?? 'no email',
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint("✅ User saved to Firestore");
    } else {
      debugPrint("⚠️ User already exists in Firestore");
    }
  } catch (e) {
    debugPrint("❌ Error saving user: $e");
  }
}

// ✅ Add Expense
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

Future<void> addExpense({
  required String title,
  required double amount,
  required String date,
  required String category,
  required String payment,
}) async {
  try {
    String uid = auth.currentUser!.uid;

    // 👇 Create document reference for expense
    DocumentReference expenseRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .doc(); // auto generate ID

    // 👇 Save expense with expenseId + uid
    await expenseRef.set({
      'expenseId': expenseRef.id, // Save expense document ID
      'uid': uid, // Save user UID
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
      'payment': payment,
      'createdAt': FieldValue.serverTimestamp(),
    });

    debugPrint("✅ Expense saved with ID: ${expenseRef.id}");
    Get.snackbar('Success', 'Expense Added ✅');
  } catch (e) {
    Get.snackbar("Error", "Failed to add expense ❌ $e");
    debugPrint("❌ Error adding expense: $e");
  }
}

 