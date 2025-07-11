import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.textStyle,
    required this.buttonColor,
    required this.textColor,
    required this.title,
    required this.onPress,
    this.width = 80,
    this.height = 55,
    this.loading = false,
    required this.color,
  });
  final TextStyle textStyle;
  final Color color;
  final bool loading;
  final String title;
  final double height, width;
  final VoidCallback onPress;
  final Color textColor;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: InkWell(
        onTap: onPress,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: loading
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Text(
                    title,
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
        ),
      ),
    );
  }
}
