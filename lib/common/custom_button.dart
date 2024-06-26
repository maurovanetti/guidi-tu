import 'dart:async';
import 'dart:math';

import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'fitted_text.dart';
import 'style_guide.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    this.text = 'OK',
    this.important = true,
    bool? funny,
  }) : funny = funny ?? important;

  final VoidCallback? onPressed;
  final String text;
  final bool important;
  final bool funny;

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  static const _borderColorBlendFactor = 0.5; // primaryColor to onPrimaryColor

  late final AnimationController _controller;
  late Animation<double> _animation;
  final _phases = <double>[];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    // ignore: avoid-empty-setstate
    _controller.addListener(() => setState(() {}));
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.buttonTheme.colorScheme!;
    var primaryColor = colorScheme.primary;
    var onPrimaryColor = colorScheme.onPrimary;
    var disabledColor = colorScheme.surface.brighten(0.25);
    Color borderColor;
    if (widget.onPressed == null) {
      borderColor = Colors.transparent;
    } else if (widget.important) {
      borderColor = onPrimaryColor;
    } else {
      borderColor =
          Color.lerp(primaryColor, onPrimaryColor, _borderColorBlendFactor)!;
    }
    var textStyle = theme.textTheme.headlineMedium?.copyWith(
      color: widget.onPressed == null ? colorScheme.surface : onPrimaryColor,
      fontWeight: widget.important ? FontWeight.bold : FontWeight.normal,
      fontSize:
          widget.important ? null : theme.textTheme.headlineSmall?.fontSize,
    );

    return Padding(
      padding: StyleGuide.regularPadding,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          disabledBackgroundColor: disabledColor,
          // ignore: no-magic-number
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor,
              width: widget.important
                  ? StyleGuide.importantBorderWidth
                  : StyleGuide.regularBorderWidth,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
            borderRadius: StyleGuide.borderRadius,
          ),
        ),
        child: widget.funny
            ? _FunnyLabel(
                widget.text.characters,
                animationValue: _animation.value,
                boringStyle: textStyle,
                phases: _phases,
              )
            : FittedText(
                widget.text,
                style: textStyle,
              ),
      ),
    );
  }
}

class _FunnyLabel extends StatelessWidget {
  const _FunnyLabel(
    this.characters, {
    required this.animationValue,
    required this.boringStyle,
    required this.phases,
  });

  final Characters characters;
  final double animationValue;
  final List<double> phases;
  final TextStyle? boringStyle;

  TextStyle? _funnyTextStyle(double x) =>
      boringStyle?.copyWith(fontSize: x + boringStyle!.fontSize!);

  @override
  Widget build(BuildContext context) {
    var inlineSpans = <InlineSpan>[];
    for (var i = 0; i < characters.length; i++) {
      var char = characters.elementAt(i);
      double x;
      if (i == 0) {
        x = 1; // Prevents vertical oscillation
      } else {
        // This makes _phases robust enough to prevent exceptions when the text
        // changes while the animation is running.
        var twoPi = pi * 2;
        while (phases.length <= i) {
          phases.add(Random().nextDouble() * twoPi);
        }
        x = sin(phases[i] + twoPi * animationValue);
      }
      inlineSpans.add(TextSpan(text: char, style: _funnyTextStyle(x)));
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text.rich(TextSpan(children: inlineSpans)),
    );
  }
}
