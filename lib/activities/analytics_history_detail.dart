import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/services/category_service.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:noya2/styles/custom_color_scheme.dart';

class AnalyticsHistoryDetail extends StatefulWidget {
  const AnalyticsHistoryDetail({super.key});

  @override
  State<AnalyticsHistoryDetail> createState() => _AnalyticsHistoryDetailState();
}

class _AnalyticsHistoryDetailState extends State<AnalyticsHistoryDetail> {
  late DateTime _startMonth;
  late DateTime _endMonth;
  late Future<_HistoryData> _historyFuture;
  late Future<List<Category>> _categoriesFuture;
  _HistoryFilter _filter = const _HistoryFilter.all();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startMonth = DateTime(now.year, now.month - 11);
    _endMonth = DateTime(now.year, now.month);
    _categoriesFuture = Future.wait([
      CategoryService.listActive(Category.expense),
      CategoryService.listActive(Category.revenue),
    ]).then((categories) => [...categories[0], ...categories[1]]);
    _reload();
  }

  void _reload() {
    _historyFuture = TransactionService.getMonthlyTotals(
        _startMonth,
        DateTime(_endMonth.year, _endMonth.month + 1),
        categoryType: _filter.type,
        categoryId: _filter.category?.id,
      ).then((rows) => _HistoryData(rows: rows));
  }

  void _setStartMonth(DateTime date) {
    setState(() {
      _startMonth = DateTime(date.year, date.month);
      if (_startMonth.isAfter(_endMonth)) {
        _endMonth = _startMonth;
      }
      _reload();
    });
  }

  void _setEndMonth(DateTime date) {
    setState(() {
      _endMonth = DateTime(date.year, date.month);
      _reload();
    });
  }

  void _setFilter(_HistoryFilter filter) {
    setState(() {
      _filter = filter;
      _reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final lastMonth = DateTime(DateTime.now().year, DateTime.now().month);
    return Scaffold(
      appBar: AppBar(title: Text(localizations.analytics_history)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _MonthYearField(
                    key: ValueKey(_startMonth),
                    labelText: localizations.analytics_start_date,
                    initialDate: _startMonth,
                    firstDate: DateTime(2000),
                    lastDate: lastMonth,
                    locale: localizations.localeName,
                    onDateChanged: _setStartMonth,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MonthYearField(
                    key: ValueKey(_endMonth),
                    labelText: localizations.analytics_end_date,
                    initialDate: _endMonth,
                    firstDate: _startMonth,
                    lastDate: lastMonth,
                    locale: localizations.localeName,
                    onDateChanged: _setEndMonth,
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Category>>(
            future: _categoriesFuture,
            builder: (context, snapshot) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: DropdownButtonFormField<_HistoryFilter>(
                initialValue: _filter,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: localizations.analytics_history_filter,
                  prefixIcon: const Icon(Icons.filter_list),
                ),
                items: [
                  DropdownMenuItem(
                    value: const _HistoryFilter.all(),
                    child: Text(localizations.analytics_filter_all),
                  ),
                  DropdownMenuItem(
                    value: const _HistoryFilter.expenses(),
                    child: Text(localizations.analytics_filter_all_expenses),
                  ),
                  DropdownMenuItem(
                    value: const _HistoryFilter.revenues(),
                    child: Text(localizations.analytics_filter_all_revenues),
                  ),
                  if (snapshot.hasData) ..._categoryItems(snapshot.data!),
                ],
                onChanged: snapshot.hasData ? (filter) {
                  if (filter != null) _setFilter(filter);
                } : null,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<_HistoryData>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                return _buildChart(context, snapshot.data!.rows);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<_HistoryFilter>> _categoryItems(List<Category> categories) {
    return categories.map((category) {
      return DropdownMenuItem(
        value: _HistoryFilter.category(category),
        child: Text(category.label ?? ''),
      );
    }).toList();
  }

  Widget _buildChart(BuildContext context, List<Map<String, dynamic>> rows) {
    final months = _months();
    final totals = <String, Map<int, double>>{};
    for (final row in rows) {
      totals.putIfAbsent(row['month'] as String, () => {})[row['type'] as int] = _asDouble(row['total']);
    }

    if (rows.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.analytics_no_data));
    }

    final maxValue = _maxValue(totals);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BarChart(BarChartData(
        minY: 0,
        maxY: maxValue,
        barGroups: [
          for (var index = 0; index < months.length; index++)
            BarChartGroupData(x: index, barsSpace: 2, barRods: [
              BarChartRodData(toY: totals[months[index]]?[Category.revenue] ?? 0, color: Theme.of(context).colorScheme.revenueColor, width: 10),
              BarChartRodData(toY: totals[months[index]]?[Category.expense] ?? 0, color: Theme.of(context).colorScheme.expensecolor, width: 10),
            ]),
        ],
        titlesData: _titlesData(context, months),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        barTouchData: const BarTouchData(enabled: false),
      )),
    );
  }

  FlTitlesData _titlesData(BuildContext context, List<String> months) {
    final locale = AppLocalizations.of(context)!.localeName;
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 42)),
      bottomTitles: AxisTitles(sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          if (index < 0 || index >= months.length) return const SizedBox.shrink();
          return SideTitleWidget(
            meta: meta,
            child: Text(DateFormat('MMM', locale).format(DateTime.parse('${months[index]}-01'))),
          );
        },
      )),
    );
  }

  List<String> _months() {
    final months = <String>[];
    var month = _startMonth;
    while (!month.isAfter(_endMonth)) {
      months.add(DateFormat('yyyy-MM').format(month));
      month = DateTime(month.year, month.month + 1);
    }
    return months;
  }

  double _maxValue(Map<String, Map<int, double>> totals) {
    final values = totals.values.expand((month) => month.values);
    final maxValue = values.fold<double>(0, (max, value) => value > max ? value : max);
    return maxValue == 0 ? 1 : maxValue * 1.2;
  }

  double _asDouble(dynamic value) => (value as num?)?.toDouble() ?? 0;
}

