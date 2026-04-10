
import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  
  late String _label;

  HorizontalDivider(String label) {
    this._label = label;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                height: 36,
              )),
        ),
        Text(this._label),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                height: 36,
              )),
        ),
      ]);
  }

}