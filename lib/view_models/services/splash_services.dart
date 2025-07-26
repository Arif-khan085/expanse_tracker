


import 'dart:async';

import 'package:expense_tracker/view/homescreen/homescreen.dart';
import 'package:expense_tracker/view/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../res/routes/routes_named.dart';

class SplashServices{
  final _auth = FirebaseAuth.instance;

  void isLogin()async{
    await Future.delayed(Duration(seconds: 2));

    final user= _auth.currentUser;
    if(user!=null){
      Get.to(HomeScreen());
    }else{
      Get.to(LoginView());
    }

  }
}