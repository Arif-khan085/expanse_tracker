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
    return Column(
      children: [
        ListTile(
          leading: leadingIcon,
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          trailing: trailingIcon,
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
