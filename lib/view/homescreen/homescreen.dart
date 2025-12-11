import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/components/add_balance.dart';
import 'package:expense_tracker/res/components/add_container.dart';
import 'package:expense_tracker/view/settings/settings_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/colors/app_colors.dart';
import '../../res/components/buttomnavigatorbar.dart';
import '../../view_models/services/amount_controller.dart';
import '../seeallexpense/All_expense.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user;
  String? uid;

  //final AmountService _expenseService = AmountService();

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


   //final AmountService = Get.put(AmountService());
  final AmountService controller = Get.put(AmountService());

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Column(
          children: [
            // ✅ Available Balance
            StreamBuilder<DocumentSnapshot>(
              stream: controller.getAvailableBalance(uid!),
              builder: (context, snapshot) {
                double availableBalance = 0;
                if (snapshot.hasData && snapshot.data!.exists) {
                  availableBalance =
                      (snapshot.data!['amount'] as num).toDouble();
                }
                return AddBalance(
                  title: 'Available Balance',
                  balance: availableBalance,
                  icon: Icons.edit,
                  onIconPressed: () async {
                    final balSnap = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('balance')
                        .doc('balanceDoc')
                        .get();

                    double currentBalance =
                    balSnap.exists ? (balSnap['amount'] as num).toDouble() : 0;

                    _showEditBalanceDialog(currentBalance);
                  },
                );
              },
            ),

            // ✅ Salary + Expense Row
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: controller.getSalary(uid!),
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
                        icon: Icons.edit,
                        onIconPressed: () {
                          _showEditSalaryDialog(salary);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: controller.getExpenseSummary(uid!),
                    builder: (context, snapshot) {
                      double totalExpense = 0;
                      if (snapshot.hasData && snapshot.data!.exists) {
                        totalExpense =
                            (snapshot.data!['amount'] as num).toDouble();
                      }

                      return BalanceItem(
                        footerIcons: [Icons.arrow_upward],
                        title: 'Expense',
                        amount: totalExpense,
                        color: AppColors.blueColor,
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
                stream: controller.getExpenses(uid!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No Expense Found'));
                  }

                  final expenses = snapshot.data!.docs;
                  final limitedExpenses =
                  expenses.length > 5 ? expenses.sublist(0, 5) : expenses;

                  // ✅ Auto update summary
                  controller.updateSummary(uid!, expenses);

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
                            var exp =
                            limitedExpenses[index].data() as Map<String, dynamic>;

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
                              shadowColor: Colors.black26,
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                                      child: const Icon(
                                        Icons.shopping_bag, // (you can map category to icons)
                                        color: Colors.blue,
                                        size: 28,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // 🔹 Expense Details (Title, Category, Date, Payment)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exp['title'] ?? 'No Title',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${exp['category']} • ${exp['payment']}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
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

                                    // 🔹 Amount
                                    Text(
                                      "Rs ${exp['amount']}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: exp['amount'] >= 0 ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
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
      ),
    );
  }

  // ✅ Balance Edit Dialog
  void _showEditBalanceDialog(double currentBalance) {
    final TextEditingController balanceController =
    TextEditingController(text: currentBalance.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Balance"),
          content: TextField(
            controller: balanceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter Balance",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Update"),
              onPressed: () async {
                final balance =
                    double.tryParse(balanceController.text.trim()) ?? 0;

                if (balance > 0) {
                  await controller.updateBalance(uid!, balance);

                  // ✅ Update availableBalance
                  final expenseSnap = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('summary')
                      .doc('expenseDoc')
                      .get();

                  double totalExpense = expenseSnap.exists
                      ? (expenseSnap['amount'] as num).toDouble()
                      : 0;

                  double availableBalance = balance - totalExpense;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('summary')
                      .doc('availableBalanceDoc')
                      .set({
                    'amount': availableBalance,
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

  // ✅ Salary Edit Dialog
  void _showEditSalaryDialog(double currentSalary) {
    final TextEditingController salaryController =
    TextEditingController(text: currentSalary.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Salary"),
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
              child: const Text("Update"),
              onPressed: () async {
                final salary =
                    double.tryParse(salaryController.text.trim()) ?? 0;
                if (salary > 0) {
                  await controller.updateSalary(uid!, salary);
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
