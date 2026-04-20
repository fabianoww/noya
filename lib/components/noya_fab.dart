import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:noya2/activities/transaction_form.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/model/transaction_record.dart';
import 'package:noya2/notifiers/refresh_controller.dart';
import 'package:noya2/styles/custom_color_scheme.dart';
import 'package:provider/provider.dart';

class NoyaFab extends StatefulWidget {

  const NoyaFab({super.key});

  @override
  State<StatefulWidget> createState() => _NoyaFabState();
}

class _NoyaFabState extends State<NoyaFab> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          //new List.generate(icons.length, (int index) {
          [
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve:
                  Interval(0.0, 1.0 - 0 / 2 / 2.0, curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).colorScheme.revenueColor,
              mini: true,
              child: Icon(Icons.trending_up),
              onPressed: () {
                _controller.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return TransactionForm(Category.revenue, TransactionRecord(null, null, null, null, null, DateTime.now(), null, 1, null));
                  }),
                ).then((value) {
                  if (context.mounted) {
                    Provider.of<RefreshController>(context, listen: false).notifyListeners();
                  }
                });
              },
            ),
          ),
        ),
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve:
                  Interval(0.0, 1.0 - 1 / 2 / 2.0, curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).colorScheme.expensecolor,
              mini: true,
              child: Icon(Icons.trending_down),
              onPressed: () {
                _controller.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return TransactionForm(Category.expense, TransactionRecord(null, null, null, null, null, DateTime.now(), null, 1, null));
                  }),
                ).then((value) {
                  if (context.mounted) {
                    Provider.of<RefreshController>(context, listen: false).notifyListeners();
                  }
                });
              },
            ),
          ),
        ), 
        FloatingActionButton(
          heroTag: null,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Transform(
                transform: Matrix4.rotationZ(
                    _controller.value * 0.5 * math.pi),
                alignment: FractionalOffset.center,
                child: Icon(
                    _controller.isDismissed ? Icons.add : Icons.close),
              );
            },
          ),
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
        )
      ],
    );
  }
}
