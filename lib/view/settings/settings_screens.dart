import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view_models/services/alldata/clearalldata.dart';
import '../../view_models/settings/setting_view_models.dart';

class SettingsView extends StatelessWidget {
  final SettingsViewModel controller = Get.put(SettingsViewModel());
  String? selectedLanguage;
  final expenseService = AmountService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.cardColor,
          title: Text("Settings".tr,style: TextStyle(color: AppColors.whiteColor),)),
      body: ListView(
        children: [
          // ---------- App Preferences ----------
          ListTile(title: Text("App Preferences".tr, style: TextStyle(fontWeight: FontWeight.bold))),

          Obx(() => ListTile(
            title: Text("Theme Mode".tr),
            subtitle: Text(controller.themeMode.value == 0
                ? "System Default".tr
                : controller.themeMode.value == 1
                ? "Light".tr
                : "Dark".tr),
            trailing: DropdownButton<int>(
              value: controller.themeMode.value,
              items: const [
                DropdownMenuItem(value: 0, child: Text("System Default")),
                DropdownMenuItem(value: 1, child: Text("Light")),
                DropdownMenuItem(value: 2, child: Text("Dark")),
              ],
              onChanged: (val) => controller.changeTheme(val!),
            ),
          )),

         /* Obx(() => ListTile(
            title: Text("Language"),
            subtitle: Text(controller.selectedLanguage.value),
            trailing: DropdownButton<String>(
              value: controller.selectedLanguage.value,
              items: ["English", "Urdu"].map((lang) {
                return DropdownMenuItem(value: lang, child: Text(lang));
              }).toList(),
              onChanged: (val) => controller.changeLanguage(val!),
            ),
          )),
          */

          Obx(() => ListTile(
            title: Text("Language".tr),
            subtitle: Text(controller.selectedLanguage.value),
            trailing: DropdownButton<String>(
              value: controller.selectedLanguage.value,
              items: ["English", "Urdu"].map((lang) {
                return DropdownMenuItem(value: lang, child: Text(lang));
              }).toList(),
              onChanged: (val) => controller.changeLanguage(val!),
            ),
          )),

          Divider(),

          // ---------- Notifications ----------
          ListTile(title: Text("Notifications".tr, style: TextStyle(fontWeight: FontWeight.bold))),

          Obx(() => SwitchListTile(
            title: Text("Enable Reminders"),
            value: controller.remindersEnabled.value,
            onChanged: controller.toggleReminder,
          )),

          Obx(() => SwitchListTile(
            title: Text("Daily Expense Summary".tr),
            value: controller.dailySummaryEnabled.value,
            onChanged: controller.toggleDailySummary,
          )),

          Obx(() => SwitchListTile(
            title: Text("Budget Limit Alerts"),
            value: controller.budgetLimitAlerts.value,
            onChanged: controller.toggleBudgetAlert,
          )),

          Divider(),

          // ---------- Data Management ----------
          ListTile(title: Text("Data Management".tr, style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(
            title: Text("Clear All Data",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.delete, color: Colors.red),
            onTap: () {
              Get.defaultDialog(
                title: "Confirm",
                middleText: "Are you sure you want to clear all data?",
                textCancel: "No",
                textConfirm: "Yes",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  expenseService.clearAllData();
                  Get.back(); // close dialog
                },
                onCancel: () {},
              );
            },
          ),


          Divider(),

          // ---------- App Info ----------
          ListTile(title: Text("App Info", style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(title: Text("About App"), subtitle: Text("Version 1.0.0\nDeveloped by Arif")),
          ListTile(title: Text("Privacy Policy"), onTap: () {}),
          ListTile(title: Text("Terms & Conditions"), onTap: () {}),
          ListTile(title: Text("Contact Support"), subtitle: Text("support@email.com")),
        ],
      ),
    );
  }
}
