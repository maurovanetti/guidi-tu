import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {
  const FittedText(this.text, {super.key, this.style, this.alignment});

  final String text;
  final TextStyle? style;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (innerContext, constraints) {
        var someText = text.isNotEmpty ? text : " ";
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignment ?? Alignment.center,
          child: Text(
            someText,
            style: style,
          ),
        );
      },
    );
  }
}
