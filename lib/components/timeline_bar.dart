import 'package:flutter/material.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/styles/custom_color_scheme.dart';
import 'package:intl/intl.dart';

class TimelineBar extends StatelessWidget {
  static const int revenue = 1;
  static const int expense = 2;
  static const int goal = 3;

  final int _percentage;
  final double _value;
  final int _type;

  const TimelineBar(this._percentage, this._value, this._type, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.transparent;
    String label = '';
    NumberFormat numberFormatter = NumberFormat.currency(locale: AppLocalizations.of(context)!.localeName, symbol: "", decimalDigits: 2);
    String formattedValue = numberFormatter.format(_value);
    switch (_type) {
      case revenue:
        color = Theme.of(context).colorScheme.revenueColor;
        label = AppLocalizations.of(context)!.timeline_bar_chart_revenue(formattedValue);
        break;

      case expense:
        color = Theme.of(context).colorScheme.expensecolor;
        label = AppLocalizations.of(context)!.timeline_bar_chart_spent(formattedValue);
        break;

      case goal:
        color = Theme.of(context).colorScheme.goalColor;
        label = AppLocalizations.of(context)!.timeline_bar_chart_goal(formattedValue);
        break;
    }

    return Row(
      children: [
        Expanded(
            flex: _percentage,
            child: Container(
                color: color,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.only(right: _percentage > 50 ? 10 : 0),
                        child: Text(_percentage > 50 ? label : '', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),))))),
        Expanded(
            flex: 100 - _percentage,
            child: Padding(
                padding: EdgeInsets.only(left: _percentage > 50 ? 0 : 10),
                child: Text(_percentage > 50 ? '' : label, style: TextStyle(color:  color, fontWeight: FontWeight.bold))))
      ],
    );
  }
}
