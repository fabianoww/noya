import 'package:noya2/dao/noya_database.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/model/credit_card.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:intl/intl.dart';
import 'package:noya2/services/date_service.dart';
import 'package:noya2/util/string_util.dart';

class TransactionDao {

  static Future<TransactionRecord?> findById(int id) async {
    final db = await NoyaDatabase.getInstance();

    String query = '''
    SELECT t.id, t.label, t.value, t.date, t.create_date, t.installments, 
      t.category_id, c.label as category_label, c.icon as category_icon, c.type as category_type,
      t.credit_card_id, cc.label as creditcard_label, cc.close_day, cc.due_day 
    FROM transaction_record t
    JOIN category c ON t.category_id = c.id
    LEFT JOIN  credit_card cc ON t.credit_card_id = cc.id
    WHERE t.id = ?''';

    List<Map<String, dynamic>> result = await db.rawQuery(query, [id]);

    if (result.isEmpty) {
      return null;
    }
    else {
      return TransactionRecord.fromMap(result[0]);
    }
  }

  static Future<int> insert(TransactionRecord transaction) async {
    final db = await NoyaDatabase.getInstance();
    return await db.insert('transaction_record', transaction.toMap());
  }

  static Future<int> update(TransactionRecord transaction) async {
    final db = await NoyaDatabase.getInstance();
    return await db.update('transaction_record', transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);
  }

  static Future<void> delete(TransactionRecord transaction) async {
    final db = await NoyaDatabase.getInstance();
    await deleteInstallments(transaction);
    await db.delete('transaction_record', where: 'id = ?', whereArgs: [transaction.id]);
  }

  static Future<void> deleteInstallments(TransactionRecord transaction) async {
    final db = await NoyaDatabase.getInstance();
    await db.delete('transaction_record', where: 'parent_transaction_id = ?', whereArgs: [transaction.id]);
  }

  static Future<List<TransactionRecord>> getTimelineTransactions(int offset, int amount, String searchTerm) async {
    final db = await NoyaDatabase.getInstance();

    String filterClause = searchTerm.isNotEmpty
        ? '''AND (
          ${StringUtil.removeAccentsFromClause('t.label')} LIKE '%' || ? || '%'
          OR ${StringUtil.removeAccentsFromClause('c.label')} LIKE '%' || ? || '%'
          OR PRINTF('%.2f', t.value) LIKE '%' || ? || '%'
          )'''
        : '';

    String query = '''
    SELECT t.id, t.label, t.value, t.category_id, c.label as category_label, c.icon as category_icon, c.type as category_type 
    FROM transaction_record t
    JOIN category c ON t.category_id = c.id
    WHERE t.parent_transaction_id IS NULL 
    $filterClause
    ORDER BY t.create_date DESC 
    LIMIT ? OFFSET ?''';

    List<dynamic> args = [];
    if (searchTerm.isNotEmpty) {
      String normalizedSearchTerm = StringUtil.removeAccentsFromValue(searchTerm);
      String normalizedValueTerm = StringUtil.removeNonDigits(searchTerm);
      args.add(normalizedSearchTerm);  // Transaction label
      args.add(normalizedSearchTerm);  // Category label
      args.add(normalizedValueTerm.isNotEmpty ? normalizedValueTerm : normalizedSearchTerm);  // Transaction value
    }
    args.addAll([amount, offset]);

    List<Map<String, dynamic>> result = await db.rawQuery(query, args);
    List<TransactionRecord> list = [];

    for (var item in result) {
      list.add(TransactionRecord.fromMap(item));
    }
    
    return list;
  }

  static Future<double> getTotalMonth(DateTime date, int type) async {
    final db = await NoyaDatabase.getInstance();

    String yearMonth = DateFormat('yyyy-MM').format(date);
    String query = '''
    SELECT SUM(t.value) as total
    FROM transaction_record t
    JOIN category c ON t.category_id = c.id
    WHERE t.date LIKE ?
    AND c.type = ?
    AND (credit_card_id IS NULL OR parent_transaction_id IS NOT NULL)
    ''';
    
    List<Map<String, dynamic>> result = await db.rawQuery(query, ['$yearMonth-__ __:__:__', type]);
    if (result.isNotEmpty) {
      double? total = result[0]['total'];
      return total ?? 0.0;
    }

    return 0;
  }

