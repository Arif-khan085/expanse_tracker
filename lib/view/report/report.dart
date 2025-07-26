import 'package:expense_tracker/res/components/buttomnavigatorbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/colors/app_colors.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cardColor,
        title: Text('Report'),
      ),
      bottomNavigationBar: CustomNavigationBar(selectIndex: 2, onItemSelect: (int value){}),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

        ],
      ),
    );
  }
}
