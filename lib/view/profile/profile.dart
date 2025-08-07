import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/components/profile_seting.dart';
import 'package:expense_tracker/view/login/login_view.dart';
import 'package:expense_tracker/view_models/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../res/components/buttomnavigatorbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? ProfilePicUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cardColor,
        title: Text('profile'),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: 3,
        onItemSelect: (int value) {},
      ),
      body: Column(
        children: [
          Text('Profile'),
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: ProfilePicUrl != null
                    ? NetworkImage(ProfilePicUrl!)
                    : null,
                backgroundColor: Colors.grey.shade300,
                child: ProfilePicUrl == null
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
              Positioned(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          ProfileTile(leadingIcon: Icon(Icons.key), title: 'Seeting', trailingIcon: Icon(Icons.arrow_forward_ios_sharp), onTap: (){}),
          Divider(),
          ProfileTile(leadingIcon: Icon(Icons.logout), title: 'Logout', trailingIcon: Icon(Icons.arrow_forward_ios_sharp), onTap: (){
            AuthController.instance.signOutUser();
            Get.to(LoginView());
          }),
          Divider(),
          ProfileTile(leadingIcon: Icon(Icons.help), title: 'Help', trailingIcon: Icon(Icons.arrow_forward_ios_sharp), onTap: (){}),

        ],
      ),
    );
  }
}
