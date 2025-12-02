import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/components/round_button.dart';
import 'package:expense_tracker/res/components/textfield_button.dart';
import 'package:expense_tracker/view/signin/signin.dart';
import 'package:expense_tracker/view_models/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../homescreen/homescreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  bool _obscurePassword = true;

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                'Create Your\nAccount',
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
                  padding:  EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          RoundTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              if (value.length < 3) {
                                return 'Name must be at least 3 characters';
                              }
                              return null;
                            },
                            controller: nameController,
                            labelText: 'Name',
                            hintText: 'Enter Your Name',
                            prefixIcon: Icons.person,
                            obscureText: false,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 20),
                          RoundTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                            controller: emailController,
                            labelText: 'Email',
                            hintText: 'Enter Email',
                            prefixIcon: Icons.email,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 20),
                          RoundTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            controller: passwordController,
                            labelText: 'Password',
                            hintText: 'Enter Password',
                            prefixIcon: Icons.lock,
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.text,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                           SizedBox(height: 50),
                          RoundButton(
                            title: loading ? "Signing Up..." : "SIGN UP",
                            color: AppColors.backgroundColor,
                            buttonColor: AppColors.backgroundColor,
                            onPress: () {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                setState(() => loading = true);

                                final user = UserModel(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );

                                controller.registerUser(user, () {
                                  setState(() => loading = false);
                                  Get.offAll(() => const HomeScreen());
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 40),
                          RoundButton(
                            buttonColor: AppColors.backgroundColor,
                            title: Image.asset(
                              height: 40,
                              width: 40,
                              'assets/images/google_logo.png',
                            ),
                            onPress: () {},
                            color: AppColors.whiteColor, textStyle: null,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              TextButton(
                                onPressed: () => Get.to(() => const SignIn()),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: AppColors.blueColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
