import 'package:flutter/material.dart';

import 'game_features.dart';
import 'tracked_state.dart';

mixin GameAware {
  GameFeatures get gameFeatures;
}

abstract class GameSpecificStatefulWidget extends StatefulWidget {
  const GameSpecificStatefulWidget({super.key, required this.gameFeatures});

  final GameFeatures gameFeatures;
}

abstract class GameSpecificState<T extends GameSpecificStatefulWidget>
    extends TrackedState<T> {
  final placeHolderWidget = Container(
    color: Colors.blue,
    child: const Center(
      child: Text(
        "Not yet implemented",
        style: TextStyle(fontSize: 48),
      ),
    ),
  );
}
