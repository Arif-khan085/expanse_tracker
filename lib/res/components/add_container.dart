import 'package:flutter/material.dart';

class BalanceItem extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData? icon; // optional icon
  final VoidCallback? onIconPressed; // optional button action
  final String? footerText; // bottom text
  final List<IconData>? footerIcons; // bottom icons

  const BalanceItem({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    this.icon, // optional
    this.onIconPressed, // optional
    this.footerText,
    this.footerIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.16,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          colors: [Colors.orange, Colors.red],
          center: Alignment.center,
          radius: 0.8,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
        color: color.withValues(alpha: 0.05),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ─── Top part ───
          Row(
            children: [
              // Show IconButton only if icon is provided
              if (icon != null)
                IconButton(
                  icon: Icon(icon, size: 28, color: color),
                  onPressed: onIconPressed,
                ),

              if (icon != null) const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '\ Rs ${amount.toStringAsFixed(2)}',
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
    );
  }
}
