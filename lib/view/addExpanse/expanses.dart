
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/colors/app_colors.dart';
import '../../res/components/buttomnavigatorbar.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cardColor,
        title: Text('Expense'),
      ),
      bottomNavigationBar: CustomNavigationBar(selectIndex: 1, onItemSelect: (int value) {  },),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

        ],
      ),
    );
  }
}
