import 'package:get/get.dart';

import '../../../view/addExpanse/expanses.dart';


class ExpenseController extends GetxController {
  var expenses = <Expense>[].obs;

  List<Expense> getDailyExpenses() {
    DateTime now = DateTime.now();
    return expenses.where((e) =>
    e.dateTime.day == now.day &&
        e.dateTime.month == now.month &&
        e.dateTime.year == now.year
    ).toList();
  }

  List<Expense> getWeeklyExpenses() {
    DateTime now = DateTime.now();
    return expenses.where((e) =>
        e.dateTime.isAfter(now.subtract(Duration(days: 7)))
    ).toList();
  }

  List<Expense> getMonthlyExpenses() {
    DateTime now = DateTime.now();
    return expenses.where((e) =>
    e.dateTime.month == now.month &&
        e.dateTime.year == now.year
    ).toList();
  }

  List<Expense> getYearlyExpenses() {
    DateTime now = DateTime.now();
    return expenses.where((e) =>
    e.dateTime.year == now.year
    ).toList();
  }
}
