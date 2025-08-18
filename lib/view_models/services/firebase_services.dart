import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  // ✅ Register user
  void registerUser(UserModel user, VoidCallback onSuccess) async {
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
    } catch (e) {
      Utils.toastMessage('Unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Sign in user
  void signInUser(UserModel user, VoidCallback onSuccess) async {
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
  void signOutUser() async {
    await auth.signOut();
    Get.snackbar('Logout', 'You have been logged out');
  }
}

// ✅ Save user to Firestore
Future<void> saveUser(User user, {String? name}) async {
  final ref = FirebaseFirestore.instance.collection('user').doc(user.uid);

  final snapshot = await ref.get();
  if (!snapshot.exists) {
    final fullName = name
        ?? user.displayName?.trim()
        ?? user.email?.split('@').first
        ?? 'user_${user.uid.substring(0, 5)}';

    await ref.set({
      'uid': user.uid,
      'name': fullName,
      'email': user.email ?? 'no email',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
