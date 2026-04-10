import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noya2/components/base_spreadsheet_card.dart';
import 'package:noya2/components/category_spreadsheet_card.dart';
import 'package:noya2/components/loading_spinner.dart';
import 'package:noya2/components/transaction_spreadsheet_card.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:noya2/notifiers/refresh_controller.dart';
import 'package:noya2/services/date_service.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:noya2/model/category.dart';
import 'package:provider/provider.dart';

class Spreadsheet extends StatefulWidget {
  DateTime _date;

  Spreadsheet(this._date);

  @override
  State<StatefulWidget> createState() {
    if (this._date == null) {
      this._date = new DateTime.now();
    }
    return _SpreadsheetState(this._date);
  }
}

class _SpreadsheetState extends State<Spreadsheet> {
  late DateTime? _date;
  late int? _rootType;
  late Category? _rootCategory;

  _SpreadsheetState(this._date);

  @override
  Widget build(BuildContext context) {
    return Consumer<RefreshController>(builder: (context, controller, child) {
      return FutureBuilder<List<TransactionRecord>>(
          future: TransactionService.getSpreadsheetTransactions(this._date!),
          builder: (BuildContext context, AsyncSnapshot<List<TransactionRecord>> snapshot) {
            if (snapshot.hasData) {
              return ListView(children: buildItemList(snapshot.data!));
            } else {
              return LoadingSpinner();
            }
          });
    });
  }

  void nextMonth() {
    setState(() {
      this._date = DateService.addMonths(this._date!, 1);
    });
  }

  void previousMonth() {
    setState(() {
      this._date = DateService.subractMonths(this._date!, 1);
    });
  }

  List<Widget> buildItemList(List<TransactionRecord> transactions) {
    List<Widget> items = [
      Padding(
          padding: EdgeInsets.all(10),
          child: Row(children: [
            IconButton(
                icon: Icon(Icons.chevron_left, size: 30, color: Theme.of(context).textTheme.headlineMedium!.color),
                onPressed: previousMonth),
            Expanded(
                child: Center(
                    child:
                        Text(DateService.getMonthYearDesc(this._date!), style: Theme.of(context).textTheme.headlineMedium))),
            IconButton(
                icon: Icon(Icons.chevron_right, size: 30, color: Theme.of(context).textTheme.headlineMedium!.color),
                onPressed: nextMonth),
          ]))
    ];

    if (this._rootType == null && this._rootCategory == null) {
      // Show only revenue and expense level
      double revenue = 0.0;
      double expense = 0.0;

      for (var transaction in transactions) {
        if (Category.REVENUE == transaction.category!.type) {
          revenue += transaction.value!;
        } else {
          expense += transaction.value!;
        }
      }

      items.add(GestureDetector(child: BaseSpreadsheetCard(Category.REVENUE, revenue), onTap: onRevenueClick));
      items.add(GestureDetector(child: BaseSpreadsheetCard(Category.EXPENSE, expense), onTap: onExpenseClick));
    } else if (this._rootType != null && this._rootCategory == null) {
      // Show categories level

      // Back button
      items.add(buildBackButton(null));

      Map mapCategories = new Map();

      for (var transaction in transactions) {
        if (this._rootType == transaction.category!.type) {
          mapCategories.putIfAbsent(transaction.category, () => 0.0);
          mapCategories.update(transaction.category, (currentValue) => currentValue + transaction.value);
        }
      }

      for (var entry in mapCategories.entries) {
        items.add(CategorySpreadsheetCard(entry.key, entry.value, onCategoryClick)); // FIXME
      }
    } else {
      // Show transactions level

      // Back buttons
      items.add(buildBackButton(null));
      items.add(buildBackButton(this._rootCategory));

      for (var transaction in transactions) {
        if (transaction.category!.id == this._rootCategory!.id) {
          items.add(TransactionSpreadsheetCard(transaction));
        }
      }
    }

    return items;
  }

  Widget buildBackButton(Category? category) {
    String label;

    if (category == null) {
      label = Category.REVENUE == this._rootType ? AppLocalizations.of(context)!.label_revenues : AppLocalizations.of(context)!.label_expenses;
    } else {
      label = category.label!;
    }

    return GestureDetector(
        onTap: () {
          setState(() {
            this._rootCategory = null;
            this._rootType = category == null ? null : category.type;
          });
        },
        child: Row(children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.chevron_left,
                  size: Theme.of(context).textTheme.headlineMedium!.fontSize,
                  color: Theme.of(context).textTheme.headlineMedium!.color)),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.headlineMedium))
        ]));
  }

  onRevenueClick() {
    setState(() {
      this._rootType = Category.REVENUE;
    });
  }

  onExpenseClick() {
    setState(() {
      this._rootType = Category.EXPENSE;
    });
  }

  onCategoryClick(Category category) {
    setState(() {
      this._rootType = category.type;
      this._rootCategory = category;
    });
  }
}
