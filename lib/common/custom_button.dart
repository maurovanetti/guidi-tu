import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool important;

  const CustomButton({
    super.key,
    this.onPressed,
    this.text = 'OK',
    this.important = true,
  });

  @override
  Widget build(BuildContext context) {
    final strongBorderColor =
        Theme.of(context).buttonTheme.colorScheme!.onPrimary;
    final weakBorderColor = Color.lerp(strongBorderColor,
        Theme.of(context).buttonTheme.colorScheme!.primary, 0.5)!;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: important ? strongBorderColor : weakBorderColor,
              strokeAlign: BorderSide.strokeAlignCenter,
              width: important ? 5 : 3,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: important ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }
}
