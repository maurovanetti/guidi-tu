import 'package:flutter/material.dart';

import 'style_guide.dart';
import 'typedefs.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    this.onPressed,
    this.tooltip = '',
    this.icon = Icons.arrow_forward,
    this.heroTag = 'hero',
  });

  final AsyncCallback onPressed;
  final String tooltip;
  final IconData icon;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: tooltip,
      onPressed: onPressed,
      shape: StyleGuide.getImportantBorder(context),
      heroTag: heroTag,
      child: Icon(icon),
    );
  }
}

class SafeMarginForCustomFloatingActionButton extends SizedBox {
  const SafeMarginForCustomFloatingActionButton({super.key})
      : super(
          width: double.infinity,
          height: safeMarginHeight,
        );

  static const safeMarginHeight = 100.0;
}
