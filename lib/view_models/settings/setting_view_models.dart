import 'package:get/get.dart';

class SettingsViewModel extends GetxController {
  // Theme (0 = system, 1 = light, 2 = dark)
  var themeMode = 0.obs;

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

  void changeLanguage(String lang) {
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

  void clearAllData() {
    // TODO: implement Firebase/local DB clear logic
  }
}
