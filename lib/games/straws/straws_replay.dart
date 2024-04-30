import 'package:flame/components.dart';

import 'straws_module.dart';
import 'straws_straw.dart';

class StrawsReplay extends StrawsModule {
  final List<Map<String, dynamic>> strawsToDisplay;
  StrawsReplay(this.strawsToDisplay)
      : super(onChangeReady: ({bool ready = true}) {});

  @override
  List<StrawsStraw> retrieveStraws({required Sprite sprite}) {
    List<StrawsStraw> straws = [];
    for (var strawSetup in strawsToDisplay) {
      var straw = StrawsStraw.fromJson(strawSetup, sprite);
      straws.add(straw);
    }
    return straws;
  }

  @override
  void init() {
    // Don't pick any straw at start
  }
}
