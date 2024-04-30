import 'package:flame/components.dart';

import '../flame/custom_sprite_component.dart';
import '../flame/priorities.dart';
import 'ouija_board.dart';

class OuijaFrame extends CustomSpriteComponent {
  static const pauseAtLetter = 0.2;
  static const pauseAtCenter = 1.0;
  static const speed = 500.0;

  final OuijaBoard board;
  final path = <Vector2>[];
  String _nextLetter = '';
  Vector2? _nextDestination;
  Timer? _timer;

  OuijaFrame(this.board, {required Vector2 size})
      : super(
          'ouija/frame.png',
          board.absoluteCenter,
          size: size,
          priority: Priorities.toolPriority,
          hasShadow: false,
        ) {
    _handleNextStep();
  }

  @override
  void onRemove() {
    _timer?.stop();
    super.onRemove();
  }

  @override
  void update(double dt) {
    if (_timer?.isRunning() ?? false) {
      _timer?.update(dt);
    } else if (_nextDestination != null) {
      var ds = speed * dt;
      var dp = _nextDestination! - position;
      if (dp.length < ds) {
        position = _nextDestination!;
        double pauseDuration =
            position == board.absoluteCenter ? pauseAtCenter : pauseAtLetter;
        _timer = Timer(pauseDuration, onTick: _handleNextStep)..start();
      } else {
        position += dp.normalized() * ds;
      }
    }
    super.update(dt);
  }

  void _handleNextStep() {
    if (_nextLetter.isEmpty) {
      _goTo(board.absoluteCenter);
      if (board.word.isNotEmpty) {
        _nextLetter = board.word[0];
      }
    } else {
      int index = board.word.indexOf(_nextLetter);
      _goTo(board.spotOf(_nextLetter) ?? board.absoluteCenter);
      index++;
      _nextLetter = index < board.word.length ? board.word[index] : '';
    }
    // _timer = Timer(stepDuration, onTick: _nextStep)..start();
  }

  void _goTo(Vector2 destination) {
    _nextDestination = destination;
  }
}
