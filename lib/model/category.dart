import 'package:flutter/material.dart';

class Category {

  static const int REVENUE = 1;
  static const int EXPENSE = 2;

  int? _id;
  String? _label;
  IconData? _icon;
  int? _type;

  Category(this._id, this._label, this._icon, this._type);

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'label': this._label,
      'icon': this._icon!.codePoint,
      'type': _type
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return new Category(map['id'], map['label'], IconData(map['icon'], fontFamily: 'MaterialIcons'), map['type']);
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

  IconData? get icon {
    return _icon;
  }

  set icon (IconData icon) {
    this._icon = icon;
  }

  int? get type {
    return _type;
  }

  set type (int type) {
    this._type = type;
  }

  bool operator ==(other) => other is Category && other._id == this._id;
  int get hashCode => this._id.hashCode;

  @override
  String toString() => 'Category:\n\tid: ${this._id}\n\tlabel: ${this._label}\n\ttype: ${this._type}';
}