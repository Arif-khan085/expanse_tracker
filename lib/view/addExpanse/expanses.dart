import 'package:expense_tracker/res/components/textfield_button.dart';
import 'package:expense_tracker/view_models/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../res/colors/app_colors.dart';
import '../../res/components/buttomnavigatorbar.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  bool isLoading = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  String? selectedCategory;
  String? selectedPayment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.cardColor, title: Text('Add')),
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: 1,
        onItemSelect: (int value) {},
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(),
            SizedBox(height: 20),
            RoundTextField(
              controller: titleController,
              labelText: 'Title',
              hintText: 'Enter Title',
              prefixIcon: Icons.title,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            RoundTextField(
              controller: amountController,
              labelText: 'Amount',
              hintText: 'Enter Amount',
              prefixIcon: Icons.payment,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            RoundTextField(
              suffixIcon: IconButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                    setState(() {
                      dateController.text = formattedDate;
                    });
                  }
                },
                icon: Icon(Icons.date_range_outlined),
              ),
              controller: dateController,
              labelText: 'Date',
              hintText: 'Enter Date',
              prefixIcon: Icons.date_range,
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            RoundTextField(
              suffixIcon: DropdownButton<String>(
                value: 'Food', // default selected value (optional)
                items:
                    [
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
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(), // <- important
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                    categoryController.text = newValue!;
                  });
                },
              ),
              controller: categoryController,
              labelText: 'Category',
              hintText: 'Select category',
              prefixIcon: Icons.category,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            RoundTextField(
              suffixIcon: DropdownButton<String>(
                value: 'Cash', // default selected value (optional)
                items:
                    [
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
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(), // <- important
                onChanged: (newValue) {
                  setState(() {
                    selectedPayment = newValue;
                    paymentController.text = newValue!;
                  });
                },
              ),
              controller: paymentController,
              labelText: 'payment',
              hintText: 'Select payment',
              prefixIcon: Icons.payment,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    amountController.text.isEmpty ||
                    dateController.text.isEmpty ||
                    categoryController.text.isEmpty ||
                    paymentController.text.isEmpty) {
                  Get.snackbar('Error', 'All field are required');
                  return;
                }
                setState(() {
                  isLoading = true;
                });
                addExpense(
                  title: titleController.text,
                  amount: double.parse(amountController.text),
                  date: dateController.text,
                  category: categoryController.text,
                  payment: paymentController.text,
                );
              },
              child: Text('Add Transection'),
            ),
          ],
        ),
      ),
    );
  }
}
