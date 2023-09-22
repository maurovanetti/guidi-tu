import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {
  const FittedText(this.text, {super.key, this.style, this.textAlign});

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (innerContext, constraints) {
        var someText = text.isNotEmpty ? text : " ";
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            someText,
            textAlign: textAlign,
            style: style,
          ),
        );
      },
    );
  }
}
