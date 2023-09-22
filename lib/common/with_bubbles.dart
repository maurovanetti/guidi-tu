import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '/main.dart';

class WithBubbles extends StatelessWidget {
  @visibleForTesting
  // ignore: avoid-global-state
  static bool enabled = true; // Disabled in tests.

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
    if (!enabled) return child;

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
  const Bubble({super.key, this.square = false});

  final bool square;

  @override
  BubbleState createState() => BubbleState();
}

class BubbleState extends State<Bubble>
    with TickerProviderStateMixin, RouteAware {
  static const maxAlpha = 50;
  final phase = Random().nextDouble();
  final radius = Random().nextDouble() * 100 + 50;
  final xFactor = Random().nextDouble();

  late final _floatingController = AnimationController(
    value: phase,
    duration: const Duration(seconds: 10),
    vsync: this,
  );
  late final _fadingController = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  );

  int _alpha = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_floatingController.repeat());
    _fadeIn();
    _fadingController.addListener(() {
      setState(() {
        _alpha = (_fadingController.value * maxAlpha).toInt();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: avoid-inherited-widget-in-initstate
      App.routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
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
    var screen = MediaQuery.sizeOf(context);
    var randomX = xFactor * screen.width;
    var adjustedRadius = radius * (widget.square ? 0.8 : 1);

    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromSize(
          Rect.fromCircle(
            center: Offset(randomX, screen.height + adjustedRadius),
            radius: adjustedRadius,
          ),
          screen,
        ),
        end: RelativeRect.fromSize(
          Rect.fromCircle(
            center: Offset(randomX, -adjustedRadius),
            radius: adjustedRadius,
          ),
          screen,
        ),
      ).animate(_floatingController),
      child: IgnorePointer(
        child: Container(
          width: adjustedRadius,
          height: adjustedRadius,
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
