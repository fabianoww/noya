import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:noya2/activities/transaction_form.dart';
import 'package:noya2/model/category.dart';
import 'package:noya2/notifiers/refresh_controller.dart';
import 'package:noya2/styles/custom_color_scheme.dart';
import 'package:provider/provider.dart';

class NoyaFab extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _NoyaFabState();
}

class _NoyaFabState extends State<NoyaFab> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children:
          //new List.generate(icons.length, (int index) {
          [
        new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve:
                  new Interval(0.0, 1.0 - 0 / 2 / 2.0, curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).colorScheme.revenueColor,
              mini: true,
              child: new Icon(Icons.trending_up),
              onPressed: () {
                this._controller.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return TransactionForm(Category.REVENUE);
                  }),
                ).then((value) {
                  Provider.of<RefreshController>(context, listen: false).notifyListeners();
                });
              },
            ),
          ),
        ),
        new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve:
                  new Interval(0.0, 1.0 - 1 / 2 / 2.0, curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).colorScheme.expensecolor,
              mini: true,
              child: new Icon(Icons.trending_down),
              onPressed: () {
                this._controller.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return TransactionForm(Category.EXPENSE);
                  }),
                ).then((value) {
                  Provider.of<RefreshController>(context, listen: false).notifyListeners();
                });
              },
            ),
          ),
        )
      ]..add(
              new FloatingActionButton(
                heroTag: null,
                child: new AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget? child) {
                    return new Transform(
                      transform: new Matrix4.rotationZ(
                          _controller.value * 0.5 * math.pi),
                      alignment: FractionalOffset.center,
                      child: new Icon(
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
              ),
            ),
    );
  }
}
