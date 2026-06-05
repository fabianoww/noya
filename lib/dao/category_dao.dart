import 'package:noya2/dao/noya_database.dart';
import 'package:noya2/model/category.dart';

class CategoryDao {
  static Future<int> insert(Category category) async {
    final db = await NoyaDatabase.getInstance();
    return db.insert('category', category.toMap());
  }

  static Future<int> update(Category category) async {
    final db = await NoyaDatabase.getInstance();
    return await db.update('category', category.toMap(), where: 'id = ?', whereArgs: [category.id]);
  }

  static Future<List<Category>> listActive(int type) async {
    final db = await NoyaDatabase.getInstance();
    final List<Map<String, dynamic>> result = await db.query('category', where: 'type = ?', whereArgs: [type]);
    return List.generate(result.length, (i) => Category.fromMap(result[i]));

  }

  static Future<void> delete(Category category) async {
    final db = await NoyaDatabase.getInstance();
    await db.delete('category', where: 'id = ?', whereArgs: [category.id]);
  }

}
