import 'package:flutter/material.dart';

import 'game_features.dart';

mixin GameAware {
  GameFeatures get gameFeatures;
}

mixin SmallShotAware on GameAware {
  @override
  GameFeatures get gameFeatures => smallShot;
}

mixin LargeShotAware on GameAware {
  @override
  GameFeatures get gameFeatures => largeShot;
}

mixin MorraAware on GameAware {
  @override
  GameFeatures get gameFeatures => morra;
}

abstract class GameSpecificStatefulWidget extends StatefulWidget {
  final GameFeatures gameFeatures;

  const GameSpecificStatefulWidget({super.key, required this.gameFeatures});
}

abstract class GameSpecificState<T extends GameSpecificStatefulWidget>
    extends State<T> {
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
