import 'package:flutter/material.dart';

class RowButtons extends StatelessWidget {
  final Function(String type) onPressed;

  const RowButtons({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => onPressed('Add'),
          icon: const Icon(Icons.add, color: Colors.green),
          label: const Text('Add'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade100,
            foregroundColor: Colors.green.shade900,
          ),
        ),
        SizedBox(width: 40),
        ElevatedButton.icon(
          onPressed: () => onPressed('Expense'),
          icon: const Icon(Icons.remove, color: Colors.red),
          label: const Text('Expense'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade100,
            foregroundColor: Colors.red.shade900,
          ),
        ),
      ],
    );
  }
}
