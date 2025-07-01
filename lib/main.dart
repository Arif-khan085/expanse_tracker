import 'package:expense_tracker/res/routes/routes.dart';
import 'package:expense_tracker/res/routes/routes_named.dart';
import 'package:expense_tracker/view/home_screen.dart';
import 'package:expense_tracker/view/login/login_view.dart';
import 'package:expense_tracker/view/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      getPages: AppRoutes.appRoutes(),
    );
  }
}


