import 'package:flutter/material.dart';

final ThemeData defaultTheme = _buildCustomTheme();

class MyColors {
  static const Color LapisLazuli = const Color(0xFF346186);
  static const Color Aero = const Color(0xFF76B0DE);
  static const Color MiddleRed = const Color(0xFFE78771);
  static const Color TealBlue = const Color(0xFF227A92);
  static const Color MiddleBlueGreen = const Color(0xFF83CBC8);

  static const Color Landing1 = const Color.fromRGBO(249, 225, 219 ,1);
  static const Color Landing2 = const Color.fromRGBO(193, 229, 227 ,1);
  static const Color Landing3 = const Color.fromRGBO(255, 241, 204 ,1);
}

ColorScheme myColorScheme = ColorScheme(
  primary: MyColors.TealBlue,
  primaryVariant: MyColors.LapisLazuli,
  secondary: MyColors.Landing1,
  secondaryVariant: MyColors.MiddleRed,
  surface: Colors.white,
  background: Colors.white,
  error: MyColors.MiddleRed,
  onPrimary: Colors.white,
  onSecondary: MyColors.MiddleRed,
  onSurface: Colors.black54,
  onBackground: Colors.black54,
  onError: Colors.black54,
  brightness: Brightness.light,
);

ThemeData _buildCustomTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    toggleableActiveColor: MyColors.TealBlue,
    primaryColor: MyColors.TealBlue,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    errorColor: MyColors.MiddleBlueGreen,
    buttonTheme: ButtonThemeData(
      colorScheme: myColorScheme,
      textTheme: ButtonTextTheme.normal,
      shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
      )


    ),
    textTheme: _buildCustomTextTheme(base.textTheme),
    primaryTextTheme: _buildCustomTextTheme(base.primaryTextTheme), colorScheme: myColorScheme.copyWith(secondary: MyColors.MiddleRed),
  );
}

TextTheme _buildCustomTextTheme(TextTheme base) {
  return base
      .copyWith(
    caption: base.caption?.copyWith(
      color: Colors.black
    ),
    button: base.button?.copyWith(
      letterSpacing: 0.7
    )
  ).apply(
    fontFamily: 'Raleway',
  );
}

