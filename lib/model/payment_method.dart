import 'package:flutter/material.dart';
import 'package:noya2/l10n/app_localizations.dart';

class PaymentMethod {
  
  static const int CASH_DEBIT = 1;
  static const int CREDIT = 2;

  int? _id;
  String? _label;

  PaymentMethod(this._id, this._label);

  int? get id {
    return this._id;
  }

  String? get label {
    return this._label;
  }

  bool operator ==(other) => other is PaymentMethod && other._id == this._id;
  int get hashCode => this._id.hashCode;

  static List<PaymentMethod> getAllPaymentMethods(BuildContext context) {
    return [
      PaymentMethod(CASH_DEBIT, AppLocalizations.of(context)!.payment_method_cash_debit),
      PaymentMethod(CREDIT, AppLocalizations.of(context)!.payment_method_credit)
    ];
  }

  static PaymentMethod? getInstance(int? type, BuildContext context) {
    if (CASH_DEBIT == type) {
      return PaymentMethod(CASH_DEBIT, AppLocalizations.of(context)!.payment_method_cash_debit);
    }
    else if (CREDIT == type) {
      return PaymentMethod(CREDIT, AppLocalizations.of(context)!.payment_method_credit);
    }

    return null;
  }
}