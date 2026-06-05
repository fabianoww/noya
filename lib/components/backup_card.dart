import 'package:flutter/material.dart';

class BackupCard extends StatelessWidget {
  final String _title;
  final IconData _icon;
  final VoidCallback _callback;

  const BackupCard(this._title, this._icon, this._callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _callback,
        child: Row(children: [
          Expanded(
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(children: [
                        Icon(_icon, size: 50),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            _title,
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ))
                      ]))))
        ]));
  }
}
