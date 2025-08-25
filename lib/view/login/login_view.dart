import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/components/round_button.dart';
import 'package:expense_tracker/res/constants/accounts.dart';
import 'package:expense_tracker/view/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../signin/signin.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(height: 80, image: AssetImage("assets/images/expense.png")),
            SizedBox(height: 20),
            Text(
              'Expense Tracker',
              style: TextStyle(color: AppColors.whiteColor, fontSize: 25),
            ),
            SizedBox(height: 30),
            Text(
              'Welcome back',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 30),
            RoundButton(
              title: 'Login',
              onPress: () {
                Get.to(SignIn());
              },
              color: AppColors.blackColor,
              buttonColor: AppColors.greyColor,
              textStyle: TextStyle(fontSize: 40, color: AppColors.blackColor),
            ),
            SizedBox(height: 20),
            RoundButton(
              title: 'Sign up',
              onPress: () {
                Get.to(SignUp());
              },
              color: AppColors.whiteColor,
              buttonColor: AppColors.cardColor,
              textStyle: TextStyle(fontSize: 30, color: AppColors.blackColor),
            ),
            SizedBox(height: 100),
            Text(
              'Login With Google',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.whiteColor,
                fontStyle: FontStyle.italic,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Accounts(
                        onPress: () {
                          Get.to(SignUp());
                        },
                        imagePath: 'assets/images/google.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
