import 'package:flutter/material.dart';

enum NavigationPushMode {
  push,
  replaceLast,
  replaceAll,
}

class Navigation {
  final BuildContext context;
  final NavigationPushMode mode;
  final Widget Function() target;

  const Navigation._internal(this.context,
      {this.mode = NavigationPushMode.push, required this.target});
  const Navigation.push(BuildContext context, Widget Function() target)
      : this._internal(context, mode: NavigationPushMode.push, target: target);
  const Navigation.replaceLast(BuildContext context, Widget Function() target)
      : this._internal(context,
            mode: NavigationPushMode.replaceLast, target: target);
  const Navigation.replaceAll(BuildContext context, Widget Function() target)
      : this._internal(context,
            mode: NavigationPushMode.replaceAll, target: target);

  void go() {
    final route = MaterialPageRoute(builder: (_) => target());
    switch (mode) {
      case NavigationPushMode.push:
        debugPrint("Navigation action (push)");
        Navigator.push(context, route);
        break;
      case NavigationPushMode.replaceLast:
        debugPrint("Navigation action (replace last)");
        Navigator.pushReplacement(context, route);
        break;
      case NavigationPushMode.replaceAll:
        debugPrint("Navigation action (replace all)");
        Navigator.pushAndRemoveUntil(context, route, (anyRoute) => false);
        break;
    }
  }
}
