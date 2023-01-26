import 'dart:math';

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool important;
  final bool funny;

  const CustomButton({
    super.key,
    this.onPressed,
    this.text = 'OK',
    this.important = true,
    bool? funny,
  }) : funny = funny ?? important;

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final _phases = <double>[];

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.addListener(() => setState(() {}));
    _controller.repeat();
    for (var i = 0; i < widget.text.characters.length; i++) {
      _phases.add(Random().nextDouble() * 2 * pi);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle? textStyle(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: widget.important ? FontWeight.bold : FontWeight.normal);

  TextStyle? funnyTextStyle(BuildContext context, double x) {
    var boringStyle = textStyle(context);
    return boringStyle?.copyWith(fontSize: x + boringStyle.fontSize!);
  }

  Widget _buildLabel(BuildContext context) {
    if (!widget.funny) {
      return Text(widget.text, style: textStyle(context));
    }
    var inlineSpans = <InlineSpan>[];
    for (var i = 0; i < widget.text.characters.length; i++) {
      var char = widget.text.characters.elementAt(i);
      double x;
      if (i == 0) {
        x = 1; // Prevents vertical oscillation
      } else {
        x = sin(_phases[i] + 2 * pi * _animation.value);
      }
      inlineSpans.add(TextSpan(text: char, style: funnyTextStyle(context, x)));
    }
    return RichText(text: TextSpan(children: inlineSpans));
  }

  @override
  Widget build(BuildContext context) {
    final strongBorderColor =
        Theme.of(context).buttonTheme.colorScheme!.onPrimary;
    final weakBorderColor = Color.lerp(strongBorderColor,
        Theme.of(context).buttonTheme.colorScheme!.primary, 0.5)!;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: widget.important ? strongBorderColor : weakBorderColor,
              strokeAlign: BorderSide.strokeAlignCenter,
              width: widget.important ? 5 : 3,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _buildLabel(context),
      ),
    );
  }
}
