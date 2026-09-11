import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isSelected;

  const CategoryIcon({required this.icon, required this.isSelected, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
              icon: Icon(icon),
              color: isSelected
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).disabledColor,
              onPressed: onPressed);
  }
}
