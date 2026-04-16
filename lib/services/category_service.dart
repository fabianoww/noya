import 'package:flutter/material.dart';
import 'package:noya2/dao/category_dao.dart';
import 'package:noya2/model/category.dart';

class CategoryService {

  static List<Category> getRevenueCategories() {
    // FIXME Load data from database
    return [
      Category(1, "Salário", Icons.work, Category.REVENUE),
      Category(2, "Investimentos", Icons.money, Category.REVENUE)
    ];
  }

  static List<Category> getExpenseCategories() {
    // FIXME Load data from database
    return [
      Category(3, "Moradia", Icons.home, Category.EXPENSE),
      Category(4, "Transporte", Icons.car_rental, Category.EXPENSE),
      Category(5, "Alimentação", Icons.local_pizza, Category.EXPENSE)
    ];
  }

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