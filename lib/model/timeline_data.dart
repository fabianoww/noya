import 'package:noya2/model/transaction_record.dart';

class TimelineData {
  late double _expense;
  late double _revenue;
  late double _goal;
  late double _percentageReference;
  late List<TransactionRecord> _transactions;

  TimelineData(double expense, double revenue, double goal, List<TransactionRecord> transactions) {
    this._expense = expense;
    this._revenue = revenue;
    this._goal = goal;
    this._transactions = transactions;
    this._percentageReference = this._expense;
    this._percentageReference = this._revenue > this._percentageReference ? this._revenue : this._percentageReference;
    this._percentageReference = this._goal > this._percentageReference ? this._goal : this._percentageReference;
  }

  double get expense {
    return _expense;
  }

  int get expensePercentage {
    if (this._expense == 0) {
      return 0;
    }
    
    return (this._expense) * 100 ~/ this._percentageReference;
  }

  double get revenue {
    return _revenue;
  }

  int get revenuePercentage {
    if (this._revenue == 0) {
      return 0;
    }
    
    return (this._revenue) * 100 ~/ this._percentageReference;
  }

  double get goal {
    return _goal;
  }

  int get goalPercentage {
    if (this._goal == 0) {
      return 0;
    }

    return (this._goal) * 100 ~/ this._percentageReference;
  }

  List<TransactionRecord> get transactions {
    return _transactions;
  }
}