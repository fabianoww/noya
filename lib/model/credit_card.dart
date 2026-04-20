class CreditCard {

  int? _id;
  String? _label;
  int? _closeDay;
  int? _dueDay;

  CreditCard(this._id, this._label, this._closeDay, this._dueDay);

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'label': _label,
      'close_day': _closeDay,
      'due_day': _dueDay
    };
  }

  static CreditCard fromMap(Map<String, dynamic> map) {
    return CreditCard(map['id'], map['label'], int.parse(map['close_day']), int.parse(map['due_day']));
  }

  DateTime getBillingDate(DateTime date) {
    DateTime billingDate = date;
    bool closeDateFound = false;
    bool dueDateFound = false;

    do {
      billingDate = billingDate.add(Duration(days: 1));

      if (billingDate.day == _closeDay) {
        closeDateFound = true;
      }

      if (closeDateFound && billingDate.day == _dueDay) {
        dueDateFound = true;
      }
    } while (!dueDateFound);

    return billingDate;
  }

  int? get id {
    return _id;
  }

  set id (int id) {
    _id = id;
  }

  String? get label {
    return _label;
  }

  set label (String label) {
    _label = label;
  }

  int? get closeDay {
    return _closeDay;
  }

  set closeDay (int closeDay) {
    _closeDay = closeDay;
  }

  int? get dueDay {
    return _dueDay;
  }

  set dueDay (int dueDay) {
    _dueDay = dueDay;
  }

  @override
  bool operator ==(other) => other is CreditCard && other._id == _id;
  @override
  int get hashCode => _id.hashCode;

  @override
  String toString() => 'Credit Card:\n\tid: $_id\n\tlabel: $_label\n\tclose day: $_closeDay\n\tdue day: $_closeDay';

}