import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../view_models/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin();
  }


  @override
  Widget build(BuildContext context) {



    return Center(
      child: SizedBox(
        height: 80,
        width: 80,
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotate,
          colors: [Colors.green, Colors.red, Colors.blue, Colors.deepPurple],
          pathBackgroundColor: Colors.black, // Optional: inner path color
        ),
      ),
    );
  }
}
