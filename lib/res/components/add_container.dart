import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:flutter/material.dart';

class BalanceItem extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;
  final String? footerText; // bottom text
  final List<IconData>? footerIcons; // bottom icons


  const BalanceItem({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    this.footerText,
    this.footerIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, // shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.orange, Colors.red,],
            center: Alignment.center,
            radius: 0.8,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          color: color.withOpacity(0.05), // light background
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ─── Top part ───
            Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 16),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '\$${amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ─── Bottom part ───
            if (footerText != null || (footerIcons != null && footerIcons!.isNotEmpty))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Bottom text
                    if (footerText != null)
                      Text(
                        footerText!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),

                    // Bottom icons
                    if (footerIcons != null && footerIcons!.isNotEmpty)
                      Row(
                        children: footerIcons!
                            .map((iconData) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(iconData, size: 30, color: color),
                        ))
                            .toList(),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
