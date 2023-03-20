import 'package:flutter/material.dart';

class StyleGuide {
  static const borderRadius = 15.0;
  static const importantBorderWidth = 5.0;
  static const regularBorderWidth = 3.0;

  static const narrowPadding = EdgeInsets.all(5.0);
  static const regularPadding = EdgeInsets.all(10.0);
  static const widePadding = EdgeInsets.all(20.0);
  static const scrollbarPadding = EdgeInsets.only(right: 10.0);

  static getImportantBorder(BuildContext context) => RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).buttonTheme.colorScheme!.onPrimary,
          width: StyleGuide.importantBorderWidth,
        ),
        borderRadius:
            const BorderRadius.all(Radius.circular(StyleGuide.borderRadius)),
      );
}
