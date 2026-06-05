import 'package:flutter/material.dart';
import 'package:noya2/l10n/app_localizations.dart';

class PaymentMethod {
  
  static const int cashDebit = 1;
  static const int credit = 2;

  final int? _id;
  final String? _label;

  PaymentMethod(this._id, this._label);

  int? get id {
    return _id;
  }

  String? get label {
    return _label;
  }

  @override
  bool operator ==(other) => other is PaymentMethod && other._id == _id;
  @override
  int get hashCode => _id.hashCode;

  static List<PaymentMethod> getAllPaymentMethods(BuildContext context) {
    return [
      PaymentMethod(cashDebit, AppLocalizations.of(context)!.payment_method_cash_debit),
      PaymentMethod(credit, AppLocalizations.of(context)!.payment_method_credit)
    ];
  }

  static PaymentMethod? getInstance(int? type, BuildContext context) {
    if (cashDebit == type) {
      return PaymentMethod(cashDebit, AppLocalizations.of(context)!.payment_method_cash_debit);
    }
    else if (credit == type) {
      return PaymentMethod(credit, AppLocalizations.of(context)!.payment_method_credit);
    }

    return null;
  }
}