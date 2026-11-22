import 'package:noya2/dao/noya_database.dart';
import 'package:noya2/model/family_monthly_report.dart';

class FamilyReportService {
  static Future<FamilyMonthlyReport> getMonthlyReport(DateTime month) async {
    final db = await NoyaDatabase.getInstance();
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final monthStart = start.toIso8601String().substring(0, 10);
    final monthEnd = end.toIso8601String().substring(0, 10);

    final periodRows = await db.rawQuery(
      '''
      SELECT DISTINCT member_uuid
      FROM family_membership_period
      WHERE substr(joined_at, 1, 10) < ?
        AND (left_at IS NULL OR substr(left_at, 1, 10) >= ?)
    ''',
      [monthEnd, monthStart],
    );
    final memberCount = periodRows.isEmpty ? 0 : periodRows.length;

    final sharedRows = await db.rawQuery(
      '''
      SELECT t.author_uuid, fm.name, c.type,
             SUM(t.value) AS total
      FROM transaction_record t
      JOIN category c ON c.id = t.category_id
      LEFT JOIN family_member fm ON fm.uuid = t.author_uuid
      WHERE t.is_private = 0
        AND t.date >= ?
        AND t.date < ?
        AND (t.credit_card_id IS NULL OR t.parent_transaction_id IS NOT NULL)
      GROUP BY t.author_uuid, fm.name, c.type
    ''',
      [monthStart + ' 00:00:00', monthEnd + ' 00:00:00'],
    );

    final totals = <String, double>{};
    final revenues = <String, double>{};
    final names = <String, String>{};
    double totalExpenses = 0;
    double totalRevenues = 0;

    for (final row in sharedRows) {
      final author = (row['author_uuid'] as String?) ?? 'unknown';
      final name = (row['name'] as String?) ?? 'Member';
      names.putIfAbsent(author, () => name);
      final value = ((row['total'] as num?) ?? 0).toDouble();
      if (row['type'] == 2) {
        totals.update(
          author,
          (current) => current + value,
          ifAbsent: () => value,
        );
        totalExpenses += value;
      } else if (row['type'] == 1) {
        revenues.update(
          author,
          (current) => current + value,
          ifAbsent: () => value,
        );
        totalRevenues += value;
      }
    }

    final average = memberCount == 0
        ? 0.0
        : (totalExpenses / memberCount * 100).roundToDouble() / 100;
    final memberUuids = <String>{...totals.keys, ...revenues.keys};
    final members = memberUuids.map((uuid) {
      final expenses = ((totals[uuid] ?? 0) * 100).roundToDouble() / 100;
      final balance = ((expenses - average) * 100).roundToDouble() / 100;
      final revenue = ((revenues[uuid] ?? 0) * 100).roundToDouble() / 100;
      return FamilyMonthlyMemberReport(
        memberUuid: uuid,
        memberName: names[uuid] ?? 'Member',
        expenses: expenses,
        revenues: revenue,
        balanceAgainstAverage: balance,
      );
    }).toList()..sort((a, b) => a.memberName.compareTo(b.memberName));

    return FamilyMonthlyReport(
      year: month.year,
      month: month.month,
      totalExpenses: (totalExpenses * 100).roundToDouble() / 100,
      totalRevenues: (totalRevenues * 100).roundToDouble() / 100,
      memberCount: memberCount,
      averageExpense: average,
      members: members,
    );
  }
}
