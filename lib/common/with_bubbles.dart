import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '/main.dart';

class WithBubbles extends StatelessWidget {
  static bool _enabled = true; // Disabled in tests.
  set enabled(bool value) => _enabled = value;

  const WithBubbles({
    super.key,
    required this.child,
    this.n = 10,
    this.behind = false,
  });

  final Widget child;
  final int n;
  final bool behind;

  get square => false;

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return child;

    return Stack(
      children: [
        if (!behind) child,
        ...List.generate(n, (index) => Bubble(square: square)),
        if (behind) child,
      ],
    );
  }
}

class WithSquares extends WithBubbles {
  @override
  get square => true;

  const WithSquares({
    super.key,
    required super.child,
    super.n = 10,
    super.behind = true,
  });
}

class Bubble extends StatefulWidget {
  Bubble({super.key, this.square = false});

  final phase = Random().nextDouble();
  final radius = Random().nextDouble() * 100 + 50;
  final xFactor = Random().nextDouble();
  final bool square;

  @override
  BubbleState createState() => BubbleState();
}

class BubbleState extends State<Bubble>
    with TickerProviderStateMixin, RouteAware {
  static const maxAlpha = 50;

  late final AnimationController _floatingController = AnimationController(
    value: widget.phase,
    duration: const Duration(seconds: 10),
    vsync: this,
  );
  late final AnimationController _fadingController = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  );

  int _alpha = 0;

  @override
  void initState() {
    unawaited(_floatingController.repeat());
    _fadeIn();
    _fadingController.addListener(() {
      setState(() {
        _alpha = (_fadingController.value * maxAlpha).toInt();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      App.routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
    super.initState();
  }

  void _fadeIn() {
    _fadingController.reset();
    unawaited(_fadingController.forward());
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _fadingController.dispose();
    App.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _fadeIn();
    super.didPopNext();
  }

  @override
  void didPush() {
    _fadeIn();
    super.didPush();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    var randomX = widget.xFactor * screen.width;
    var radius = widget.radius * (widget.square ? 0.8 : 1);

    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromSize(
          Rect.fromCircle(
            center: Offset(randomX, screen.height + radius),
            radius: radius,
          ),
          screen,
        ),
        end: RelativeRect.fromSize(
          Rect.fromCircle(center: Offset(randomX, -radius), radius: radius),
          screen,
        ),
      ).animate(_floatingController),
      child: IgnorePointer(
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.inversePrimary.withAlpha(_alpha),
            shape: widget.square ? BoxShape.rectangle : BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
