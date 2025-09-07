import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SettingsViewModel extends GetxController {
  // Theme (0 = system, 1 = light, 2 = dark)
  var themeMode = 0.obs;
  var currentLocale = const Locale('en', 'US').obs;


  void changeLanguage(String lang) {
    selectedLanguage.value = lang;

    if (lang == "English") {
      Get.updateLocale(const Locale('en', 'US'));
    } else if (lang == "Urdu") {
      Get.updateLocale(const Locale('ur', 'PK'));
    }
  }

  // Language
  var selectedLanguage = "English".obs;

  // Notifications
  var remindersEnabled = true.obs;
  var dailySummaryEnabled = false.obs;
  var budgetLimitAlerts = true.obs;

  // Methods
  void changeTheme(int value) {
    themeMode.value = value;
    // TODO: save to local storage
  }

  void changeLanguage2(String lang) {
    selectedLanguage.value = lang;
    // TODO: save to local storage
  }

  void toggleReminder(bool value) {
    remindersEnabled.value = value;
  }

  void toggleDailySummary(bool value) {
    dailySummaryEnabled.value = value;
  }

  void toggleBudgetAlert(bool value) {
    budgetLimitAlerts.value = value;
  }

  // 🔥 Clear All Expenses
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
