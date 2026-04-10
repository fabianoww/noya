import 'package:flutter/material.dart';
import 'package:noya2/components/horizontal_divider.dart';
import 'package:noya2/components/timeline_bar.dart';
import 'package:noya2/components/transaction_card.dart';
import 'package:noya2/l10n/app_localizations.dart';
import 'package:noya2/model/timeline_data.dart';
import 'package:noya2/notifiers/refresh_controller.dart';
import 'package:noya2/services/date_service.dart';
import 'package:noya2/services/transaction_service.dart';
import 'package:provider/provider.dart';

class Timeline extends StatefulWidget {
  DateTime _date;

  Timeline(this._date);

  @override
  State<StatefulWidget> createState() {
    if (this._date == null) {
      this._date = new DateTime.now();
    }
    return _TimelineState(this._date);
  }
}

class _TimelineState extends State<Timeline> {
  DateTime _date;

  _TimelineState(this._date);

  @override
  Widget build(BuildContext context) {
    return Consumer<RefreshController>(builder: (context, controller, child) {
      return FutureBuilder<TimelineData>(
        future: TransactionService.getTimelineData(_date),
        builder: (BuildContext context, AsyncSnapshot<TimelineData> snapshot) {
          if (snapshot.hasData) {
            List<Widget> items = [
              Padding(
                  padding: EdgeInsets.all(10),
                  child:
                      Center(child: Text(DateService.getMonthDesc(_date), style: Theme.of(context).textTheme.headlineMedium))),
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: TimelineBar(snapshot.data!.revenuePercentage, snapshot.data!.revenue, TimelineBar.REVENUE)),
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: TimelineBar(snapshot.data!.expensePercentage, snapshot.data!.expense, TimelineBar.EXPENSE)),
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: TimelineBar(snapshot.data!.goalPercentage, snapshot.data!.goal, TimelineBar.GOAL)),
              HorizontalDivider(AppLocalizations.of(context)!.navbar_ultimasTransacoes)
            ];
            for (var i = 0; i < snapshot.data!.transactions.length; i++) {
              items.add(TransactionCard(snapshot.data!.transactions[i]));
            }
            items.add(Container(height: 50));
            return ListView(children: items);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '😄',
                  style: TextStyle(fontSize: 48),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    AppLocalizations.of(context)!.text_welcome,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    AppLocalizations.of(context)!.text_orientation,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            );
          }
        },
      );
    });
  }
}
