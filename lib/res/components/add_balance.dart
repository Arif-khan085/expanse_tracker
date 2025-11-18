import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AddBalance extends StatelessWidget {
  final String title;
  final double balance;
  final VoidCallback onIconPressed;

  const AddBalance({
    super.key,
    required this.title,
    required this.balance,
    required IconData icon,
    required this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.17,
      width: MediaQuery.of(context).size.width * 1,
      margin: const EdgeInsets.symmetric(horizontal: 3,vertical: 9),
      padding: const EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          colors: [Colors.green, Colors.red],
          center: Alignment.center,
          radius: 0.8,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.redColor.withOpacity(0.5),
          width: 1,
        ),
        color: AppColors.redColor.withOpacity(0.05),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon:  Icon(Icons.add_circle, color: Colors.red, size: 28),
                onPressed: onIconPressed,
              ),
            ],
          ),

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
            "\ Rs ${balance.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
