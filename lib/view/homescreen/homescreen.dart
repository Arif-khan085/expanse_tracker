import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:expense_tracker/res/components/buttomnavigatorbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../res/components/search_filter.dart';
import '../../view_models/services/firebase_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final ExpenseController expenseController = Get.put(ExpenseController());

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
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
        title: Text('Home'),
      ),
      body: Column(
        children: [
          SearchFilter(
            controller: searchController,
            hintText: 'Search Title',
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('expenses')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('No Expense Found');
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
                    var exp =
                        filteredExpenses[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: ListTile(
                        title: Text(exp['title'] ?? 'No Title',style: TextStyle(fontSize: 20),),
                        subtitle: Text(
                          "Category : ${exp['category']}\nPayment : ${exp['payment']} \nDate : ${exp['date']}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Rs ${exp['amount']}",style:TextStyle(fontSize: 15),),
                            IconButton(
                              onPressed: () {
                                expenseController.deleteExpense(
                                  filteredExpenses[index].id,
                                );
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
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
}
