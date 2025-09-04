import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AddBalance extends StatelessWidget {
  final String title;
  final double balance;

  const AddBalance({
    super.key,
    required this.title,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.17,
      width: MediaQuery.of(context).size.width * 1,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.green, Colors.red,],
          center: Alignment.center,
          radius: 0.8,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.greenColor.withOpacity(0.5),
          width: 1,
        ),
        color: AppColors.greenColor.withOpacity(0.05),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cart Title
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),

          // Balance
          Text(
            "\$${balance.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
