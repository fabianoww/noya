import 'package:noya2/dao/configuration_dao.dart';
import 'package:noya2/model/backup_config_data.dart';
import 'package:noya2/model/prediction_config_data.dart';
import 'package:noya2/services/date_service.dart';

class ConfigurationService {
  /*
  static Future<bool> isThemeDark() async {
    String theme = await ConfigurationDao.getConfigValue('theme');
    return theme == Themes.darkThemeKey;
  }
  */
  static void saveThemeConfiguration(String themeKey) async {
    ConfigurationDao.saveThemeConfiguration(themeKey);
  }

  static Future<double?> getGoal() async {
    String? goal = await ConfigurationDao.getConfigValue('goal');
    return goal == null ? null : double.parse(goal);
  }

  static Future<String?> getConfigValue(String key) async {
    return ConfigurationDao.getConfigValue(key);
  }

  static void saveGoalConfiguration(double goal) async {
    ConfigurationDao.saveGoalConfiguration(goal);
  }

  static Future<BackupConfigData> getBackupConfig() async {
    String? backupMode = await ConfigurationDao.getConfigValue('backupMode');
    String? lastBackup = await ConfigurationDao.getConfigValue('lastBackup');

    return BackupConfigData(backupMode,
        lastBackup == null ? null : DateService.parseFromStorage(lastBackup));
  }

  static Future<bool> isPredictionEnabled() async {
    String? predictionEnabledStr =
        await ConfigurationService.getConfigValue('prediction_enabled');

    if (predictionEnabledStr == null) {
      // No configuration set for autofill. Default is 'active'.
      ConfigurationService.savePredictionConfiguration(true);
      ConfigurationService.savePredictionWindow(100);
      return true;
    } else {
      return predictionEnabledStr == 'true';
    }
  }

  static void savePredictionConfiguration(bool enabled) async {
    ConfigurationDao.savePredictionConfiguration(enabled);
  }

  static void savePredictionWindow(int predictionWindow) async {
    ConfigurationDao.savePredictionWindow(predictionWindow);
  }

  static void savePredictedExpenseLabel(String? label) async {
    ConfigurationDao.savePredictedExpenseLabel(label);
  }

  static void savePredictedExpenseCategory(String? categoryId) async {
    ConfigurationDao.savePredictedExpenseCategory(categoryId);
  }

  static void savePredictedExpenseCreditCard(String? creditCardId) async {
    ConfigurationDao.savePredictedExpenseCreditCard(creditCardId);
  }

  static void savePredictedRevenueLabel(String? label) async {
    ConfigurationDao.savePredictedRevenueLabel(label);
  }

  static void savePredictedRevenueCategory(String? categoryId) async {
    ConfigurationDao.savePredictedRevenueCategory(categoryId);
  }

  static Future<PredictionConfigData> getPredictionConfig() async {
    String? predictionEnabledStr =
        await ConfigurationDao.getConfigValue('prediction_enabled');
    String? predictionWindowStr =
        await ConfigurationDao.getConfigValue('prediction_window');

    return PredictionConfigData(
        predictionEnabledStr == null ? true : predictionEnabledStr == 'true',
        int.tryParse(predictionWindowStr!));
  }
}
