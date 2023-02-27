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
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).buttonTheme.colorScheme!.onPrimary,
              width: StyleGuide.importantBorderWidth,
              strokeAlign: BorderSide.strokeAlignCenter),
          borderRadius: BorderRadius.circular(StyleGuide.borderRadius)),
      child: Icon(icon),
    );
  }
}
