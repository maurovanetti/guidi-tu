import 'package:flutter/material.dart';

abstract final class StyleGuide {
  static const borderRadius = BorderRadius.all(Radius.circular(30.0));
  static const importantBorderWidth = 5.0;
  static const regularBorderWidth = 3.0;

  static const stripePadding = EdgeInsets.symmetric(vertical: 5.0);
  static const sidePadding = EdgeInsets.symmetric(horizontal: 5.0);
  static const narrowPadding = EdgeInsets.all(5.0);
  static const regularPadding = EdgeInsets.all(10.0);
  static const widePadding = EdgeInsets.all(20.0);
  static const scrollbarPadding = EdgeInsets.only(right: 10.0);
  static const separationMargin = EdgeInsets.only(bottom: 5.0);

  static const iconSize = 30.0;

  static const fontFamily = 'LexendDeca';
  static const inGameFontSize = 24.0;

  static final themeData = ThemeData(
    colorSchemeSeed: Colors.purpleAccent,
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    useMaterial3: true,
    cardTheme: const CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
    ),
  );

  static RoundedRectangleBorder getImportantBorder(BuildContext context) =>
      RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).buttonTheme.colorScheme!.onPrimary,
          width: StyleGuide.importantBorderWidth,
        ),
        borderRadius: borderRadius,
      );

  static Padding getLabelOnImportantBorder(BuildContext context, String text) =>
      Padding(
        padding: EdgeInsets.only(left: borderRadius.topLeft.x),
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Color.lerp(
                  Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                  Colors.white,
                  0.5,
                ),
              ),
        ),
      );
}
