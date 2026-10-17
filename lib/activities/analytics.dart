import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/activities/analytics_expenses_detail.dart';
import 'package:noya2/activities/analytics_evolution_detail.dart';
import 'package:noya2/activities/analytics_history_detail.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:noya2/styles/custom_color_scheme.dart';
import 'package:noya2/theme/app_theme.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  late final Future<_AnalyticsData> _analyticsFuture;

  @override
  void initState() {
    super.initState();
    _analyticsFuture = _loadAnalytics();
  }

  Future<_AnalyticsData> _loadAnalytics() async {
    final referenceDate = DateTime.now();
    final results = await Future.wait([
      TransactionService.getCurrentMonthExpensesByCategory(referenceDate),
      TransactionService.getLastYearTotals(referenceDate),
    ]);

    return _AnalyticsData(
      expenseByCategory: results[0],
      yearlyTotals: results[1],
      referenceDate: referenceDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AnalyticsData>(
      future: _analyticsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final data = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _ChartCard(
              title: AppLocalizations.of(context)!.analytics_expenses_by_category,
              child: _buildExpensePieChart(context, data.expenseByCategory),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsExpensesDetail()),
                );
              },
            ),
            _ChartCard(
              title: AppLocalizations.of(context)!.analytics_history,
              child: _buildHistoryBarChart(context, data),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsHistoryDetail()),
                );
              },
            ),
            _ChartCard(
              title: AppLocalizations.of(context)!.analytics_evolution,
              child: _buildEvolutionLineChart(context, data),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsEvolutionDetail()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpensePieChart(BuildContext context, List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) {
      return _emptyChart(context);
    }

    final total = rows.fold<double>(0, (sum, row) => sum + _asDouble(row['total']));
    final sections = <PieChartSectionData>[];
    final legend = <Widget>[];
    for (var index = 0; index < rows.length; index++) {
      final row = rows[index];
      final value = _asDouble(row['total']);
      final color = AppTheme.chartColors[index % AppTheme.chartColors.length];
      sections.add(PieChartSectionData(
        value: value,
        title: '${(value / total * 100).toStringAsFixed(0)}%',
        color: color,
        radius: 82,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ));
      legend.add(_LegendItem(color: color, label: row['category_label'] as String));
    }

    return SizedBox(
      height: 220,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 20, sectionsSpace: 2)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: legend,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryBarChart(BuildContext context, _AnalyticsData data) {
    final months = _months(data.referenceDate);
    final totals = _monthlyTotals(data.yearlyTotals);
    final maxValue = _maxMonthlyValue(totals);
    return SizedBox(
      height: 280,
      child: BarChart(BarChartData(
        maxY: maxValue,
        minY: 0,
        barGroups: [
          for (var index = 0; index < months.length; index++)
            BarChartGroupData(x: index, barsSpace: 2, barRods: [
              BarChartRodData(toY: totals[months[index]]?[Category.revenue] ?? 0, color: Theme.of(context).colorScheme.revenueColor, width: 8),
              BarChartRodData(toY: totals[months[index]]?[Category.expense] ?? 0, color: Theme.of(context).colorScheme.expensecolor, width: 8),
            ]),
        ],
        titlesData: _titlesData(context, months),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        barTouchData: const BarTouchData(enabled: false),
      )),
    );
  }

  Widget _buildEvolutionLineChart(BuildContext context, _AnalyticsData data) {
    final months = _months(data.referenceDate);
    final totals = _monthlyTotals(data.yearlyTotals);
    final maxValue = _maxMonthlyValue(totals);
    final revenueColor = Theme.of(context).colorScheme.revenueColor;
    final expenseColor = Theme.of(context).colorScheme.expensecolor;
    return SizedBox(
      height: 280,
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
        lineTouchData: const LineTouchData(enabled: false),
      )),
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
          final date = DateTime.parse('${months[index]}-01');
          return SideTitleWidget(meta: meta, child: Text(DateFormat('MMM', locale).format(date)));
        },
      )),
    );
  }

  Widget _emptyChart(BuildContext context) {
    return SizedBox(height: 220, child: Center(child: Text(AppLocalizations.of(context)!.analytics_no_data)));
  }

  List<String> _months(DateTime referenceDate) {
    return [for (var index = 11; index >= 0; index--) DateFormat('yyyy-MM').format(DateTime(referenceDate.year, referenceDate.month - index))];
  }

  Map<String, Map<int, double>> _monthlyTotals(List<Map<String, dynamic>> rows) {
    final totals = <String, Map<int, double>>{};
    for (final row in rows) {
      final month = row['month'] as String;
      final type = row['type'] as int;
      totals.putIfAbsent(month, () => {})[type] = _asDouble(row['total']);
    }
    return totals;
  }

  double _maxMonthlyValue(Map<String, Map<int, double>> totals) {
    final values = totals.values.expand((month) => month.values);
    final maxValue = values.fold<double>(0, (max, value) => value > max ? value : max);
    return maxValue == 0 ? 1 : maxValue * 1.2;
  }

  double _asDouble(dynamic value) => (value as num?)?.toDouble() ?? 0;

}

class _AnalyticsData {
  const _AnalyticsData({required this.expenseByCategory, required this.yearlyTotals, required this.referenceDate});

  final List<Map<String, dynamic>> expenseByCategory;
  final List<Map<String, dynamic>> yearlyTotals;
  final DateTime referenceDate;
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child, this.onTap});

  final String title;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ]),
        ),
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
      Container(width: 10, height: 10, color: color),
      const SizedBox(width: 5),
      Text(label),
    ]);
  }
}