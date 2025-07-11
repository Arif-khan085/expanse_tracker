import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  void registerUser(UserModel user, VoidCallback onSuccess) async {
    isLoading.value = true;
    try {
      await auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      onSuccess();
      Utils.toastMessage('Account Create SuccessFully');
    } on FirebaseAuthException catch (e) {
      Utils.toastMessage(e.message ?? 'Register Error');
    } catch (e) {
      Utils.toastMessage('Unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  void signInUser(UserModel user, VoidCallback onSuccess) async {
    isLoading.value = true;
    try {
      await auth.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      onSuccess();
      Utils.toastMessage('Logged in Successfully');
    } on FirebaseAuthException catch (e) {
      Utils.toastMessage(e.message ?? 'Login Error');
    } catch (e) {
      Utils.toastMessage('Unexpected error accured');
    } finally {
      isLoading.value = false;
    }
  }

  void signOutUser() async {
    await auth.signOut();
    Utils.toastMessage("Signed out");
  }
}
