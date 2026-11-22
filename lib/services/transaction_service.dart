import 'package:flutter/material.dart';
import 'package:noya2/dao/transaction_dao.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/model/credit_card.dart';
import 'package:noya2/model/timeline_data.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/services/configuration_service.dart';
import 'package:noya2/services/family_service.dart';
import 'package:noya2/dao/family_dao.dart';

class TransactionService {
  static Future<TransactionRecord?> findById(int id) async {
    return TransactionDao.findById(id);
  }

  static Future<void> save(TransactionRecord transaction, BuildContext context) async {
    final group = await FamilyService.getActiveGroup();
    if (group != null) {
      final ownUuid = await FamilyService.getOwnMemberUuid();
      transaction.authorUuid ??= ownUuid;
      transaction.eventUuid ??= FamilyService.newUuid();
      transaction.syncStatus = transaction.isPrivate ? 'local' : 'pending';
    }

    if (transaction.id == null) {
      transaction.id = await TransactionDao.insert(transaction);
    } else {
      TransactionDao.update(transaction);
    }

    if (context.mounted) {
      await _processInstallments(transaction, context);
    }

    updatePredictions(transaction.category?.type == Category.expense);

    if (group != null && !transaction.isPrivate) {
      await FamilyDao.queueEvent(
        eventUuid: transaction.eventUuid!,
        operation: 'upsert',
      );
    }
  }

  static Future<void> _processInstallments(TransactionRecord transaction, BuildContext context) async {
    
    if (transaction.id != null) {
      TransactionDao.deleteInstallments(transaction);
    }

    if (transaction.creditCard == null) {
      // Payment method is not credit card. No need to insert installments.
      return;
    }

    DateTime billingDate = transaction.creditCard!.getBillingDate(transaction.date!);
    double installmentValue = transaction.value! / transaction.installments!;

    for (var i = 1; i <= transaction.installments!; i++) {
      String installmentLabel = transaction.label!;
      
      if (transaction.installments! > 1 && context.mounted) {
        installmentLabel += AppLocalizations.of(context)!.installment_label_suffix(i);
      }

      double installmentRoundValue = (installmentValue * 100).round() / 100;

      if (installmentRoundValue != installmentValue && i == transaction.installments) {
        installmentRoundValue += 0.01;
      }

      TransactionRecord installment = TransactionRecord(null, installmentLabel, transaction.category,
          transaction.creditCard, installmentRoundValue, billingDate, transaction.createDate, 1, transaction,
          isPrivate: transaction.isPrivate,
          authorUuid: transaction.authorUuid,
          eventUuid: transaction.eventUuid,
          syncStatus: transaction.syncStatus);
      await TransactionDao.insert(installment);

      // Defining the billing date of next installment
      billingDate = DateTime(billingDate.year, billingDate.month + 1, billingDate.day);
    }
  }

  static Future<TimelineData> getTimelineData(DateTime date, String searchTerm) async {
    List<TransactionRecord> transactions = await TransactionDao.getTimelineTransactions(0, 10, searchTerm);
    double expense = await TransactionDao.getTotalMonth(date, Category.expense);
    double revenue = await TransactionDao.getTotalMonth(date, Category.revenue);
    double goal = await ConfigurationService.getGoal() ?? 0;

    TimelineData data = TimelineData(expense, revenue, goal, transactions);
    return data;
  }

  static Future<List<Map<String, dynamic>>> getCurrentMonthExpensesByCategory(DateTime date) {
    return TransactionDao.getCurrentMonthExpensesByCategory(date);
  }

  static Future<List<Map<String, dynamic>>> getExpensesByCategory(DateTime start, DateTime end) {
    return TransactionDao.getExpensesByCategory(start, end);
  }

  static Future<List<Map<String, dynamic>>> getLastYearTotals(DateTime date) {
    return TransactionDao.getLastYearTotals(date);
  }

  static Future<List<Map<String, dynamic>>> getMonthlyTotals(DateTime start, DateTime end, {int? categoryType, int? categoryId}) {
    return TransactionDao.getMonthlyTotals(start, end, categoryType: categoryType, categoryId: categoryId);
  }

  static Future<List<TransactionRecord>> getTimelineTransactions(int offset, int amount, String searchTerm) async {
    return await TransactionDao.getTimelineTransactions(offset, amount, searchTerm);
  }

  static Future<void> delete(TransactionRecord transaction) async {

    if (transaction.id != null) {
      await TransactionDao.delete(transaction);
      if (!transaction.isPrivate && transaction.eventUuid != null) {
        await FamilyDao.queueEvent(
          eventUuid: FamilyService.newUuid(),
          operation: 'delete:${transaction.eventUuid}',
        );
      }
    }
  }

  static Future<List<TransactionRecord>>? getSpreadsheetTransactions(DateTime reference, String searchTerm) {
    return TransactionDao.getSpreadsheetTransactions(reference, searchTerm);
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
