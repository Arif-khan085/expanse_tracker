import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/components/buttomnavigatorbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(selectIndex: 0, onItemSelect: (int value) {  },),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.cardColor,
        centerTitle: true,
        title: Text('home'),
      ),


    );
  }
}


