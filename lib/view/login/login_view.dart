

import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/components/round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/assets/images.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage(AppImages.firstScreen)),
            Text('Expense Tracker',style: TextStyle(color: AppColors.whiteColor,fontSize: 25),),
            Text('Welcome back',style: TextStyle(color: AppColors.whiteColor,fontSize: 30),),
            RoundButtontwo(

                title: 'login', onPress: (){}),
            RoundButton(title: 'login', onPress: (){})
          ],
        ),
      ),
    );
  }
}
