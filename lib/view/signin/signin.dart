import 'package:expense_tracker/models/user_model.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/components/round_button.dart';
import 'package:expense_tracker/view/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/components/textfield_button.dart';
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

  // 👁️ Password visibility toggle
  bool _obscurePassword = true;

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
                'Login Your\n Account',
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
                    borderRadius: const BorderRadius.only(
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
                        const SizedBox(height: 20),
                        // Email Field (no border)
                        RoundTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          controller: emailController,
                          labelText: 'Email',
                          hintText: 'Enter Email',
                          prefixIcon: Icons.email,
                          obscureText: false, // 🚀 Email is not hidden
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const Divider(), // light underline instead of border
                        const SizedBox(height: 20),

                        // 👁️ Password field with no border
                        RoundTextField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter password';
                            if (value.length < 6)
                              return 'Password must be at least 6 characters';
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
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        ),
                        const Divider(), // underline for password
                        const SizedBox(height: 50),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RoundButton(
                              loading: loading,
                              buttonColor: AppColors.backgroundColor,
                              title: 'SIGN IN',
                              onPress: () {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  final user = UserModel(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: '',
                                  );
                                  AuthController().signInUser(user, () {
                                    setState(() {
                                      loading = false;
                                    });
                                    Get.to(() => const HomeScreen());
                                  });
                                }
                              },
                              color: AppColors.whiteColor,
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 40),
                            const Text("Don't have an Account"),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const SignUp());
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
