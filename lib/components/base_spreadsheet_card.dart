import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/styles/custom_color_scheme.dart';

class BaseSpreadsheetCard extends StatelessWidget {
  late int _type;
  late double _value;

  BaseSpreadsheetCard(int type, double value) {
    this._type = type;
    this._value = value;
  }

  @override
  Widget build(BuildContext context) {
    Color color = Category.REVENUE == this._type
        ? Theme.of(context).colorScheme.revenueColor
        : Theme.of(context).colorScheme.expensecolor;
    IconData icon = Category.REVENUE == this._type
        ? Icons.trending_up
        : Icons.trending_down;
    String label = Category.REVENUE == this._type
        ? AppLocalizations.of(context)!.label_revenues
        : AppLocalizations.of(context)!.label_expenses;
    return Row(children: [
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
                                  fontSize: 17, fontWeight: FontWeight.bold),
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
                            color: Theme.of(context).textTheme.bodyMedium?.color))
                  ]))))
    ]);
  }
}
