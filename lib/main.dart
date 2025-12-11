// import 'package:expense_tracker/res/routes/routes.dart';
// import 'package:expense_tracker/res/translation/apptranslation.dart';
// import 'package:expense_tracker/view/splash_screen.dart';
// import 'package:expense_tracker/view_models/services/firebase_services.dart';
//
// import 'package:expense_tracker/view_models/settings/setting_view_models.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   // Put controllers in memory
//   Get.put(AuthController());
//   Get.put(SettingsViewModel()); // <-- Add this
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final settingsController = Get.find<SettingsViewModel>();
//
//     return Obx(() => Directionality(
//       textDirection: TextDirection.ltr, // FORCE LTR ALWAYS
//       child: GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//
//         home: SplashScreen(),
//         getPages: AppRoutes.appRoutes(),
//
//         // 🌐 Languages
//         translations: AppTranslations(),
//         locale: settingsController.currentLocale.value, // <-- bind locale
//         fallbackLocale: const Locale('en', 'US'),
//
//         // Themes
//         theme: ThemeData.light(),
//         darkTheme: ThemeData.dark(),
//         themeMode: settingsController.themeMode.value == 0
//             ? ThemeMode.system
//             : settingsController.themeMode.value == 1
//             ? ThemeMode.light
//             : ThemeMode.dark,
//       ),
//     ));
//
//
//   }
// }
//



import 'package:expense_tracker/res/routes/routes.dart';
import 'package:expense_tracker/res/translation/apptranslation.dart';
import 'package:expense_tracker/view/splash_screen.dart';
import 'package:expense_tracker/view_models/services/firebase_services.dart';

import 'package:expense_tracker/view_models/settings/setting_view_models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Put controllers in memory
  Get.put(AuthController());
  Get.put(SettingsViewModel()); // <-- Add this

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsViewModel>();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr, // FORCE LTR GLOBALLY
          child: child!,
        );
      },

      home: SplashScreen(),
      getPages: AppRoutes.appRoutes(),

      translations: AppTranslations(),
      locale: settingsController.currentLocale.value,
      fallbackLocale: const Locale('en', 'US'),

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: settingsController.themeMode.value == 0
          ? ThemeMode.system
          : settingsController.themeMode.value == 1
          ? ThemeMode.light
          : ThemeMode.dark,
    ));
  }
}


