import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final Icon leadingIcon;
  final String title;
  final Icon trailingIcon;
  final VoidCallback onTap;

  const ProfileTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.trailingIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // spacing between tiles
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // set your desired background color
          borderRadius: BorderRadius.circular(12), // round corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0), // subtle shadow
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: leadingIcon,
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          trailing: trailingIcon,
          onTap: onTap,
        ),
      ),
    );
  }
}
