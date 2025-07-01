import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class Accounts extends StatelessWidget {
  const Accounts({
    super.key,
    required this.onPress,
    required this.imagePath,
  });

  final String imagePath; // ✅ Accept a string path instead of Image
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(60),
        ),
      ),
    );
  }
}
