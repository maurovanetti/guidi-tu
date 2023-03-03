import 'package:flutter/material.dart';

class SqueezeOrScroll extends StatelessWidget {
  final List<Widget> topChildren; // never squeezable
  final Widget centralChild; // may be squeezable
  final List<Widget> bottomChildren; // never squeezable
  final bool squeeze;

  const SqueezeOrScroll({
    super.key,
    required this.topChildren,
    required this.centralChild,
    required this.bottomChildren,
    this.squeeze = false,
  });

  @override
  Widget build(BuildContext context) {
    return squeeze
        ? Column(children: [
            ...topChildren,
            Flexible(child: centralChild),
            ...bottomChildren,
          ])
        : ListView(shrinkWrap: true, children: [
            ...topChildren,
            centralChild,
            ...bottomChildren,
          ]);
  }
}
