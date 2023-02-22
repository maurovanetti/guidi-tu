import 'package:flutter/material.dart';

import 'game_features.dart';
import 'tracked_state.dart';

mixin GameAware {
  GameFeatures get gameFeatures;
}

abstract class GameSpecificStatefulWidget extends StatefulWidget {
  final GameFeatures gameFeatures;

  const GameSpecificStatefulWidget({super.key, required this.gameFeatures});
}

abstract class GameSpecificState<T extends GameSpecificStatefulWidget>
    extends TrackedState<T> {
  Widget buildPlaceHolder() {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          widget.gameFeatures.name,
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }
}
