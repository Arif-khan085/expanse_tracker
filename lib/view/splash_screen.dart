

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
    return LoadingIndicator(indicatorType: Indicator.ballBeat,
    colors: [Colors.green,Colors.red,Colors.blue,Colors.deepPurple],
      strokeWidth: 2,
      backgroundColor: Colors.transparent,
      pathBackgroundColor: Colors.black,
    );
  }
}
