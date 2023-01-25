import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String tooltip;
  final IconData icon;

  const CustomFloatingActionButton(
      {super.key,
      this.onPressed,
      this.tooltip = '',
      this.icon = Icons.arrow_forward});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Theme.of(context).buttonTheme.colorScheme!.onPrimary,
          width: 5,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}
