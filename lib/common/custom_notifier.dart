mixin CustomNotifier {
  final _listeners = <void Function()>[];

  void addListener(void Function() notify) {
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
