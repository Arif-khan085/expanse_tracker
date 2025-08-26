import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/components/add_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors/app_colors.dart';
import '../../res/components/buttomnavigatorbar.dart';
import '../../res/components/search_filter.dart';
import '../../view_models/services/expense/expanse.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
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
        body: Center(child: CircularProgressIndicator()),
      );
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
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: (){}, child: Text('Monthly')),
                ElevatedButton(onPressed: (){}, child: Text('yearly')),
              ],
            ),
            Expanded(child: BalanceItem(
              title: 'Balance', amount: 2000, color: AppColors.blueColor, icon: Icons.add, )),
            Row(
              children: [
                Expanded(child: BalanceItem(
                  footerText: 'Enter Salery',
                  title: 'Salery', amount: 2000, color: AppColors.tealColor, icon: Icons.save, )),
                SizedBox(width: 5,),
                Expanded(child: BalanceItem(
                  footerIcons: [Icons.arrow_upward],
                  title: 'Expense', amount: 2000, color: AppColors.blueColor, icon: Icons.exit_to_app, )),
              ],
            ),
            SizedBox(height: 10,),
            // 🔎 Search bar
            SearchFilter(
              controller: searchController,
              hintText: 'Search Title',
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),

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
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No Expense Found'));
                  }

                  final expenses = snapshot.data!.docs;

                  final filteredExpenses = expenses.where((expense) {
                    var data = expense.data() as Map<String, dynamic>;
                    final title = data['title']?.toString().toLowerCase() ?? '';
                    return title.contains(searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      var exp = filteredExpenses[index].data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ListTile(
                          title: Text(
                            exp['title'] ?? 'No Title',
                            style: const TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            "Category: ${exp['category']}\n"
                                "Payment: ${exp['payment']}\n"
                                "Date: ${exp['date']}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Rs ${exp['amount']}",
                                style: const TextStyle(fontSize: 15),
                              ),

                              // 🗑 Delete button
                              IconButton(
                                onPressed: () {
                                  expenseController.deleteExpense(
                                    filteredExpenses[index].id,
                                  );
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),

                              // ✏️ Edit button
                              IconButton(
                                onPressed: () {
                                  _showEditDialog(
                                    filteredExpenses[index].id, // pass docId
                                    exp,                         // pass data
                                  );
                                }, //
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
      ),
    );
  }

  // ✏️ Edit dialog
  void _showEditDialog(String docId, Map<String, dynamic> data) {
    final titleController = TextEditingController(text: data['title']);
    final amountController =
    TextEditingController(text: data['amount'].toString());

    final List<String>categories =[
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

    final List<String>payment = [
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
    String selectedPayment = data['payment']??payment.first;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Expense"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
                TextField(controller: amountController, decoration: const InputDecoration(labelText: "Amount")),
                DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(labelText: "Category"),
                    items: categories.map((String category){
                      return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category));
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        selectedCategory = value!;
                      });
                    }),
                DropdownButtonFormField<String>(
                    value: selectedPayment,
                    decoration: InputDecoration(labelText: "Payment"),
                    items: payment.map((String payment){
                      return DropdownMenuItem<String>(
                          value: payment,
                          child: Text(payment));
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        selectedPayment=value!;
                      });
                    }),

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
