import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/components/add_balance.dart';
import 'package:expense_tracker/res/components/add_container.dart';
import 'package:expense_tracker/view/settings/settings_screens.dart';
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

  // ✅ Local balance (sirf UI ke liye)
  double totalBalance = 0;

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
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: 0,
        onItemSelect: (int value) {},
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(SettingsView());
            },
            icon: Icon(Icons.settings, color: AppColors.whiteColor),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.cardColor,
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          // ✅ Balance Card (sirf Balance + Expenses ka relation)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('expenses')
                .snapshots(),
            builder: (context, snapshot) {
              double totalExpense = 0;
              if (snapshot.hasData) {
                totalExpense = snapshot.data!.docs.fold(
                  0,
                      (sum, doc) => sum + (doc['amount'] as num).toDouble(),
                );
              }

              double availableBalance = totalBalance - totalExpense;

              return AddBalance(
                title: 'Available Balance',
                balance: availableBalance,
                icon: Icons.add,
                onIconPressed: () {
                  _showAddAmountDialog("Balance");
                },
              );
            },
          ),

          // ✅ Salary + Expense Row
          Row(
            children: [
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('salary')
                      .doc('salaryDoc')
                      .snapshots(),
                  builder: (context, snapshot) {
                    double salary = 0;
                    if (snapshot.hasData && snapshot.data!.exists) {
                      salary = (snapshot.data!['amount'] as num).toDouble();
                    }

                    return BalanceItem(
                      footerText: 'Enter Salary',
                      title: 'Salary',
                      amount: salary,
                      color: AppColors.tealColor,
                      icon: Icons.add,
                      onIconPressed: () {
                        _showAddSalaryDialog();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('expenses')
                      .snapshots(),
                  builder: (context, snapshot) {
                    double totalExpense = 0;
                    if (snapshot.hasData) {
                      totalExpense = snapshot.data!.docs.fold(
                        0,
                            (sum, doc) =>
                        sum + (doc['amount'] as num).toDouble(),
                      );
                    }

                    return BalanceItem(
                      footerIcons: [Icons.arrow_upward],
                      title: 'Expense',
                      amount: totalExpense,
                      color: AppColors.blueColor,
                      icon: Icons.add,
                      onIconPressed: () {
                        _showExpenseDialog();
                      },
                    );
                  },
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
                final limitedExpenses =
                expenses.length > 5 ? expenses.sublist(0, 5) : expenses;

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
                            child: const Text("See All"),
                          ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: limitedExpenses.length,
                        itemBuilder: (context, index) {
                          var exp = limitedExpenses[index].data()
                          as Map<String, dynamic>;

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
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Dialog for Balance only (local update)
  void _showAddAmountDialog(String type) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add $type"),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter Amount",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () {
                final amount =
                    double.tryParse(amountController.text.trim()) ?? 0;

                if (amount > 0) {
                  setState(() {
                    totalBalance += amount;
                  });
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // ✅ Salary Dialog (Firebase me store hoga)
  void _showAddSalaryDialog() {
    final TextEditingController salaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Salary"),
          content: TextField(
            controller: salaryController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter Salary",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                final salary =
                    double.tryParse(salaryController.text.trim()) ?? 0;

                if (salary > 0) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('salary')
                      .doc('salaryDoc')
                      .set({
                    'amount': salary,
                    'updatedAt': FieldValue.serverTimestamp(),
                  });
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // ✅ Expense Add Dialog (Firestore me store hoga)
  void _showExpenseDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                final title = titleController.text.trim();
                final amount =
                    double.tryParse(amountController.text.trim()) ?? 0;

                if (title.isNotEmpty && amount > 0) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('expenses')
                      .add({
                    'title': title,
                    'amount': amount,
                    'category': 'General',
                    'payment': 'Cash',
                    'date': DateTime.now().toString(),
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
