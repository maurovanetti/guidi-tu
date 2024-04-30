import 'package:flutter/foundation.dart';

mixin CustomNotifier {
  final _listeners = <VoidCallback>[];

  void addListener(VoidCallback notify) {
    _listeners.add(notify);
  }

  void clearListeners() {
    _listeners.clear();
  }

  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }
}
