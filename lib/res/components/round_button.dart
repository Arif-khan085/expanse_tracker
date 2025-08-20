import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:flutter/material.dart';


class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.buttonColor,
    this.textStyle,
    required this.title,
    required this.onPress,
    this.width = 80,
    this.height = 55,
    this.loading = false,
    required this.color,
  });
  final TextStyle? textStyle;
  final Color color;
  final bool loading;
  final String title;
  final double height, width;
  final VoidCallback onPress;

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
                    style: textStyle?? TextStyle(
                      fontSize: 18,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
