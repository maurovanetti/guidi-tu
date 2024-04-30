import 'dart:async';

import 'package:flutter/material.dart';

enum NavigationPushMode {
  push,
  replaceLast,
  replaceAll,
}

typedef WidgetCallback = Widget Function();

class Navigation {
  final BuildContext context;
  final NavigationPushMode mode;
  final WidgetCallback onNavigateToTarget;

  const Navigation._internal(
    this.context, {
    this.mode = NavigationPushMode.push,
    required this.onNavigateToTarget,
  });

  const Navigation.push(BuildContext context, WidgetCallback target)
      : this._internal(context, onNavigateToTarget: target);

  const Navigation.replaceLast(BuildContext context, WidgetCallback target)
      : this._internal(
          context,
          mode: NavigationPushMode.replaceLast,
          onNavigateToTarget: target,
        );

  const Navigation.replaceAll(BuildContext context, WidgetCallback target)
      : this._internal(
          context,
          mode: NavigationPushMode.replaceAll,
          onNavigateToTarget: target,
        );

  void go() {
    final route = MaterialPageRoute(builder: (_) => onNavigateToTarget());
    switch (mode) {
      case NavigationPushMode.push:
        unawaited(Navigator.push(context, route));
        break;

      case NavigationPushMode.replaceLast:
        unawaited(Navigator.pushReplacement(context, route));
        break;

      case NavigationPushMode.replaceAll:
        unawaited(
          Navigator.pushAndRemoveUntil(context, route, (anyRoute) => false),
        );
        break;
    }
  }
}
