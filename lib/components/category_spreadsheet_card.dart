import 'package:flutter/material.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:intl/intl.dart';
import 'package:noya2/styles/custom_color_scheme.dart';
import 'package:noya2/model/category.dart';

class CategorySpreadsheetCard extends StatelessWidget {
  Category _category;
  double _value;
  Function(Category) _callback;

  CategorySpreadsheetCard(this._category, this._value, this._callback);

  @override
  Widget build(BuildContext context) {
    Color color = Category.REVENUE == this._category.type
        ? Theme.of(context).colorScheme.revenueColor
        : Theme.of(context).colorScheme.expensecolor;
    IconData icon = this._category.icon!;
    String label = this._category.label!;

    return GestureDetector(
        onTap: () => this._callback(this._category),
        child: Row(children: [
          Expanded(
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(children: [
                        Icon(icon, color: color),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  label,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ))),
                        Text(
                          NumberFormat.currency(symbol: "").format(this._value),
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.chevron_right,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color))
                      ]))))
        ]));
  }
}
