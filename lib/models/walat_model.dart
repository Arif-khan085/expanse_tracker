class Wallet {
  final double salary;
  final double balance;
  final double totalExpense;

  Wallet({
    required this.salary,
    required this.balance,
    required this.totalExpense,
  });

  // Firestore se data read karne ke liye
  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      salary: (map['salary'] ?? 0).toDouble(),
      balance: (map['balance'] ?? 0).toDouble(),
      totalExpense: (map['totalExpense'] ?? 0).toDouble(),
    );
  }

  // Firestore me data save/update karne ke liye
  Map<String, dynamic> toMap() {
    return {
      'salary': salary,
      'balance': balance,
      'totalExpense': totalExpense,
    };
  }
}