  static Future<List<Map<String, dynamic>>> getCurrentMonthExpensesByCategory(DateTime date) async {
    return getExpensesByCategory(DateTime(date.year, date.month), DateTime(date.year, date.month + 1));
  }

  static Future<List<Map<String, dynamic>>> getExpensesByCategory(DateTime start, DateTime end) async {
    final db = await NoyaDatabase.getInstance();
    return db.rawQuery('''
      SELECT c.label AS category_label, SUM(t.value) AS total
      FROM transaction_record t
      JOIN category c ON t.category_id = c.id
      WHERE t.date >= ?
        AND t.date < ?
        AND c.type = ?
        AND (t.credit_card_id IS NULL OR t.parent_transaction_id IS NOT NULL)
      GROUP BY c.id, c.label
      ORDER BY total DESC
    ''', [DateFormat('yyyy-MM-dd HH:mm:ss').format(start), DateFormat('yyyy-MM-dd HH:mm:ss').format(end), Category.expense]);
  }

  static Future<List<Map<String, dynamic>>> getLastYearTotals(DateTime date) async {
    final db = await NoyaDatabase.getInstance();
    final firstMonth = DateTime(date.year, date.month - 11);
    final firstMonthValue = DateFormat('yyyy-MM').format(firstMonth);
    final nextMonthValue = DateFormat('yyyy-MM').format(DateTime(date.year, date.month + 1));

    return db.rawQuery('''
      SELECT strftime('%Y-%m', t.date) AS month, c.type AS type, SUM(t.value) AS total
      FROM transaction_record t
      JOIN category c ON t.category_id = c.id
      WHERE t.date >= ? || '-01 00:00:00'
        AND t.date < ? || '-01 00:00:00'
        AND (t.credit_card_id IS NULL OR t.parent_transaction_id IS NOT NULL)
      GROUP BY month, c.type
      ORDER BY month ASC
    ''', [firstMonthValue, nextMonthValue]);
  }

  static Future<List<TransactionRecord>> getSpreadsheetTransactions(DateTime date, String searchTerm) async {
    final db = await NoyaDatabase.getInstance();

    String filterClause = searchTerm.isNotEmpty
        ? '''AND (
          ${StringUtil.removeAccentsFromClause('t.label')} LIKE '%' || ? || '%'
          OR ${StringUtil.removeAccentsFromClause('c.label')} LIKE '%' || ? || '%'
          OR PRINTF('%.2f', t.value) LIKE '%' || ? || '%'
          )'''
        : '';

    String query = '''
    SELECT t.id, t.label, t.value, t.category_id, t.parent_transaction_id,
      c.label as category_label, c.icon as category_icon, c.type as category_type 
    FROM transaction_record t
    JOIN category c ON t.category_id = c.id
    WHERE t.date LIKE ?
    AND (t.parent_transaction_id IS NOT NULL 
    OR t.credit_card_id IS NULL)
    $filterClause
    ORDER BY t.create_date DESC''';

    List<dynamic> args = [];
    args.add(DateService.formatToSpreadsheetWhere(date));
    
    if (searchTerm.isNotEmpty) {
      String normalizedSearchTerm = StringUtil.removeAccentsFromValue(searchTerm);
      String normalizedValueTerm = StringUtil.removeNonDigits(searchTerm);
      args.add(normalizedSearchTerm);  // Transaction label
      args.add(normalizedSearchTerm);  // Category label
      args.add(normalizedValueTerm.isNotEmpty ? normalizedValueTerm : normalizedSearchTerm);  // Transaction value
    }

    List<Map<String, dynamic>> result = await db.rawQuery(query, args);
    List<TransactionRecord> list = [];

    for (var item in result) {
      list.add(TransactionRecord.fromMap(item));
    }
    
    return list;
  }
  
