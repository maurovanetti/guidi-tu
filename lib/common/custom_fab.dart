import 'package:flutter/material.dart';

import 'style_guide.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String tooltip;
  final IconData icon;

  const CustomFloatingActionButton({
    super.key,
    this.onPressed,
    this.tooltip = '',
    this.icon = Icons.arrow_forward,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: tooltip,
      onPressed: onPressed,
      shape: StyleGuide.getImportantBorder(context),
      child: Icon(icon),
    );
  }
}

class SafeMarginForCustomFloatingActionButton extends SizedBox {
  static const safeMarginHeight = 100.0;

  const SafeMarginForCustomFloatingActionButton({super.key})
      : super(
          width: double.infinity,
          height: safeMarginHeight,
        );
}
