import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:noya2/components/text_field_date_picker.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/services/date_service.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:noya2/theme/app_theme.dart';

class AnalyticsExpensesDetail extends StatefulWidget {
  const AnalyticsExpensesDetail({super.key});

  @override
  State<AnalyticsExpensesDetail> createState() => _AnalyticsExpensesDetailState();
}

class _AnalyticsExpensesDetailState extends State<AnalyticsExpensesDetail> {
  late DateTime _startDate;
  late DateTime _endDate;
  late DateTime _monthReference;
  late int _yearReference;
  late Future<List<Map<String, dynamic>>> _expensesFuture;
  _ExpensePeriod _period = _ExpensePeriod.month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _monthReference = DateTime(now.year, now.month);
    _yearReference = now.year;
    _startDate = DateTime(now.year, now.month);
    _endDate = DateTime(now.year, now.month + 1);
    _reload();
  }

  void _reload() {
    _expensesFuture = TransactionService.getExpensesByCategory(_startDate, _endDate);
  }

  void _selectPeriod(_ExpensePeriod period) {
    final today = DateTime.now();
    setState(() {
      _period = period;
      if (period == _ExpensePeriod.month) {
        _monthReference = DateTime(_monthReference.year, _monthReference.month);
        _setMonthRange(_monthReference);
      } else if (period == _ExpensePeriod.year) {
        _setYearRange(_yearReference);
      } else if (period == _ExpensePeriod.custom) {
        _startDate = DateTime(today.year, today.month, today.day).subtract(const Duration(days: 30));
        _endDate = DateTime(today.year, today.month, today.day + 1);
      }
      _reload();
    });
  }

  void _changeMonth(int amount) {
    setState(() {
      _monthReference = amount > 0
          ? DateService.addMonths(_monthReference, amount)
          : DateService.subractMonths(_monthReference, amount.abs());
      _setMonthRange(_monthReference);
      _reload();
    });
  }

  void _setMonthRange(DateTime month) {
    _startDate = DateTime(month.year, month.month);
    _endDate = DateTime(month.year, month.month + 1);
  }

  void _changeYear(int amount) {
    setState(() {
      _yearReference += amount;
      _setYearRange(_yearReference);
      _reload();
    });
  }

  void _setYearRange(int year) {
    _startDate = DateTime(year);
    _endDate = DateTime(year + 1);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.analytics_expenses_by_category)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: SegmentedButton<_ExpensePeriod>(
              segments: [
                ButtonSegment(value: _ExpensePeriod.month, label: Text(localizations.analytics_period_month)),
                ButtonSegment(value: _ExpensePeriod.year, label: Text(localizations.analytics_period_year)),
                ButtonSegment(value: _ExpensePeriod.custom, label: Text(localizations.analytics_period_custom)),
              ],
              selected: {_period},
              onSelectionChanged: (selection) {
                final period = selection.first;
                _selectPeriod(period);
              },
            ),
          ),
          if (_period == _ExpensePeriod.month)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 30),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        DateService.getMonthYearDesc(_monthReference, localizations.localeName),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 30),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              ),
            ),
          if (_period == _ExpensePeriod.year)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 30),
                    onPressed: () => _changeYear(-1),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _yearReference.toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 30),
                    onPressed: () => _changeYear(1),
                  ),
                ],
              ),
            ),
          if (_period == _ExpensePeriod.custom)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFieldDatePicker(
                      key: ValueKey(_startDate),
                      labelText: localizations.analytics_start_date,
                      initialDate: _startDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      locale: localizations.localeName,
                      onDateChanged: (date) {
                        setState(() {
                          _startDate = DateTime(date.year, date.month, date.day);
                          if (!_endDate.isAfter(_startDate)) {
                            _endDate = DateTime(date.year, date.month, date.day + 1);
                          }
                          _reload();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFieldDatePicker(
                      key: ValueKey(_endDate),
                      labelText: localizations.analytics_end_date,
                      initialDate: _endDate.subtract(const Duration(days: 1)),
                      firstDate: _startDate,
                      lastDate: DateTime.now(),
                      locale: localizations.localeName,
                      onDateChanged: (date) {
                        setState(() {
                          _endDate = DateTime(date.year, date.month, date.day + 1);
                          _reload();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _expensesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                return _buildChart(context, snapshot.data ?? const []);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.analytics_no_data));
    }

    final total = rows.fold<double>(0, (sum, row) => sum + _asDouble(row['total']));
    final sections = <PieChartSectionData>[];
    final legend = <Widget>[];
    for (var index = 0; index < rows.length; index++) {
      final value = _asDouble(rows[index]['total']);
      final color = AppTheme.chartColors[index % AppTheme.chartColors.length];
      sections.add(PieChartSectionData(
        value: value,
        title: '${(value / total * 100).toStringAsFixed(0)}%',
        color: color,
        radius: 110,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ));
      legend.add(_LegendItem(color: color, label: rows[index]['category_label'] as String));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 320, child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 35, sectionsSpace: 2))),
          const SizedBox(height: 20),
          ...legend,
        ],
      ),
    );
  }

  double _asDouble(dynamic value) => (value as num?)?.toDouble() ?? 0;

}

enum _ExpensePeriod { month, year, custom }

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 8),
        Text(label),
      ]),
    );
  }
}
