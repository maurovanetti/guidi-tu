import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const FittedText(this.text, {super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: style,
          ),
        );
      },
    );
  }
}
