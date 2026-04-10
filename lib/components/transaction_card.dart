import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noya2/activities/transaction_form.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:noya2/notifiers/refresh_controller.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:noya2/styles/custom_color_scheme.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatelessWidget {
  TransactionRecord _transaction;

  TransactionCard(this._transaction);

  @override
  Widget build(BuildContext context) {
    Color color = Category.REVENUE == this._transaction.category!.type
        ? Theme.of(context).colorScheme.revenueColor
        : Theme.of(context).colorScheme.expensecolor;
    return GestureDetector(
        onTap: () {
          TransactionService.findById(this._transaction.id!).then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return TransactionForm.edit(value!);
              }),
            ).then((value) => Provider.of<RefreshController>(context, listen: false).notifyListeners());
          });
        },
        child: Row(children: [
          Expanded(
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(children: [
                        Icon(this._transaction.category!.icon),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        this._transaction.category!.label!,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(this._transaction.label!)
                                    ]))),
                        Text(
                          NumberFormat.currency(symbol: "")
                              .format(this._transaction.value),
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )
                      ]))))
        ]));
  }
}
