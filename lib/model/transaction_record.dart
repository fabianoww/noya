import 'package:flutter/cupertino.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/model/credit_card.dart';
import 'package:noya2/services/date_service.dart';

class TransactionRecord {

  int? _id;
  String? _label;
  Category? _category;
  CreditCard? _creditCard;
  double? _value;
  DateTime? _date;
  DateTime? _createDate;
  int? _installments;
  TransactionRecord? _parent;

  TransactionRecord(this._id, this._label, this._category, this._creditCard, this._value, this._date, this._createDate, this._installments, this._parent);

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'label': this._label,
      'value': this._value,
      'date': DateService.formatToStorage(_date!),
      'create_date': DateService.formatToStorage(DateTime.now()),
      'installments': this._installments,
      'category_id': this._category?.id,
      'credit_card_id': this._creditCard?.id,
      'parent_transaction_id': this._parent?.id
    };
  }

  static TransactionRecord fromMap(Map<String, dynamic> map) {
    TransactionRecord? parent = null;

    if (map['parent_transaction_id'] != null) {
      parent = TransactionRecord(map['parent_transaction_id'], null, null, null, null, null, null, null, null);
    }

    return new TransactionRecord(map['id'], map['label'], categoryFromMap(map), creditcardFromMap(map), map['value'], 
      DateService.parseFromStorage(map['date']), DateService.parseFromStorage(map['create_date']), map['installments'], parent);
  }

  static Category? categoryFromMap(Map<String, dynamic> map) {
    if (map['category_id'] != null) {
      return new Category(map['category_id'], map['category_label'], IconData(map['category_icon'], fontFamily: 'MaterialIcons'), 
        map['category_type']);
    }
    else {
      return null;
    }
  }

  static CreditCard? creditcardFromMap(Map<String, dynamic> map) {
    if (map['credit_card_id'] != null) {
      return new CreditCard(map['credit_card_id'], map['creditcard_label'], int.parse(map['close_day']), int.parse(map['due_day']));
    }
    else {
      return null;
    }
  }

  int? get id {
    return this._id;
  }

  set id (int? id) {
    this._id = id;
  }

  String? get label {
    return _label;
  }

  set label (String? label) {
    this._label = label;
  }

  Category? get category {
    return _category;
  }

  set category (Category? category) {
    this._category = category;
  }

  CreditCard? get creditCard {
    return _creditCard;
  }

  set creditCard (CreditCard? creditCard) {
    this._creditCard = creditCard;
  }

  double? get value {
    return _value;
  }

  set value (double? value) {
    this._value = value;
  }

  DateTime? get date {
    return this._date;
  }

  set date (DateTime? date) {
    this._date = date;
  }

  DateTime? get createDate {
    return this._createDate;
  }

  set createDate (DateTime? createDate) {
    this._createDate = createDate;
  }

  int? get installments {
    return this._installments;
  }

  set installments (int? installments) {
    this._installments = installments;
  }

  TransactionRecord? get parent {
    return this._parent;
  }

  bool operator ==(other) => other is TransactionRecord && other._id == this._id;
  int get hashCode => this._id.hashCode;

  set parent (TransactionRecord parent) {
    this._parent = parent;
  }

  @override
  String toString() => '''Transaction Record:
    \tid: ${this._id}
    \tlabel: ${this._label}
    \tvalue: ${this._value}
    \tdate: ${this._date}
    \tcreate_date: ${this._createDate}
    \tinstallments: ${this._installments}
    \t${this._category.toString()}
    \t${this._creditCard?.toString()}'''; // FIXME falta creditcard e parent
}