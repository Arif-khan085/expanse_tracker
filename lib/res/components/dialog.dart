import 'package:flutter/material.dart';

void showEntryDialog(BuildContext context, String type) {
  final amountController = TextEditingController();
  final descController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('$type Entry'),
        content: SingleChildScrollView( // prevent overflow
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = amountController.text.trim();
              final desc = descController.text.trim();

              if (amount.isEmpty || desc.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              Navigator.pop(context); // close dialog

              // ✅ This will print the values in console
              print('$type → ₹$amount, Desc: $desc');
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
