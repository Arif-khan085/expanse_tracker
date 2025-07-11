import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/components/round_button.dart';
import 'package:expense_tracker/res/components/textfield_button.dart';
import 'package:expense_tracker/view/signin/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                'Create Your\n Account',
                style: TextStyle(fontSize: 40, color: AppColors.whiteColor),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,

                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      RoundTextField(
                        controller: nameController,
                        labelText: 'name',
                        hintText: 'Enter Name',
                        prefixIcon: Icons.person,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 20),
                      RoundTextField(
                        controller: emailController,
                        labelText: 'Email',
                        hintText: 'Enter Email',
                        prefixIcon: Icons.email,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 20),
                      RoundTextField(
                        controller: passwordController,
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        prefixIcon: Icons.password,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 50),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RoundButton(
                            buttonColor: AppColors.backgroundColor,
                            textColor: AppColors.whiteColor,
                            title: 'SIGN UP',
                            onPress: () {},
                            color: AppColors.whiteColor,
                            textStyle: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 40),
                          Text("Already have an Account"),
                          TextButton(
                            onPressed: () {
                              Get.to(SignIn());
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: AppColors.blueColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
