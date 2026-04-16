import 'package:flutter/material.dart';
import 'package:noya2/dao/transaction_dao.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/model/credit_card.dart';
import 'package:noya2/model/timeline_data.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/services/configuration_service.dart';

class TransactionService {
  static Future<TransactionRecord?> findById(int id) async {
    return TransactionDao.findById(id);
  }

  static Future<void> save(TransactionRecord transaction, BuildContext context) async {
    if (transaction != null) {
      if (transaction.id == null) {
        transaction.id = await TransactionDao.insert(transaction);
      } else {
        TransactionDao.update(transaction);
      }

      await _processInstallments(transaction, context);
      updatePredictions(transaction.category?.type == Category.EXPENSE);
    }

    return null;
  }

  static Future<void> _processInstallments(TransactionRecord transaction, BuildContext context) async {
    
    if (transaction != null && transaction.id != null) {
      TransactionDao.deleteInstallments(transaction);
    }

    if (transaction.creditCard == null) {
      // Payment method is not credit card. No need to insert installments.
      return null;
    }

    DateTime billingDate = transaction.creditCard!.getBillingDate(transaction.date!);
    double installmentValue = transaction.value! / transaction.installments!;

    for (var i = 1; i <= transaction.installments!; i++) {
      String installmentLabel = transaction.label!;
      
      if (transaction.installments! > 1) {
        installmentLabel += AppLocalizations.of(context)!.installment_label_suffix(i);
      }

      double installmentRoundValue = (installmentValue * 100).round() / 100;

      if (installmentRoundValue != installmentValue && i == transaction.installments) {
        installmentRoundValue += 0.01;
      }

      TransactionRecord installment = TransactionRecord(null, installmentLabel, transaction.category,
          transaction.creditCard, installmentRoundValue, billingDate, transaction.createDate, 1, transaction);
      await TransactionDao.insert(installment);

      // Defining the billing date of next installment
      billingDate = DateTime(billingDate.year, billingDate.month + 1, billingDate.day);
    }

    return null;
  }

  static Future<TimelineData> getTimelineData(DateTime date) async {
    List<TransactionRecord> transactions = await TransactionDao.getTimelineTransactions(0, 10);
    double expense = await TransactionDao.getTotalMonth(date, Category.EXPENSE);
    double revenue = await TransactionDao.getTotalMonth(date, Category.REVENUE);
    double goal = await ConfigurationService.getGoal() ?? 0;

    TimelineData data = TimelineData(expense, revenue, goal, transactions);
    return data;
  }

  static Future<void> delete(TransactionRecord transaction) async {

    if (transaction != null && transaction.id != null) {
      return TransactionDao.delete(transaction);
    }

    return null;
  }

  static Future<List<TransactionRecord>>? getSpreadsheetTransactions(DateTime reference) {
    
    if (reference != null) {
      return TransactionDao.getSpreadsheetTransactions(reference);
    }

    return null;
  }

  static Future<void> updatePredictions(bool isExpense) async {
    
    String? predictionWindowStr = await ConfigurationService.getConfigValue('prediction_window');
    int? predictionWindow = 100;

    if (predictionWindowStr == null) {
      ConfigurationService.savePredictionWindow(predictionWindow);
    }
    else {
      predictionWindow = int.tryParse(predictionWindowStr);
      if (predictionWindow == null) {
        predictionWindow = 100;
        ConfigurationService.savePredictionWindow(predictionWindow);
      }
    }

    if (isExpense) {
      ConfigurationService.savePredictedExpenseLabel(await TransactionDao.getPredictedExpenseLabel(predictionWindow));
      ConfigurationService.savePredictedExpenseCategory(await TransactionDao.getPredictedExpenseCategory(predictionWindow));
      ConfigurationService.savePredictedExpenseCreditCard(await TransactionDao.getPredictedExpenseCreditCard(predictionWindow));
    }
    else {
      ConfigurationService.savePredictedRevenueLabel(await TransactionDao.getPredictedRevenueLabel(predictionWindow));
      ConfigurationService.savePredictedRevenueCategory(await TransactionDao.getPredictedRevenueCategory(predictionWindow));
    }
  }

  static Future<int> getTransactionsCountByCategory(Category category) async {
    if (category.id != null) {
      return TransactionDao.getTransactionsCountByCategory(category);
    }

    return 0;
  }

  static Future<int> getTransactionsCountByCreditCard(CreditCard creditCard) async {
    if (creditCard.id != null) {
      return TransactionDao.getTransactionsCountByCreditCard(creditCard);
    }

    return 0;
  }
}
