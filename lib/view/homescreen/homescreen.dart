import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/components/add_balance.dart';
import 'package:expense_tracker/res/components/add_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors/app_colors.dart';
import '../../res/components/buttomnavigatorbar.dart';
import '../../view_models/services/expense/expanse.dart';
import '../seeallexpense/All_expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  String? uid;
  final Expanse expenseController = Get.put(Expanse());

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: 0,
        onItemSelect: (int value) {},
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.cardColor,
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            AddBalance(title: 'Balance', balance: 2000),
            Row(
              children: [
                Expanded(
                  child: BalanceItem(
                    footerText: 'Enter Salary',
                    title: 'Salary',
                    amount: 2000,
                    color: AppColors.tealColor,
                    icon: Icons.save,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: BalanceItem(
                    footerIcons: [Icons.arrow_upward],
                    title: 'Expense',
                    amount: 2000,
                    color: AppColors.blueColor,
                    icon: Icons.exit_to_app,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 📌 Expense list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('expenses')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No Expense Found'));
                  }

                  final expenses = snapshot.data!.docs;

                  // sirf 5 show karna
                  final limitedExpenses = expenses.length > 5
                      ? expenses.sublist(0, 5)
                      : expenses;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (expenses.length > 5)
                            TextButton(
                              onPressed: () {
                                Get.to(() => AllExpensesScreen(uid: uid!));
                              },
                              child: Text("See All"),
                            ),
                        ],
                      ),
                      // sirf 5 list show
                      Expanded(
                        child: ListView.builder(
                          itemCount: limitedExpenses.length,
                          itemBuilder: (context, index) {
                            var exp = limitedExpenses[index].data() as Map<String, dynamic>;

                            return Card(
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
                                trailing: Text("Rs ${exp['amount']}"),
                              ),
                            );
                          },
                        ),
                      ),

                      // 📌 "See All" button

                    ],
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ✏️ Edit dialog
  void _showEditDialog(String docId, Map<String, dynamic> data) {
    final titleController = TextEditingController(text: data['title']);
    final amountController = TextEditingController(
      text: data['amount'].toString(),
    );

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
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: selectedPayment,
                  decoration: const InputDecoration(labelText: "Payment"),
                  items: payment.map((String p) {
                    return DropdownMenuItem<String>(value: p, child: Text(p));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value!;
                    });
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
                expenseController.updateExpense(docId, updatedData);
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
