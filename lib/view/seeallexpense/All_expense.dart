import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/components/search_filter.dart';
import '../../view_models/services/expense/expanse.dart';

class AllExpensesScreen extends StatefulWidget {
  final String uid;
  const AllExpensesScreen({super.key, required this.uid});

  @override
  State<AllExpensesScreen> createState() => _AllExpensesScreenState();
}

class _AllExpensesScreenState extends State<AllExpensesScreen> {
  final Expanse expenseController = Get.put(Expanse());
  final TextEditingController searchController = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cardColor,
        title: const Text("All Expenses"),
      ),
      body: Column(
        children: [
          // 🔎 Search Filter on Top
          SearchFilter(
            controller: searchController,
            hintText: "Search expenses...",
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase();
              });
            },
          ),

          // 📌 Expenses List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.uid)
                  .collection('expenses')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Expense Found'));
                }

                final expenses = snapshot.data!.docs.where((doc) {
                  var exp = doc.data() as Map<String, dynamic>;
                  String title = exp['title']?.toString().toLowerCase() ?? '';
                  String category = exp['category']?.toString().toLowerCase() ?? '';
                  String payment = exp['payment']?.toString().toLowerCase() ?? '';

                  return title.contains(searchText) ||
                      category.contains(searchText) ||
                      payment.contains(searchText);
                }).toList();

                if (expenses.isEmpty) {
                  return const Center(child: Text('No matching expenses'));
                }

                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    var exp = expenses[index].data() as Map<String, dynamic>;
                    var docId = expenses[index].id;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: ListTile(
                        title: Text(exp['title'] ?? 'No Title'),
                        subtitle: Text(
                          "Category: ${exp['category']}\n"
                              "Payment: ${exp['payment']}\n"
                              "Date: ${exp['date']}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Rs ${exp['amount']}"),

                            // 🗑 Delete button
                            IconButton(
                              onPressed: () {
                                expenseController.deleteExpense(docId);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),

                            // ✏️ Edit button
                            IconButton(
                              onPressed: () {
                                _showEditDialog(
                                  context,
                                  expenseController,
                                  docId,
                                  exp,
                                );
                              },
                              icon: const Icon(Icons.edit, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ✏️ Edit Dialog
  void _showEditDialog(
      BuildContext context,
      Expanse controller,
      String docId,
      Map<String, dynamic> data,
      ) {
    final titleController = TextEditingController(text: data['title']);
    final amountController =
    TextEditingController(text: data['amount'].toString());

    final List<String> categories = [
      'Food',
      'Transport',
      'Shopping',
      'Bills',
      'Entertainment',
      'Health',
      'Education',
      'Savings',
      'Travel',
      'Groceries',
      'Rent',
      'Salary',
      'Utilities',
      'Investments',
      'Others',
    ];
    String selectedCategory = data['category'] ?? categories.first;

    final List<String> payment = [
      'Cash',
      'Credit Card',
      'Debit Card',
      'Bank Transfer',
      'MobileWallet',
      'PayPal',
      'GooglePay',
      'ApplePay',
      'EasyPaisa',
      'JazzCash',
      'Cheque',
      'UPI',
      'Cryptocurrency',
      'Gift Card',
      'Others',
    ];
    String selectedPayment = data['payment'] ?? payment.first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Expense"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: "Amount"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: "Category"),
                  items: categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedCategory = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: selectedPayment,
                  decoration: const InputDecoration(labelText: "Payment"),
                  items: payment.map((String p) {
                    return DropdownMenuItem(value: p, child: Text(p));
                  }).toList(),
                  onChanged: (value) {
                    selectedPayment = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedData = {
                  "title": titleController.text,
                  "amount": double.tryParse(amountController.text) ?? 0,
                  "category": selectedCategory,
                  "payment": selectedPayment,
                  "updatedAt": DateTime.now(),
                };
                controller.updateExpense(docId, updatedData);
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
