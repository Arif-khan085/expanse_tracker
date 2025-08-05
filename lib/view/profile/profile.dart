import 'package:expense_tracker/res/colors/app_colors.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
             AuthController.instance.signOutUser();
            Get.to(LoginView());
          }, icon: Icon(Icons.logout))
        ],
        backgroundColor: AppColors.cardColor,
        title: Text('profile'),
      ),
      bottomNavigationBar: CustomNavigationBar(selectIndex: 3, onItemSelect: (int value){ },),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

        ],
      ),
    );
  }
}
