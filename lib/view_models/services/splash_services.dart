
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../view/homescreen/homescreen.dart';
import '../../view/login/login_view.dart';

class SplashServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void isLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = _auth.currentUser;

    if (user != null) {
      /// User already logged in
      Get.offAll(() => HomeScreen());
    } else {
      /// User not logged in
      Get.offAll(() => LoginView());
    }
  }
}
