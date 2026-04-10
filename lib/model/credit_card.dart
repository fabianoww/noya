class CreditCard {

  int? _id;
  String? _label;
  int? _closeDay;
  int? _dueDay;

  CreditCard(this._id, this._label, this._closeDay, this._dueDay);

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'label': this._label,
      'close_day': this._closeDay,
      'due_day': this._dueDay
    };
  }

  static CreditCard fromMap(Map<String, dynamic> map) {
    return new CreditCard(map['id'], map['label'], int.parse(map['close_day']), int.parse(map['due_day']));
  }

  DateTime getBillingDate(DateTime date) {
    // If the date is past the credit card close date, define the billing date to next month
    int increment = date.day > _closeDay! ? 1 : 0; 
    return DateTime(date.year, date.month + increment, _dueDay!);
  }

  int? get id {
    return _id;
  }

  set id (int id) {
    this._id = id;
  }

  String? get label {
    return _label;
  }

  set label (String label) {
    this._label = label;
  }

  int? get closeDay {
    return _closeDay;
  }

  set closeDay (int closeDay) {
    this._closeDay = closeDay;
  }

  int? get dueDay {
    return _dueDay;
  }

  set dueDay (int dueDay) {
    this._dueDay = dueDay;
  }

  bool operator ==(other) => other is CreditCard && other._id == this._id;
  int get hashCode => this._id.hashCode;

  @override
  String toString() => 'Credit Card:\n\tid: ${this._id}\n\tlabel: ${this._label}\n\tclose day: ${this._closeDay}\n\tdue day: ${this._closeDay}';

}