import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noya2/components/category_icon.dart';

class CategoryIconGrid extends StatefulWidget {
  final ValueListenable<List<CategoryIcon>>? listener;

  const CategoryIconGrid({required this.listener, super.key});

  @override
  State<StatefulWidget> createState() {
    return _CategoryIconGridState();
  }
}

class _CategoryIconGridState extends State<CategoryIconGrid> {
  late ValueListenable<List<CategoryIcon>> _listener;

  @override
  void initState() {
    super.initState();
    _listener = widget.listener!;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _listener,
      builder:
          (BuildContext context, List<CategoryIcon> iconList, Widget? child) {
            return GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 50,
              children: iconList,
            );
          },
    );
  }
}
