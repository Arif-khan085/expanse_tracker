import 'package:expense_tracker/view/login/login_view.dart';
import 'package:expense_tracker/view_models/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors/app_colors.dart';
import '../../res/components/buttomnavigatorbar.dart';
import '../../res/components/profile_seting.dart';
import '../settings/settings_screens.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profilePicUrl; // ✅ Corrected: Variable declared here

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cardColor,
        title: const Text('Profile'),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: 3,
        onItemSelect: (int value) {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.15,
                    backgroundImage: profilePicUrl != null
                        ? NetworkImage(profilePicUrl!)
                        : null,
                    backgroundColor: Colors.grey.shade300,
                    child: profilePicUrl == null
                        ? Icon(Icons.person, size: screenWidth * 0.15)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        // You can implement image picker here
                      },
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.015),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.teal,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              const Divider(),
              ProfileTile(
                leadingIcon: const Icon(Icons.key),
                title: 'Setting',
                trailingIcon: const Icon(Icons.arrow_forward_ios_sharp),
                onTap: () {
                  Get.to(SettingsView());
                },
              ),
              const Divider(),
              ProfileTile(
                leadingIcon: const Icon(Icons.logout),
                title: 'Logout',
                trailingIcon: const Icon(Icons.arrow_forward_ios_sharp),
                onTap: () {
                  AuthController.instance.signOutUser();
                  Get.to(LoginView());
                },
              ),
              const Divider(),
              ProfileTile(
                leadingIcon: const Icon(Icons.help),
                title: 'Help',
                trailingIcon: const Icon(Icons.arrow_forward_ios_sharp),
                onTap: () {
                  // logout logic here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
