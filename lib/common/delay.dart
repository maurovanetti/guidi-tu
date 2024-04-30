import 'dart:async';

import 'common.dart';

class Delay {
  static void after(num seconds, [AsyncCallback? callback]) {
    unawaited(waitFor(seconds, callback));
  }

  static Future<void> waitFor(
    num seconds, [
    AsyncCallback? callback,
  ]) {
    return Future.delayed(
      Duration(
        milliseconds: (Duration.millisecondsPerSecond * seconds).toInt(),
      ),
      callback,
    );
  }

  static void atNextFrame(AsyncCallback callback) {
    after(0, callback);
  }
}
