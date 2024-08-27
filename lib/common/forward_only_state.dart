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
          title: const Text("Interruzione del gioco"),
          content: const Text(
            "Vuoi davvero interrompere il gioco?\n"
            "Farai una figura da guastafeste!",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(innerContext).pop(),
              child: const Text("Continua a giocare"),
            ),
            TextButton(
              onPressed: Navigation.replaceAll(
                innerContext,
                () => const TitleScreen(),
              ).go,
              child: const Text("Ferma tutto"),
            ),
          ],
        ),
      ),
    );
  }
}
