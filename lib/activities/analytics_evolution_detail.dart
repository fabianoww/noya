import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:noya2/styles/custom_color_scheme.dart';

class AnalyticsEvolutionDetail extends StatefulWidget {
  const AnalyticsEvolutionDetail({super.key});

  @override
  State<AnalyticsEvolutionDetail> createState() => _AnalyticsEvolutionDetailState();
}

class _AnalyticsEvolutionDetailState extends State<AnalyticsEvolutionDetail> {
  late DateTime _startMonth;
  late DateTime _endMonth;
  late Future<List<Map<String, dynamic>>> _totalsFuture;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startMonth = DateTime(now.year, now.month - 11);
    _endMonth = DateTime(now.year, now.month);
    _reload();
  }

  void _reload() {
    _totalsFuture = TransactionService.getMonthlyTotals(_startMonth, DateTime(_endMonth.year, _endMonth.month + 1));
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final lastMonthDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    return Scaffold(
      appBar: AppBar(title: Text(localizations.analytics_evolution)),
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
                    lastDate: lastMonthDay,
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
                    lastDate: lastMonthDay,
                    locale: localizations.localeName,
                    onDateChanged: _setEndMonth,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _totalsFuture,
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
    final months = _months();
    final totals = <String, Map<int, double>>{};
    for (final row in rows) {
      totals.putIfAbsent(row['month'] as String, () => {})[row['type'] as int] = _asDouble(row['total']);
    }

    if (rows.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.analytics_no_data));
    }

    final revenueColor = Theme.of(context).colorScheme.revenueColor;
    final expenseColor = Theme.of(context).colorScheme.expensecolor;
    final maxValue = _maxValue(totals);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 320,
            child: LineChart(LineChartData(
              minY: 0,
              maxY: maxValue,
              lineBarsData: [
                _lineData(months, totals, Category.revenue, revenueColor),
                _lineData(months, totals, Category.expense, expenseColor),
              ],
              titlesData: _titlesData(context, months),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
            )),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: revenueColor, label: AppLocalizations.of(context)!.label_revenue),
              const SizedBox(width: 20),
              _LegendItem(color: expenseColor, label: AppLocalizations.of(context)!.label_expense),
            ],
          ),
        ],
      ),
    );
  }

  LineChartBarData _lineData(List<String> months, Map<String, Map<int, double>> totals, int type, Color color) {
    return LineChartBarData(
      spots: [for (var index = 0; index < months.length; index++) FlSpot(index.toDouble(), totals[months[index]]?[type] ?? 0)],
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: true),
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

class _MonthYearField extends StatefulWidget {
  const _MonthYearField({
    required this.labelText,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.locale,
    required this.onDateChanged,
    super.key,
  });

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
    _controller = TextEditingController(text: _formatDate(_selectedDate));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectMonth() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (pickedDate == null) return;

    final normalizedDate = DateTime(pickedDate.year, pickedDate.month);
    setState(() {
      _selectedDate = normalizedDate;
      _controller.text = _formatDate(normalizedDate);
    });
    widget.onDateChanged(normalizedDate);
  }

  String _formatDate(DateTime date) => DateFormat('MMM/yyyy', widget.locale).format(date);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      onTap: _selectMonth,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: const Icon(Icons.calendar_month),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 12, height: 12, color: color),
      const SizedBox(width: 8),
      Text(label),
    ]);
  }
}
