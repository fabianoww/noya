import 'package:flutter/material.dart';
import 'package:noya2/components/base_spreadsheet_card.dart';
import 'package:noya2/components/category_spreadsheet_card.dart';
import 'package:noya2/components/transaction_spreadsheet_card.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:noya2/notifiers/refresh_controller.dart';
import 'package:noya2/services/date_service.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:noya2/model/category.dart';
import 'package:provider/provider.dart';

class Spreadsheet extends StatefulWidget {
  final DateTime _date;

  const Spreadsheet(this._date, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _SpreadsheetState();
  }
}

class _SpreadsheetState extends State<Spreadsheet> {
  DateTime? _date;
  int? _rootType;
  Category? _rootCategory;

  _SpreadsheetState();

  @override
  void initState() {
    super.initState();
    _date = widget._date;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RefreshController>(builder: (context, controller, child) {
      return FutureBuilder<List<TransactionRecord>>(
          future: TransactionService.getSpreadsheetTransactions(_date!),
          builder: (BuildContext context, AsyncSnapshot<List<TransactionRecord>> snapshot) {
            if (snapshot.hasData) {
              return ListView(children: buildItemList(snapshot.data!));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          });
    });
  }

  void nextMonth() {
    setState(() {
      _date = DateService.addMonths(_date!, 1);
    });
  }

  void previousMonth() {
    setState(() {
      _date = DateService.subractMonths(_date!, 1);
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
                        Text(DateService.getMonthYearDesc(_date!, AppLocalizations.of(context)!.localeName), style: Theme.of(context).textTheme.headlineMedium))),
            IconButton(
                icon: Icon(Icons.chevron_right, size: 30, color: Theme.of(context).textTheme.headlineMedium!.color),
                onPressed: nextMonth),
          ]))
    ];

    if (_rootType == null && _rootCategory == null) {
      // Show only revenue and expense level
      double revenue = 0.0;
      double expense = 0.0;

      for (var transaction in transactions) {
        if (Category.revenue == transaction.category!.type) {
          revenue += transaction.value!;
        } else {
          expense += transaction.value!;
        }
      }

      items.add(GestureDetector(onTap: onRevenueClick, child: BaseSpreadsheetCard(Category.revenue, revenue)));
      items.add(GestureDetector(onTap: onExpenseClick, child: BaseSpreadsheetCard(Category.expense, expense)));
    } else if (_rootType != null && _rootCategory == null) {
      // Show categories level

      // Back button
      items.add(buildBackButton(null));

      Map mapCategories = {};

      for (var transaction in transactions) {
        if (_rootType == transaction.category!.type) {
          mapCategories.putIfAbsent(transaction.category, () => 0.0);
          mapCategories.update(transaction.category, (currentValue) => currentValue + transaction.value);
        }
      }

      for (var entry in mapCategories.entries) {
        items.add(CategorySpreadsheetCard(entry.key, entry.value, onCategoryClick));
      }
    } else {
      // Show transactions level

      // Back buttons
      items.add(buildBackButton(null));
      items.add(buildBackButton(_rootCategory));

      for (var transaction in transactions) {
        if (transaction.category!.id == _rootCategory!.id) {
          items.add(TransactionSpreadsheetCard(transaction));
        }
      }
    }

    return items;
  }

  Widget buildBackButton(Category? category) {
    String label;

    if (category == null) {
      label = Category.revenue == _rootType ? AppLocalizations.of(context)!.label_revenues : AppLocalizations.of(context)!.label_expenses;
    } else {
      label = category.label!;
    }

    return GestureDetector(
        onTap: () {
          setState(() {
            _rootCategory = null;
            _rootType = category?.type;
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

  void onRevenueClick() {
    setState(() {
      _rootType = Category.revenue;
    });
  }

  void onExpenseClick() {
    setState(() {
      _rootType = Category.expense;
    });
  }

  void onCategoryClick(Category category) {
    setState(() {
      _rootType = category.type;
      _rootCategory = category;
    });
  }
}