class _HistoryData {
  const _HistoryData({required this.rows});

  final List<Map<String, dynamic>> rows;
}

enum _HistoryFilterType { all, expenses, revenues, category }

class _HistoryFilter {
  const _HistoryFilter.all() : type = null, category = null, filterType = _HistoryFilterType.all;
  const _HistoryFilter.expenses() : type = Category.expense, category = null, filterType = _HistoryFilterType.expenses;
  const _HistoryFilter.revenues() : type = Category.revenue, category = null, filterType = _HistoryFilterType.revenues;
  const _HistoryFilter.category(Category value) : type = null, category = value, filterType = _HistoryFilterType.category;

  final int? type;
  final Category? category;
  final _HistoryFilterType filterType;

  @override
  bool operator ==(Object other) => other is _HistoryFilter && other.filterType == filterType && other.category?.id == category?.id;

  @override
  int get hashCode => Object.hash(filterType, category?.id);
}

class _MonthYearField extends StatefulWidget {
  const _MonthYearField({required this.labelText, required this.initialDate, required this.firstDate, required this.lastDate, required this.locale, required this.onDateChanged, super.key});

  final String labelText;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String locale;
  final ValueChanged<DateTime> onDateChanged;

  @override
  State<_MonthYearField> createState() => _MonthYearFieldState();
}

class _MonthYearFieldState extends State<_MonthYearField> {
  late DateTime _selectedDate;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(text: DateFormat('MMM/yyyy', widget.locale).format(_selectedDate));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectMonth() async {
    final pickedDate = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: widget.firstDate, lastDate: widget.lastDate);
    if (pickedDate == null) return;
    final normalizedDate = DateTime(pickedDate.year, pickedDate.month);
    setState(() {
      _selectedDate = normalizedDate;
      _controller.text = DateFormat('MMM/yyyy', widget.locale).format(normalizedDate);
    });
    widget.onDateChanged(normalizedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      onTap: _selectMonth,
      decoration: InputDecoration(labelText: widget.labelText, prefixIcon: const Icon(Icons.calendar_month)),
    );
  }
}
