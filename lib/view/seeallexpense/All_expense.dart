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
        title: Text("All Expenses"),
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
                  return Center(child: Text('No matching expenses'));
                }

                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    var exp = expenses[index].data() as Map<String, dynamic>;
                    var docId = expenses[index].id;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black26,
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 🔹 Category Icon Box
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.shopping_bag,
                                color: Colors.blue,
                                size: 28,
                              ),
                            ),

                            SizedBox(width: 12),

                            // 🔹 Expense Details (Title, Category, Date, Payment)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exp['title'] ?? 'No Title',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${exp['category']} • ${exp['payment']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    exp['date'] ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🔹 Amount + Action Buttons
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Rs ${exp['amount']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: exp['amount'] >= 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                                      onPressed: () {
                                        _showEditDialog(context, expenseController, docId, exp);
                                      },
                                    ),
                                    IconButton(
                                      icon:Icon(Icons.delete, color: Colors.red, size: 20),
                                      onPressed: () {
                                        _showDeleteDialog(context, expenseController, docId);
                                      },
                                    ),
                                  ],
                                ),
                              ],
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
          title: Text("Edit Expense"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Amount"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(labelText: "Category"),
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
                  decoration:InputDecoration(labelText: "Payment"),
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
              child: Text("Cancel"),
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
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // 🗑️ Delete Confirmation Dialog
  void _showDeleteDialog(BuildContext context, Expanse controller, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Expense"),
          content: Text("Are you sure you want to delete this expense?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                controller.deleteExpense(docId);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
