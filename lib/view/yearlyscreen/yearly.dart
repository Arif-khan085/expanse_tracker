import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../res/components/search_filter.dart';


class YearlyRecord extends StatefulWidget {
  const YearlyRecord({super.key});

  @override
  State<YearlyRecord> createState() => _YearlyRecordState();
}

class _YearlyRecordState extends State<YearlyRecord> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController searchController = TextEditingController();

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    String uid = user!.uid;

    // 📌 Get start and end of current year
    DateTime today = DateTime.now();
    DateTime startOfYear = DateTime(today.year, 1, 1);
    DateTime endOfYear = DateTime(today.year, 12, 31, 23, 59, 59);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cardColor,
        title: const Text("Yearly Expenses"),
      ),

      body: Column(
        children: [
          /// 🔍 Search bar
          SearchFilter(
            controller: searchController,
            hintText: "Search expenses...",
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),

          /// 📌 Expense list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('expenses')
                  .where('createdAt',
                  isGreaterThanOrEqualTo: startOfYear,
                  isLessThanOrEqualTo: endOfYear)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No expenses this year"));
                }

                final expenses = snapshot.data!.docs;

                // 🔍 Filter by search query
                final filteredExpenses = expenses.where((doc) {
                  var exp = doc.data() as Map<String, dynamic>;
                  String title = (exp['title'] ?? '').toString().toLowerCase();
                  String category =
                  (exp['category'] ?? '').toString().toLowerCase();
                  String payment =
                  (exp['payment'] ?? '').toString().toLowerCase();

                  return title.contains(searchQuery) ||
                      category.contains(searchQuery) ||
                      payment.contains(searchQuery);
                }).toList();

                if (filteredExpenses.isEmpty) {
                  return const Center(child: Text("No matching expenses"));
                }

                return ListView.builder(
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    var exp =
                    filteredExpenses[index].data() as Map<String, dynamic>;

                    return Card(
                      child: ListTile(
                        title: Text(exp['title'] ?? 'No Title'),
                        subtitle: Text("Category: ${exp['category']}\n"
                            "Payment: ${exp['payment']}\n"
                            "Date: ${exp['date']}"),
                        trailing: Text("Rs ${exp['amount']}"),
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
