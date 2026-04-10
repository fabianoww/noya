import 'package:flutter/material.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/styles/custom_color_scheme.dart';
import 'package:intl/intl.dart';

class TimelineBar extends StatelessWidget {
  static const int REVENUE = 1;
  static const int EXPENSE = 2;
  static const int GOAL = 3;

  late int _percentage;
  late double _value;
  late int _type;

  TimelineBar(int percentage, double value, int type) {
    this._percentage = percentage;
    this._value = value;
    this._type = type;
  }

  @override
  Widget build(BuildContext context) {
    Color _color = Colors.transparent;
    String _label = '';
    NumberFormat numberFormatter = NumberFormat.currency(locale: AppLocalizations.of(context)!.localeName, symbol: "", decimalDigits: 2);
    String _formattedValue = numberFormatter.format(_value);
    switch (_type) {
      case REVENUE:
        _color = Theme.of(context).colorScheme.revenueColor;
        _label = AppLocalizations.of(context)!.timeline_bar_chart_revenue(_formattedValue);
        break;

      case EXPENSE:
        _color = Theme.of(context).colorScheme.expensecolor;
        _label = AppLocalizations.of(context)!.timeline_bar_chart_spent(_formattedValue);
        break;

      case GOAL:
        _color = Theme.of(context).colorScheme.goalColor;
        _label = AppLocalizations.of(context)!.timeline_bar_chart_goal(_formattedValue);
        break;
    }

    return Row(
      children: [
        Expanded(
            flex: this._percentage,
            child: Container(
                color: _color,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.only(right: _percentage > 50 ? 10 : 0),
                        child: Text(_percentage > 50 ? _label : '', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),))))),
        Expanded(
            flex: 100 - _percentage,
            child: Container(
                child: Padding(
                    padding: EdgeInsets.only(left: _percentage > 50 ? 0 : 10),
                    child: Text(_percentage > 50 ? '' : _label, style: TextStyle(color:  _color, fontWeight: FontWeight.bold)))))
      ],
    );
  }
}
