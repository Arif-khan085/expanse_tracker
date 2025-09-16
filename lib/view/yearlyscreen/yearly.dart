import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

          /// 📌 Expense list grouped by years
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

                /// ✅ Group by Year
                Map<String, List<QueryDocumentSnapshot>> grouped = {};
                for (var doc in filteredExpenses) {
                  var exp = doc.data() as Map<String, dynamic>;
                  DateTime createdAt =
                  (exp['createdAt'] as Timestamp).toDate();

                  String yearKey = DateFormat("yyyy").format(createdAt);

                  if (!grouped.containsKey(yearKey)) {
                    grouped[yearKey] = [];
                  }
                  grouped[yearKey]!.add(doc);
                }

                // ✅ Sorted years (latest first)
                final sortedKeys = grouped.keys.toList()
                  ..sort((a, b) => int.parse(b).compareTo(int.parse(a)));

                return ListView.builder(
                  itemCount: sortedKeys.length,
                  itemBuilder: (context, index) {
                    String year = sortedKeys[index];
                    List<QueryDocumentSnapshot> yearExpenses = grouped[year]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 📅 Year Header
                        Container(
                          width: double.infinity,
                          color: Colors.orange.shade100,
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            year, // e.g. "2025"
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 📌 Expenses under this year
                        ...yearExpenses.map((doc) {
                          var exp = doc.data() as Map<String, dynamic>;
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

                              // 🔹 Leading Icon Box (Category Icon)
                              leading: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.receipt_long, // later map to category
                                  color: Colors.blue.shade700,
                                  size: 24,
                                ),
                              ),

                              // 🔹 Title (Expense Title)
                              title: Text(
                                exp['title'] ?? 'No Title',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // 🔹 Subtitle (Category + Payment neatly aligned)
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Category: ${exp['category'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    "Payment: ${exp['payment'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),

                              // 🔹 Trailing (Amount with pill effect)
                              trailing: Container(
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
