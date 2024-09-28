import 'dart:async';

import 'package:flutter/material.dart';

import 'common.dart';

class Clock extends StatefulWidget {
  const Clock(this.startTime, {super.key});

  final DateTime startTime;

  @override
  createState() => ClockState();
}

class ClockState extends State<Clock> with Localized {
  late Timer _timer;

  Duration _duration = Duration.zero;

  @override
  initState() {
    super.initState();
    _untilNextSecond();
  }

  void _untilNextSecond() {
    int targetMicro = widget.startTime.microsecondsSinceEpoch;
    int currentMicro = DateTime.now().microsecondsSinceEpoch;
    int diffMicro = (targetMicro - currentMicro) % 1000000;
    _timer = Timer(
      Duration(microseconds: diffMicro),
      _handleNewSecond,
    );
  }

  void _handleNewSecond() {
    setState(() {
      _duration = DateTime.now().difference(widget.startTime);
    });
    // To check the error in microseconds, uncomment this line:
    // debugPrint((_duration.inMicroseconds * 1e-6).toString());
    // It's always below 0.1 seconds in emulator tests
    _untilNextSecond();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        $.elapsedTime(_duration.inSeconds),
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
