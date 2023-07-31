import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {
  const FittedText(this.text, {super.key, this.style, this.textAlign});

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            textAlign: textAlign,
            style: style,
          ),
        );
      },
    );
  }
}
