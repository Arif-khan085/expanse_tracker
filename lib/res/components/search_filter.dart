import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  const SearchFilter({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.greyColor2,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        cursorColor: AppColors.blackColor,
        style: TextStyle(color: AppColors.blackColor),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: AppColors.blackColor),
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.blackColor),
          border: InputBorder.none,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.blackColor),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
