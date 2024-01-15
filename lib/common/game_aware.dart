import 'package:flutter/material.dart';

import 'game_features.dart';

mixin GameAware {
  GameFeatures get gameFeatures;
}

abstract class GameSpecificStatefulWidget extends StatefulWidget {
  const GameSpecificStatefulWidget({super.key, required this.gameFeatures});

  final GameFeatures gameFeatures;
}
