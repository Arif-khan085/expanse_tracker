import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../res/components/search_filter.dart';

class WeeklyRecord extends StatefulWidget {
  const WeeklyRecord({super.key});

  @override
  State<WeeklyRecord> createState() => _WeeklyRecordState();
}

class _WeeklyRecordState extends State<WeeklyRecord> {
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
        title: const Text("Weekly Expenses"),
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

          /// 📌 Expense list grouped by weeks
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

                /// ✅ Group by Week
                Map<String, List<QueryDocumentSnapshot>> grouped = {};
                for (var doc in filteredExpenses) {
                  var exp = doc.data() as Map<String, dynamic>;
                  DateTime createdAt =
                  (exp['createdAt'] as Timestamp).toDate();

                  // Week start (Monday) and end (Sunday)
                  DateTime weekStart = createdAt
                      .subtract(Duration(days: createdAt.weekday - 1));
                  weekStart = DateTime(
                      weekStart.year, weekStart.month, weekStart.day);

                  DateTime weekEnd = weekStart.add(const Duration(days: 6));

                  String weekKey =
                      "${DateFormat('dd MMM').format(weekStart)} - ${DateFormat('dd MMM yyyy').format(weekEnd)}";

                  if (!grouped.containsKey(weekKey)) {
                    grouped[weekKey] = [];
                  }
                  grouped[weekKey]!.add(doc);
                }

                // ✅ Sorted weeks (latest first)
                final sortedKeys = grouped.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, index) {
                    String week = sortedKeys[index];
                    List<QueryDocumentSnapshot> weekExpenses = grouped[week]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 📅 Week Header
                        Container(
                          width: double.infinity,
                          color: Colors.blue.shade100,
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Week: $week",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 📌 Expenses under this week
                        ...weekExpenses.map((doc) {
                          var exp = doc.data() as Map<String, dynamic>;
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black26,
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  // 🔹 Left Icon (based on category)
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.receipt_long, // later map this dynamically
                                      color: Colors.teal.shade700,
                                      size: 26,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // 🔹 Expense Details (Title, Category, Payment)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exp['title'] ?? 'No Title',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Category: ${exp['category'] ?? 'N/A'} • "
                                              "Payment: ${exp['payment'] ?? 'N/A'}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 🔹 Right side (Amount)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: (exp['amount'] ?? 0) >= 0
                                          ? Colors.green.shade50
                                          : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Rs ${exp['amount'] ?? 0}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: (exp['amount'] ?? 0) >= 0 ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
