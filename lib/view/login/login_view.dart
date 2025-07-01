import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/components/round_button.dart';
import 'package:expense_tracker/res/constants/accounts.dart';
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
              onPress: () {},
              color: AppColors.blackColor,
              textColor: AppColors.whiteColor,
              buttonColor: AppColors.greyColor,
            ),
            SizedBox(height: 10),
            RoundButton(
              title: 'Sign up',
              onPress: () {},
              color: AppColors.whiteColor,
              textColor: AppColors.whiteColor,
              buttonColor: AppColors.cardColor,
            ),
            SizedBox(height: 20),
            Text('Login With Social Media',style: TextStyle(fontSize: 20,color: AppColors.whiteColor),),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Accounts(
                        onPress: () {
                          // google
                        },
                        imagePath: 'assets/images/images.png',
                      ),
                      SizedBox(width: 10),
                      Accounts(
                        onPress: () {
                          // instagram
                        },
                        imagePath: 'assets/images/app_logo.png',
                      ),
                      SizedBox(width: 10),
                      Accounts(
                        onPress: () {
                          // facebook
                        },
                        imagePath: 'assets/images/app_logo.png',
                      ),
                    ],
                  ),
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}
