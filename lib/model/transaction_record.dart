import 'package:flutter/cupertino.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/model/credit_card.dart';
import 'package:noya2/services/date_service.dart';

class TransactionRecord {

  int? id;
  String? label;
  Category? category;
  CreditCard? creditCard;
  double? value;
  DateTime? date;
  DateTime? createDate;
  int? installments;
  TransactionRecord? _parent;

  TransactionRecord(this.id, this.label, this.category, this.creditCard, this.value, this.date, this.createDate, this.installments, this._parent);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'value': value,
      'date': DateService.formatToStorage(date!),
      'create_date': DateService.formatToStorage(DateTime.now()),
      'installments': installments,
      'category_id': category?.id,
      'credit_card_id': creditCard?.id,
      'parent_transaction_id': _parent?.id
    };
  }

  static TransactionRecord fromMap(Map<String, dynamic> map) {
    TransactionRecord? parent;

    if (map['parent_transaction_id'] != null) {
      parent = TransactionRecord(map['parent_transaction_id'], null, null, null, null, null, null, null, null);
    }

    return TransactionRecord(map['id'], map['label'], categoryFromMap(map), creditcardFromMap(map), map['value'], 
      DateService.parseFromStorage(map['date']), DateService.parseFromStorage(map['create_date']), map['installments'], parent);
  }

  static Category? categoryFromMap(Map<String, dynamic> map) {
    if (map['category_id'] != null) {
      return Category(map['category_id'], map['category_label'], IconData(map['category_icon'], fontFamily: 'MaterialIcons'), 
        map['category_type']);
    }
    else {
      return null;
    }
  }

  static CreditCard? creditcardFromMap(Map<String, dynamic> map) {
    if (map['credit_card_id'] != null) {
      return CreditCard(map['credit_card_id'], map['creditcard_label'], int.parse(map['close_day']), int.parse(map['due_day']));
    }
    else {
      return null;
    }
  }

  TransactionRecord? get parent {
    return _parent;
  }

  @override
  bool operator ==(other) => other is TransactionRecord && other.id == id;
  @override
  int get hashCode => id.hashCode;

  set parent (TransactionRecord parent) {
    _parent = parent;
  }

  @override
  String toString() => '''Transaction Record:
    \tid: $id
    \tlabel: $label
    \tvalue: $value
    \tdate: $date
    \tcreate_date: $createDate
    \tinstallments: $installments
    \t${category.toString()}
    \t${creditCard?.toString()}''';
}