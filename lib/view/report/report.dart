import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/res/components/buttomnavigatorbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../res/colors/app_colors.dart';
import '../../res/components/piechart.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  Map<String, double> categoryTotals = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .get();

      Map<String, double> totals = {};
      for (var doc in snapshot.docs) {
        String category = doc['category'];
        double amount = (doc['amount'] as num).toDouble();

        if (totals.containsKey(category)) {
          totals[category] = totals[category]! + amount;
        } else {
          totals[category] = amount;
        }
      }
      setState(() {
        categoryTotals = totals;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetching expenses: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cardColor,
        title: Text('Report'),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: 2,
        onItemSelect: (int value) {},
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryTotals.isEmpty
          ? const Center(child: Text("No expenses added yet"))
          : Column(
              children: [
                SizedBox(
                  height: 300,
                  child: CustomPieChart(
                    data: categoryTotals.entries.map((entry) {
                      double totalAmount = categoryTotals.values.fold(0, (a, b) => a + b);
                      double percentage = (entry.value / totalAmount) * 100;
                      return PieData(
                        value: percentage,
                        color: _getCategoryColor(entry.key),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: categoryTotals.entries.map((entry) {
                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getCategoryColor(entry.key),
                            ),
                            title: Text(entry.key),
                            trailing: Text(
                              "Rs :  ${entry.value.toStringAsFixed(2)}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(),
                        ],
                      );

                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  /// 🔹 Dummy color function (replace with your logic)
  Color _getCategoryColor(String category) {
    switch (category) {
      case "Food":
        return AppColors.cardColor;
      case "Transport":
        return AppColors.switchColor;
      case "Shopping":
        return Colors.purple;
      case "bills":
        return AppColors.blueColor;
      case "Entertainment":
        return AppColors.greyColor2;
      case "Health":
        return AppColors.greenColor;
      case "Education":
        return AppColors.redColor;
      case "Savings":
        return AppColors.yellowColor;
      case "Travel":
        return AppColors.orangeColor;
      case "Groceries":
        return AppColors.purpleColor;
      case "Rent":
        return AppColors.tealColor;
      case "Salary":
        return AppColors.limeGreen;
      case "Utilities":
        return AppColors.brown;
      case "Investment":
        return AppColors.greyBlue;
      default:
        return Colors.grey;
    }
  }
}
