import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class RefreshController implements Listenable {
  final LinkedList<_ListenerEntry> _listeners = LinkedList<_ListenerEntry>();

  @override
  void addListener(void Function() listener) {
    _listeners.add(_ListenerEntry(listener));
  }

  @override
  void removeListener(void Function() listener) {
    for (final _ListenerEntry entry in _listeners) {
      if (entry.listener == listener) {
        entry.unlink();
        return;
      }
    }
  }

  void notifyListeners() {
    for (var entry in _listeners) {
      entry.listener();
    }
  }
}

base class _ListenerEntry extends LinkedListEntry<_ListenerEntry> {
  _ListenerEntry(this.listener);
  final VoidCallback listener;
}
