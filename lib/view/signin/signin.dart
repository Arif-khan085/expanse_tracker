import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/components/round_button.dart';
import 'package:expense_tracker/res/components/textfield_button.dart';

import 'package:expense_tracker/view/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../view_models/services/firebase_services.dart';
import '../homescreen/homescreen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        RoundTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter email';
                            }
                            return null;
                          },
                          controller: emailController,
                          labelText: 'Email',
                          hintText: 'Enter Email',
                          prefixIcon: Icons.email,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 20),
                        RoundTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          controller: passwordController,
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          prefixIcon: Icons.password,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 50),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RoundButton(
                              loading: loading,
                              buttonColor: AppColors.backgroundColor,
                              textColor: AppColors.whiteColor,
                              title: 'SIGN IN',
                              onPress: () {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  final user = UserModel(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  AuthController().signInUser(user, () {
                                    setState(() {
                                      loading = false;
                                    });
                                    Get.to(HomeScreen());
                                  });
                                }
                              },
                              color: AppColors.whiteColor,
                              textStyle: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 40),
                            Text("Don't have an Account"),
                            TextButton(
                              onPressed: () {
                                Get.to(SignUp());
                              },
                              child: Text(
                                'Sign Up',
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
