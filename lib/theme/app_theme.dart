import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  static const Color primaryColor = Colors.orange;
  static const Color backgroundColorLight = Colors.white;
  static const Color textColorPrimaryLight = Colors.black87;
  static const Color textColorSecondaryLight = Colors.black54;

  static const Color backgroundColorDark = Colors.black87;
  static const Color textColorPrimaryDark = Colors.white;
  static const Color textColorSecondaryDark = Colors.white70;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    //primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColorLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: textColorPrimaryLight,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: textColorPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: textColorSecondaryLight,
        fontSize: 16,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
    //primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: textColorPrimaryDark,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: textColorPrimaryDark,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: textColorSecondaryDark,
        fontSize: 16,
      ),
    ),
  );

  static const CupertinoThemeData iosTheme = CupertinoThemeData(
    primaryColor: CupertinoColors.systemBlue,
    barBackgroundColor: CupertinoColors.systemBackground,
    scaffoldBackgroundColor: CupertinoColors.systemBackground,
    textTheme: CupertinoTextThemeData(
      navTitleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      textStyle: TextStyle(
        fontSize: 16,
      ),
    ),
  );
}
