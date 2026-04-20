import 'package:flutter/material.dart';

class Category {

  static const int revenue = 1;
  static const int expense = 2;

  int? _id;
  String? _label;
  IconData? _icon;
  int? _type;

  Category(this._id, this._label, this._icon, this._type);

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'label': _label,
      'icon': _icon!.codePoint,
      'type': _type
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(map['id'], map['label'], IconData(map['icon'], fontFamily: 'MaterialIcons'), map['type']);
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

  IconData? get icon {
    return _icon;
  }

  set icon (IconData icon) {
    _icon = icon;
  }

  int? get type {
    return _type;
  }

  set type (int type) {
    _type = type;
  }

  @override
  bool operator ==(other) => other is Category && other._id == _id;
  @override
  int get hashCode => _id.hashCode;

  @override
  String toString() => 'Category:\n\tid: $_id\n\tlabel: $_label\n\ttype: $_type';
}