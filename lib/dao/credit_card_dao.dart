import 'package:noya2/dao/noya_database.dart';
import 'package:noya2/model/credit_card.dart';

class CreditCardDao {
  static Future<int> insert(CreditCard creditCard) async {
    final db = await NoyaDatabase.getInstance();
    return db.insert('credit_card', creditCard.toMap());
  }

  static Future<int> update(CreditCard creditCard) async {
    final db = await NoyaDatabase.getInstance();
    return await db.update('credit_card', creditCard.toMap(), where: 'id = ?', whereArgs: [creditCard.id]);
  }

  static Future<List<CreditCard>> listActive() async {
    final db = await NoyaDatabase.getInstance();
    final List<Map<String, dynamic>> result = await db.query('credit_card');
    return List.generate(result.length, (i) => CreditCard.fromMap(result[i]));
  }

  static Future<void> delete(CreditCard creditCard) async {
    final db = await NoyaDatabase.getInstance();
    await db.delete('credit_card', where: 'id = ?', whereArgs: [creditCard.id]);
  }

}
