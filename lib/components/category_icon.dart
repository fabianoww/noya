import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryIcon extends StatefulWidget {
  final IconData icon;
  final ValueListenable<IconData>? listener;
  final VoidCallback? onPressed;

  const CategoryIcon({required this.icon, this.listener, this.onPressed, super.key});

  @override
  State<StatefulWidget> createState() {
    return _CategoryIconState();
  }
}

class _CategoryIconState extends State<CategoryIcon> {
  late IconData _icon;
  late VoidCallback _onPressed;
  late ValueListenable<IconData> _listener;

  @override
  void initState() {
    super.initState();
    _icon = widget.icon; 
    _listener = widget.listener!; 
    _onPressed = widget.onPressed!;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _listener,
        builder: (BuildContext context, IconData icon, Widget? child) {
          return IconButton(
              icon: Icon(_icon),
              color: _icon == icon
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).disabledColor,
              onPressed: _onPressed);
        });
  }
}