  static Future<String?> getPredictedExpenseLabel(int predictionWindow) async {
    final db = await NoyaDatabase.getInstance();

    String query = '''
    SELECT label, COUNT(*) FROM (
      SELECT t.label
      FROM transaction_record t
      JOIN category c ON t.category_id = c.id
      WHERE t.parent_transaction_id IS NULL
      AND c.type = 2
      ORDER BY t.id DESC
      LIMIT 100)
    GROUP BY label
    ORDER BY 2 desc
    LIMIT 1''';

    List<Map<String, dynamic>> result = await db.rawQuery(query);

    for (var item in result) {
      return item['label'];
    }
    
    return null;
  }
  
  static Future<String?> getPredictedExpenseCategory(int predictionWindow) async {
    final db = await NoyaDatabase.getInstance();

    String query = '''
    SELECT category_id, COUNT(*) FROM (
      SELECT t.category_id
      FROM transaction_record t
      JOIN category c ON t.category_id = c.id
      WHERE t.parent_transaction_id IS NULL
      AND c.type = 2
      ORDER BY t.id DESC
      LIMIT 100)
    GROUP BY category_id
    ORDER BY 2 desc
    LIMIT 1''';

    List<Map<String, dynamic>> result = await db.rawQuery(query);

    for (var item in result) {
      return item['category_id'].toString();
    }
    
    return null;
  }
  
  static Future<String?> getPredictedExpenseCreditCard(int predictionWindow) async {
    final db = await NoyaDatabase.getInstance();

    String query = '''
    SELECT credit_card_id, COUNT(*) FROM (
      SELECT t.credit_card_id
      FROM transaction_record t
      JOIN category c ON t.category_id = c.id
      WHERE t.parent_transaction_id IS NULL
      AND c.type = 2
      ORDER BY t.id DESC
      LIMIT 100)
    GROUP BY credit_card_id
    ORDER BY 2 desc
    LIMIT 1''';

    List<Map<String, dynamic>> result = await db.rawQuery(query);

    for (var item in result) {
      return item['credit_card_id'].toString();
    }
    
    return null;
  }
  
  static Future<String?> getPredictedRevenueLabel(int predictionWindow) async {
    final db = await NoyaDatabase.getInstance();

    String query = '''
    SELECT label, COUNT(*) FROM (
      SELECT t.label
      FROM transaction_record t
      JOIN category c ON t.category_id = c.id
      WHERE t.parent_transaction_id IS NULL
      AND c.type = 1
      ORDER BY t.id DESC
      LIMIT 100)
    GROUP BY label
    ORDER BY 2 desc
    LIMIT 1''';

    List<Map<String, dynamic>> result = await db.rawQuery(query);

    for (var item in result) {
      return item['label'];
    }
    
    return null;
  }
  
  static Future<String?> getPredictedRevenueCategory(int predictionWindow) async {
    final db = await NoyaDatabase.getInstance();

    String query = '''
    SELECT category_id, COUNT(*) FROM (
      SELECT t.category_id
      FROM transaction_record t
      JOIN category c ON t.category_id = c.id
      WHERE t.parent_transaction_id IS NULL
      AND c.type = 1
      ORDER BY t.id DESC
      LIMIT 100)
    GROUP BY category_id
    ORDER BY 2 desc
    LIMIT 1''';

    List<Map<String, dynamic>> result = await db.rawQuery(query);

    for (var item in result) {
      return item['category_id'].toString();
    }
    
    return null;
  }

  static Future<int> getTransactionsCountByCategory(Category category) async {
    final db = await NoyaDatabase.getInstance();

    String query = '''
    SELECT count(t.id) as total
    FROM transaction_record t
    WHERE t.category_id = ?
    ''';
    
    List<Map<String, dynamic>> result = await db.rawQuery(query, [category.id]);
    if (result.isNotEmpty) {
      int total = result[0]['total'];
      return total;
    }

    return 0;
  }

  static Future<int> getTransactionsCountByCreditCard(CreditCard creditCard) async {
    final db = await NoyaDatabase.getInstance();

    String query = '''
    SELECT count(t.id) as total
    FROM transaction_record t
    WHERE t.credit_card_id = ?
    ''';
    
    List<Map<String, dynamic>> result = await db.rawQuery(query, [creditCard.id]);
    if (result.isNotEmpty) {
      int total = result[0]['total'];
      return total;
    }

    return 0;
  }
  
}
