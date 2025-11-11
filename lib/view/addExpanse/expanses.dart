import 'package:expense_tracker/res/components/textfield_button.dart';
import 'package:expense_tracker/view_models/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors/app_colors.dart';
import '../../res/components/buttomnavigatorbar.dart';
import '../homescreen/homescreen.dart';

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

  String selectedCategory = 'Food';
  String selectedPayment = 'Cash';

  final List<String> categories = [
    'Food','Transport','Shopping','Bills','Entertainment','Health','Education',
    'Savings','Travel','Groceries','Rent','Salary','Utilities','Investments','Others'
  ];

  final List<String> payments = [
    'Cash','Credit Card','Debit Card','Bank Transfer','MobileWallet','PayPal',
    'GooglePay','ApplePay','EasyPaisa','JazzCash','Cheque','UPI','Cryptocurrency',
    'Gift Card','Others'
  ];

  @override
  void initState() {
    super.initState();
    // Default date is today
    DateTime now = DateTime.now();
    dateController.text =
    '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.cardColor,
        title: Text('Add Expense'),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectIndex: 1,
        onItemSelect: (int value) {},
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                controller: dateController,
                labelText: 'yy-mm-dd',
                hintText: 'Enter Date',
                prefixIcon: Icons.date_range,
                keyboardType: TextInputType.datetime,

                suffixIcon: IconButton(
                  icon: Icon(Icons.date_range_outlined),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dateController.text =
                        '${pickedDate.year}-${pickedDate.month.toString().padLeft(2,'0')}-${pickedDate.day.toString().padLeft(2,'0')}';
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 20),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.category),
                  labelText: 'Category',
                  border: InputBorder.none,
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCategory = val!;
                  });
                },
              ),
              Divider(),

              // Payment Dropdown
              DropdownButtonFormField<String>(
                value: selectedPayment,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.payment),
                  labelText: 'Payment',
                  border: InputBorder.none,
                ),
                items: payments.map((pay) {
                  return DropdownMenuItem<String>(
                    value: pay,
                    child: Text(pay),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedPayment = val!;
                  });
                },
              ),
              Divider(),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      amountController.text.isEmpty ||
                      dateController.text.isEmpty) {
                    Get.snackbar('Error', 'All fields are required');
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });

                  try {
                    await addExpense(
                      title: titleController.text,
                      amount: double.parse(amountController.text),
                      date: dateController.text,
                      category: selectedCategory,
                      payment: selectedPayment,
                    );

                    setState(() {
                      isLoading = false;
                    });

                    Get.snackbar('Success', 'Transaction added successfully');

                    // Navigate to Home Screen
                    Get.offAll(() => HomeScreen());

                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    Get.snackbar('Error', 'Something went wrong');
                  }
                },
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Add Transaction'),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
