import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryIcon extends StatefulWidget {
  final IconData icon;
  final ValueListenable<IconData>? listener;
  final VoidCallback? onPressed;

  const CategoryIcon({required this.icon, this.listener, this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return _CategoryIconState(this.icon, this.listener!, this.onPressed!);
  }
}

class _CategoryIconState extends State<CategoryIcon> {
  IconData _icon;
  VoidCallback _onPressed;
  ValueListenable<IconData> _listener;
  bool _selected = false;

  _CategoryIconState(this._icon, this._listener, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: this._listener,
        builder: (BuildContext context, IconData icon, Widget? child) {
          return IconButton(
              icon: Icon(this._icon),
              color: this._icon == icon
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).disabledColor,
              onPressed: this._onPressed);
        });
  }
}
