import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextFieldDatePicker extends StatefulWidget {
  final ValueChanged<DateTime>? onDateChanged;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final FocusNode? focusNode;
  final String? labelText;
  final Icon? icon;
  final String locale;

  TextFieldDatePicker({
    super.key,
    this.labelText,
    this.icon,
    this.focusNode,
    required this.lastDate,
    required this.firstDate,
    this.initialDate,
    required this.onDateChanged,
    required this.locale
  })  : assert(firstDate != null),
        assert(lastDate != null),
        assert(initialDate == null || !initialDate.isBefore(firstDate!),
            'initialDate must be on or after firstDate'),
        assert(initialDate == null || !initialDate.isAfter(lastDate!),
            'initialDate must be on or before lastDate'),
        assert(!firstDate!.isAfter(lastDate!),
            'lastDate must be on or after firstDate'),
        assert(onDateChanged != null, 'onDateChanged must not be null');

  @override
  State<TextFieldDatePicker> createState() => _TextFieldDatePickerState();
}

class _TextFieldDatePickerState extends State<TextFieldDatePicker> {
  late TextEditingController _controllerDate;
  late DateFormat _dateFormat;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _dateFormat = DateFormat.yMd(widget.locale);
    _selectedDate = widget.initialDate!;
    _controllerDate = TextEditingController();
    _controllerDate.text = _dateFormat.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: _controllerDate,
      decoration: InputDecoration(
        icon: widget.icon,
        labelText: widget.labelText,
      ),
      onTap: () => _selectDate(context),
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate!,
      lastDate: widget.lastDate!,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controllerDate.text = _dateFormat.format(_selectedDate);
      widget.onDateChanged!(_selectedDate);
    }

    if (widget.focusNode != null) {
      widget.focusNode!.nextFocus();
    }
  }
}
