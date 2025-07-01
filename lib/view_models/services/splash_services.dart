


import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../res/routes/routes_named.dart';

class SplashServices{

  void isLogin(){

    Timer(Duration(seconds: 2),()=>Get.toNamed(RoutesName.loginView));
  }
}