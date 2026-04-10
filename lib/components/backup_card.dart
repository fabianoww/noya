import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackupCard extends StatelessWidget {
  String _title;
  IconData _icon;
  VoidCallback _callback;

  BackupCard(this._title, this._icon, this._callback);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: this._callback,
        child: Row(children: [
          Expanded(
              child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(children: [
                        Icon(this._icon, size: 50),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            this._title,
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ))
                      ]))))
        ]));
  }
}
