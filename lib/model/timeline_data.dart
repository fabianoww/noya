import 'package:noya2/model/transaction_record.dart';

class TimelineData {
  late double _expense;
  late double _revenue;
  late double _goal;
  late double _percentageReference;
  late List<TransactionRecord> _transactions;

  TimelineData(double expense, double revenue, double goal, List<TransactionRecord> transactions) {
    _expense = expense;
    _revenue = revenue;
    _goal = goal;
    _transactions = transactions;
    _percentageReference = _expense;
    _percentageReference = _revenue > _percentageReference ? _revenue : _percentageReference;
    _percentageReference = _goal > _percentageReference ? _goal : _percentageReference;
  }

  double get expense {
    return _expense;
  }

  int get expensePercentage {
    if (_expense == 0) {
      return 0;
    }
    
    return (_expense) * 100 ~/ _percentageReference;
  }

  double get revenue {
    return _revenue;
  }

  int get revenuePercentage {
    if (_revenue == 0) {
      return 0;
    }
    
    return (_revenue) * 100 ~/ _percentageReference;
  }

  double get goal {
    return _goal;
  }

  int get goalPercentage {
    if (_goal == 0) {
      return 0;
    }

    return (_goal) * 100 ~/ _percentageReference;
  }

  List<TransactionRecord> get transactions {
    return _transactions;
  }
}