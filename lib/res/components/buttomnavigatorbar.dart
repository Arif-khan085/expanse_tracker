import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/view/addExpanse/expanses.dart';
import 'package:expense_tracker/view/homescreen/homescreen.dart';
import 'package:expense_tracker/view/profile/profile.dart';
import 'package:expense_tracker/view/report/report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectIndex;
  final ValueChanged<int> onItemSelect;

  const CustomNavigationBar({
    super.key,
    required this.selectIndex,
    required this.onItemSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectIndex,

      onTap: (index) {
        if (index == selectIndex) return;
        onItemSelect(index);
        switch (index) {
          case 0:
            Get.off(() => HomeScreen());
          case 1:
            Get.off(() => Expense());
          case 2:
            Get.off(() => Report());
          case 3:
            Get.off(()=>Profile());
            break;
        }
      },
      selectedItemColor: AppColors.cardColor,
      unselectedItemColor: AppColors.blackColor,
      showSelectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, size: 30),
          label: 'Add Expense',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined, size: 30),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 30),
          label: 'Profile',
        ),
      ],
    );
  }
}
