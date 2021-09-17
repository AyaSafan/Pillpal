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

ColorScheme _MyColorScheme = ColorScheme(
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
    colorScheme: _MyColorScheme,
    toggleableActiveColor: MyColors.TealBlue,
    accentColor: MyColors.MiddleRed,
    primaryColor: MyColors.TealBlue,
    buttonColor: MyColors.TealBlue,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    textSelectionColor: MyColors.TealBlue,
    errorColor: MyColors.MiddleBlueGreen,
    buttonTheme: ButtonThemeData(
      colorScheme: _MyColorScheme,
      textTheme: ButtonTextTheme.normal,
      shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
      )


    ),
    //primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildCustomTextTheme(base.textTheme),
    primaryTextTheme: _buildCustomTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildCustomTextTheme(base.accentTextTheme),
    //iconTheme: _customIconTheme(base.iconTheme),
  );
}
const defaultLetterSpacing = 0.03;
//
// IconThemeData _customIconTheme(IconThemeData original) {
//   return original.copyWith(color: MyColors.TealBlue);
// }

TextTheme _buildCustomTextTheme(TextTheme base) {
  return base
      .copyWith(
    caption: base.caption?.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: defaultLetterSpacing,
    ),
    button: base.button?.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 18,
      fontFamily: 'Raleway',
      letterSpacing: 2,
      color: Colors.white
    ),
    //headline1: base.headline1?.copyWith( fontSize: 24, fontFamily: 'Raleway',color: Colors.black, ),
    //headline2: base.headline2?.copyWith(fontSize: 18, letterSpacing: 2, fontFamily: 'Raleway',),
    bodyText2: base.bodyText2?.copyWith(fontSize: 16, fontFamily: 'Raleway', ),
  )
      .apply(
    fontFamily: 'Raleway',
    // displayColor: MyColors.TealBlue,
    // bodyColor: MyColors.TealBlue,
  );
}

