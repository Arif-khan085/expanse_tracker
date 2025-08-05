import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.textStyle,
    required this.buttonColor,
    required this.textColor,
    required this.title,
    required this.onPress,
    this.loading = false,
    this.useIcon = false,
    this.iconData = Icons.save,
    this.width = 350,
    this.height = 60,
  });

  final TextStyle textStyle;
  final Color buttonColor;
  final Color textColor;
  final String title;
  final bool loading;
  final bool useIcon;
  final IconData iconData;
  final VoidCallback onPress;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: InkWell(
        onTap: loading ? null : onPress,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: buttonColor,
            shape: (width == height) ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: (width == height) ? null : BorderRadius.circular(50),
          ),
          child: loading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Center(
            child: useIcon
                ? Icon(iconData, color: textColor)
                : Text(
              title,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
