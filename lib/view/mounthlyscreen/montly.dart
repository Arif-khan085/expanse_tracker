import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../res/components/search_filter.dart';

class MonthlyRecord extends StatefulWidget {
  const MonthlyRecord({super.key});

  @override
  State<MonthlyRecord> createState() => _MonthlyRecordState();
}

class _MonthlyRecordState extends State<MonthlyRecord> {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cardColor,
        title: const Text("Monthly Expenses"),
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

          /// 📌 Expense list grouped by months
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
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No expenses found"));
                }

                final expenses = snapshot.data!.docs;

                /// 🔍 Apply search filter
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

                /// ✅ Group by Month
                Map<String, List<QueryDocumentSnapshot>> grouped = {};
                for (var doc in filteredExpenses) {
                  var exp = doc.data() as Map<String, dynamic>;
                  DateTime createdAt =
                  (exp['createdAt'] as Timestamp).toDate();

                  String monthKey =
                  DateFormat("MMMM yyyy").format(createdAt);

                  if (!grouped.containsKey(monthKey)) {
                    grouped[monthKey] = [];
                  }
                  grouped[monthKey]!.add(doc);
                }

                // ✅ Sorted months (latest first)
                final sortedKeys = grouped.keys.toList()
                  ..sort((a, b) => DateFormat("MMMM yyyy")
                      .parse(b)
                      .compareTo(DateFormat("MMMM yyyy").parse(a)));

                return ListView.builder(
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, index) {
                    String month = sortedKeys[index];
                    List<QueryDocumentSnapshot> monthExpenses =
                    grouped[month]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 📅 Month Header
                        Container(
                          width: double.infinity,
                          color: Colors.green.shade100,
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            month, // e.g. "September 2025"
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 📌 Expenses under this month
                        ...monthExpenses.map((doc) {
                          var exp = doc.data() as Map<String, dynamic>;
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: ListTile(
                              title: Text(exp['title'] ?? 'No Title'),
                              subtitle: Text(
                                "Category: ${exp['category'] ?? 'N/A'}\n"
                                    "Payment: ${exp['payment'] ?? 'N/A'}",
                              ),
                              trailing: Text("Rs ${exp['amount'] ?? 0}"),
                            ),
                          );
                        }).toList(),
                      ],
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
