import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // ✅ Add this import

import '../../res/components/search_filter.dart';

class DailyRecord extends StatefulWidget {
  const DailyRecord({super.key});

  @override
  State<DailyRecord> createState() => _DailyRecordState();
}

class _DailyRecordState extends State<DailyRecord> {
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
        title: const Text("Daily Expenses"),
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

          /// 📌 Expense list grouped by days
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

                // All expenses
                final expenses = snapshot.data!.docs;

                // 🔍 Apply search filter
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

                // ✅ Group by Day
                Map<String, List<QueryDocumentSnapshot>> grouped = {};
                for (var doc in filteredExpenses) {
                  var exp = doc.data() as Map<String, dynamic>;
                  DateTime createdAt = (exp['createdAt'] as Timestamp).toDate();
                  String dayKey =
                      "${createdAt.year}-${createdAt.month}-${createdAt.day}";

                  if (!grouped.containsKey(dayKey)) {
                    grouped[dayKey] = [];
                  }
                  grouped[dayKey]!.add(doc);
                }

                // ✅ Sorted dates (latest first)
                final sortedKeys = grouped.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, index) {
                    String day = sortedKeys[index];
                    List<QueryDocumentSnapshot> dayExpenses = grouped[day]!;

                    // Convert string back to DateTime
                    List<String> parts = day.split("-");
                    DateTime dayDate = DateTime(
                      int.parse(parts[0]),
                      int.parse(parts[1]),
                      int.parse(parts[2]),
                    );

                    // ✅ Day Name (e.g. Monday)
                    String dayName = DateFormat('EEEE').format(dayDate);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 📅 Day Header with Day Name
                        Container(
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "$dayName, $day", // Example: Monday, 2025-09-08
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 📌 Expenses under this day
                        ...dayExpenses.map((doc) {
                          var exp = doc.data() as Map<String, dynamic>;
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 🔹 Category Icon Box
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.category, // you can map category to a specific icon
                                      color: Colors.blue.shade700,
                                      size: 26,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // 🔹 Expense Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exp['title'] ?? 'No Title',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
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

                                  // 🔹 Amount
                                  Text(
                                    "Rs ${exp['amount'] ?? 0}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: (exp['amount'] ?? 0) >= 0 ? Colors.green : Colors.red,
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
