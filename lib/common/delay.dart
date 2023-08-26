import 'dart:async';

class Delay {
  static void after(num seconds, [FutureOr<void> Function()? callback]) {
    unawaited(waitFor(seconds, callback));
  }

  static Future<void> waitFor(
    num seconds, [
    FutureOr<void> Function()? callback,
  ]) {
    return Future.delayed(
      Duration(
        milliseconds: (Duration.millisecondsPerSecond * seconds).toInt(),
      ),
      callback,
    );
  }

  static void atNextFrame(FutureOr<void> Function() callback) {
    after(0, callback);
  }
}
