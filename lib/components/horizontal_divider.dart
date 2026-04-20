
import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  
  final String _label;

  const HorizontalDivider(this._label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                height: 36,
              )),
        ),
        Text(_label),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                height: 36,
              )),
        ),
      ]);
  }

}