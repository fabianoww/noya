import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noya2/activities/transaction_form.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:noya2/styles/custom_color_scheme.dart';

class TransactionSpreadsheetCard extends StatelessWidget {
  TransactionRecord _transaction;

  TransactionSpreadsheetCard(this._transaction);

  @override
  Widget build(BuildContext context) {
    Color color = Category.REVENUE == this._transaction.category!.type
        ? Theme.of(context).colorScheme.revenueColor
        : Theme.of(context).colorScheme.expensecolor;
    String label = this._transaction.label!;

    return GestureDetector(
        onTap: () {
          int? id = this._transaction.parent == null ? this._transaction.id : this._transaction.parent!.id;
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
                          NumberFormat.currency(symbol: "").format(this._transaction.value),
                          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ]))))
        ]));
  }
}
