import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/styles/custom_color_scheme.dart';

class BaseSpreadsheetCard extends StatelessWidget {
  final int _type;
  final double _value;

  const BaseSpreadsheetCard(this._type, this._value, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Category.revenue == _type
        ? Theme.of(context).colorScheme.revenueColor
        : Theme.of(context).colorScheme.expensecolor;
    IconData icon = Category.revenue == _type
        ? Icons.trending_up
        : Icons.trending_down;
    String label = Category.revenue == _type
        ? AppLocalizations.of(context)!.label_revenues
        : AppLocalizations.of(context)!.label_expenses;

    NumberFormat numberFormatter = NumberFormat.currency(locale: AppLocalizations.of(context)!.localeName, symbol: "", decimalDigits: 2);

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
                      numberFormatter.format(_value),
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
