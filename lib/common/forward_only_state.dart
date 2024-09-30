import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

import '../screens/title_screen.dart';
import 'game_aware.dart';
import 'navigation.dart';
import 'tracked_state.dart';

abstract class ForwardOnlyState<T extends GameSpecificStatefulWidget>
    extends TrackedState<T> {
  @override
  initState() {
    super.initState();
    BackButtonInterceptor.add(_tryInterceptBackButton);
  }

  FutureOr<bool> _tryInterceptBackButton(bool _, RouteInfo __) {
    handleQuit();
    return false;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_tryInterceptBackButton);
    super.dispose();
  }

  void handleQuit() {
    unawaited(
      showDialog(
        context: context,
        builder: (innerContext) => AlertDialog(
          title: Text($.quitTitle),
          content: Text($.quitMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(innerContext).pop(),
              child: Text($.quitCancel),
            ),
            TextButton(
              onPressed: Navigation.replaceAll(
                innerContext,
                () => const TitleScreen(),
              ).go,
              child: Text($.quitConfirm),
            ),
          ],
        ),
      ),
    );
  }
}
