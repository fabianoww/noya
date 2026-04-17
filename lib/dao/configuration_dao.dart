import 'package:noya2/dao/noya_database.dart';

class ConfigurationDao {

  static Future<String?> getConfigValue(String key) async {
    final db = await NoyaDatabase.getInstance();
    List<Map> maps = await db.query('configuration',
        columns: ['value'], where: 'key = ?', whereArgs: [key]);
    return maps.length > 0 ? maps.first['value'].toString() : null;
  }
  
  static saveThemeConfiguration(String themeKey) async {
    final db = await NoyaDatabase.getInstance();
    int changes = await db.update('configuration', {'value': themeKey}, where: 'key = ?', whereArgs: ['theme']);

    if (changes == 0 && themeKey != null && themeKey.trim() != '') {
      // Theme configuration don't exists yet
      db.insert('configuration', {'key': 'theme', 'value': themeKey});
    }
  }
/*
  static Future<double> getGoal() async {
    final db = await NoyaDatabase.getInstance();
    List<Map> maps = await db.query('configuration',
        columns: ['value'], where: 'key = ?', whereArgs: ['goal']);
    return maps.length > 0 ? double.parse(maps.first['value']) : 0;
  }

  static Future<BackupConfigData> getBackupConfig() async {
    final db = await NoyaDatabase.getInstance();
    List<Map> maps = await db.query('configuration',
        columns: ['value'], where: 'key = ?', whereArgs: ['goal']);

    return BackupConfigData();
    //return maps.length > 0 ? double.parse(maps.first['value']) : 0;
  }
  */
  
  static saveGoalConfiguration(double goal) async {
    final db = await NoyaDatabase.getInstance();
    int changes = await db.update('configuration', {'value': goal.toString()}, where: 'key = ?', whereArgs: ['goal']);

    if (changes == 0) {
      // Goal configuration don't exists yet
      db.insert('configuration', {'key': 'goal', 'value': goal.toString()});
    }
  }
  
  static savePredictionConfiguration(bool enabled) async {
    final db = await NoyaDatabase.getInstance();

    var check = await db.query('configuration', where: 'key = ?', whereArgs: ['prediction_enabled']);
    
    if (check.isNotEmpty) {
      // Prediction configuration already exists
      await db.update('configuration', {'value': enabled.toString()}, where: 'key = ?', whereArgs: ['prediction_enabled']);
    } else {
      // Prediction configuration don't exists yet
      await db.insert('configuration', {'key': 'prediction_enabled', 'value': enabled.toString()});
    }
  }
  
  static savePredictionWindow(int predictionWindow) async {
    final db = await NoyaDatabase.getInstance();
    int changes = await db.update('configuration', {'value': predictionWindow.toString()}, where: 'key = ?', whereArgs: ['prediction_window']);

    if (changes == 0) {
      // Goal configuration don't exists yet
      db.insert('configuration', {'key': 'prediction_window', 'value': predictionWindow.toString()});
    }
  }
  
  static savePredictedExpenseLabel(String? label) async {

    final db = await NoyaDatabase.getInstance();
    int changes = await db.update('configuration', {'value': label}, where: 'key = ?', whereArgs: ['predicted_exp_label']);

    if (changes == 0) {
      // Goal configuration don't exists yet
      db.insert('configuration', {'key': 'predicted_exp_label', 'value': label});
    }
  }
  
  static savePredictedExpenseCategory(String? categoryId) async {

    final db = await NoyaDatabase.getInstance();
    int changes = await db.update('configuration', {'value': categoryId}, where: 'key = ?', whereArgs: ['predicted_exp_category']);

    if (changes == 0) {
      // Goal configuration don't exists yet
      db.insert('configuration', {'key': 'predicted_exp_category', 'value': categoryId});
    }
  }
  
  static savePredictedExpenseCreditCard(String? creditCardId) async {

    final db = await NoyaDatabase.getInstance();
    int changes = await db.update('configuration', {'value': creditCardId}, where: 'key = ?', whereArgs: ['predicted_exp_credit_card']);

    if (changes == 0) {
      // Goal configuration don't exists yet
      db.insert('configuration', {'key': 'predicted_exp_credit_card', 'value': creditCardId});
    }
  }
  
  static savePredictedRevenueLabel(String? label) async {

    final db = await NoyaDatabase.getInstance();
    int changes = await db.update('configuration', {'value': label}, where: 'key = ?', whereArgs: ['predicted_rev_label']);

    if (changes == 0) {
      // Goal configuration don't exists yet
      db.insert('configuration', {'key': 'predicted_rev_label', 'value': label});
    }
  }
  
  static savePredictedRevenueCategory(String? categoryId) async {

    final db = await NoyaDatabase.getInstance();
    int changes = await db.update('configuration', {'value': categoryId}, where: 'key = ?', whereArgs: ['predicted_rev_category']);

    if (changes == 0) {
      // Goal configuration don't exists yet
      db.insert('configuration', {'key': 'predicted_rev_category', 'value': categoryId});
    }
  }

}
