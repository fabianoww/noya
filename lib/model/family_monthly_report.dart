class FamilyMonthlyMemberReport {
  final String memberUuid;
  final String memberName;
  final double expenses;
  final double revenues;
  final double balanceAgainstAverage;

  FamilyMonthlyMemberReport({
    required this.memberUuid,
    required this.memberName,
    required this.expenses,
    required this.revenues,
    required this.balanceAgainstAverage,
  });
}

class FamilyMonthlyReport {
  final int year;
  final int month;
  final double totalExpenses;
  final double totalRevenues;
  final int memberCount;
  final double averageExpense;
  final List<FamilyMonthlyMemberReport> members;

  FamilyMonthlyReport({
    required this.year,
    required this.month,
    required this.totalExpenses,
    required this.totalRevenues,
    required this.memberCount,
    required this.averageExpense,
    required this.members,
  });

  double get result => totalRevenues - totalExpenses;
}
