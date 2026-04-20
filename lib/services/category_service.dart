import 'package:noya2/dao/category_dao.dart';
import 'package:noya2/model/category.dart';

class CategoryService {

  static Future<int> save(Category category) async {
    if (category.id == null) {
      return await CategoryDao.insert(category);
    } else {
      await CategoryDao.update(category);
      return category.id!;
    }
  }

  static Future<List<Category>> listActive(int type) async {
    return CategoryDao.listActive(type);
  }

  static Future<void> delete(Category category) async {
    if (category.id != null) {
      return CategoryDao.delete(category);
    }
  }

}