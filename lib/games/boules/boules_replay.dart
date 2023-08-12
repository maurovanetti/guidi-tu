import 'boules_module.dart';

class BoulesReplay extends BoulesModule {
  BoulesReplay() : super(setReady: (_) {});

  @override
  void init() {
    // No need for new bowl at replay
    // TODO Filter only the best shot per player
  }
}
