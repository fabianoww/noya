import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noya2/activities/transaction_form.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:noya2/styles/custom_color_scheme.dart';

class TransactionSpreadsheetCard extends StatelessWidget {
  TransactionRecord _transaction;

  TransactionSpreadsheetCard(this._transaction);

  @override
  Widget build(BuildContext context) {
    Color color = Category.REVENUE == _transaction.category!.type
        ? Theme.of(context).colorScheme.revenueColor
        : Theme.of(context).colorScheme.expensecolor;
    String label = _transaction.label!;

    NumberFormat numberFormatter = NumberFormat.currency(locale: AppLocalizations.of(context)!.localeName, symbol: "", decimalDigits: 2);

    return GestureDetector(
        onTap: () {
          int? id = _transaction.parent == null ? _transaction.id : _transaction.parent!.id;
          TransactionService.findById(id!).then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return TransactionForm.edit(value!);
              }),
            );
          });
        },
        child: Row(children: [
          Expanded(
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  label,
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                ))),
                        Text(
                          numberFormatter.format(_transaction.value),
                          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ]))))
        ]));
  }
}
