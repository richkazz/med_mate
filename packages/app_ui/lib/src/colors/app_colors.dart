import 'package:flutter/material.dart';

/// Defines the color palette for the App UI Kit.
abstract class AppColors {
  ///Color for button that are enabled
  static const Color enabledButtonBackgroundColor =
      Color.fromRGBO(76, 95, 247, 1);

  ///Color for button that are enabled
  static const Color primaryColor = Color.fromRGBO(76, 95, 247, 1);

  ///Color for button that are enabled
  static const Color dividerColor = Color.fromRGBO(238, 238, 238, 1);

  ///Color for button that are enabled
  static const Color borderColor = Color.fromRGBO(76, 95, 247, 1);

  ///Color for button that are enabled
  static const Color textLightColor = Color.fromRGBO(184, 184, 184, 1);

  ///Color for button that are enabled
  static const Color textDullColor = Color.fromRGBO(184, 184, 184, 1);

  ///Color for button that are enabled
  static const Color textFieldFillColor = Color.fromRGBO(243, 243, 243, 1);

  ///Color for button that are enabled
  static const Color iconBackgroundColor = Color.fromRGBO(243, 243, 243, 1);

  ///Color for button that are enabled
  static const Color icon2BackgroundColor = Color.fromRGBO(235, 241, 255, 1);

  ///Color for button that are enabled
  static const Color iconSuccessBackgroundColor =
      Color.fromRGBO(22, 137, 41, 0.1);

  ///Color for button that are enabled
  static const Color cardTitleBackgroundColor =
      Color.fromRGBO(212, 225, 255, 1);

  ///Color for button that are not enabled
  static const Color disabledButtonBackgroundColor =
      Color.fromRGBO(76, 95, 247, 0.39);

  ///Color for the bottom nav bar
  static const Color bottomNavBarColor = Color.fromRGBO(235, 241, 255, 1);

  ///Gray/25
  static const Color fieldFillColor = Color.fromRGBO(252, 252, 253, 1);

  ///Gray/300
  static const Color fieldBorderColor = Color.fromRGBO(208, 213, 221, 1);

  ///Darh Green
  static const Color veryLightBlack = Color.fromARGB(255, 52, 64, 84);

  ///Darh Green
  static const Color purple = Color.fromARGB(255, 170, 55, 231);

  ///Darh Green
  static const Color darkGreen = Color.fromRGBO(6, 83, 11, 1);

  /// Black
  static const Color black = Color(0xFF000000);

  /// Light black
  static const Color lightBlack = Colors.black54;

  /// White
  static const Color white = Color(0xFFFFFFFF);

  /// White
  static const Color whiteCardField = Color(0xFFFFFFFF);

  /// White
  static const Color boxShadow = Color.fromRGBO(237, 237, 235, 1);

  /// Transparent
  static const Color transparent = Color(0x00000000);

  /// The grey primary color and swatch.
  static const MaterialColor grey = Colors.grey;

  /// The liver color.
  static const Color liver = Color(0xFF4D4D4D);

  /// The green primary color and swatch.
  static const MaterialColor green = Colors.green;

  /// The teal primary color and swatch.
  static const MaterialColor teal = Colors.teal;

  /// The dark aqua color.
  static const Color darkAqua = Color(0xFF00677F);

  /// The blue primary color and swatch.
  static const Color blue = Color(0xFF3898EC);

  /// The sky blue color.
  static const Color skyBlue = Color(0xFF0175C2);

  /// The ocean blue color.
  static const Color oceanBlue = Color(0xFF02569B);

  /// The light blue color.
  static const MaterialColor lightBlue = Colors.lightBlue;

  /// The blue dress color.
  static const Color blueDress = Color(0xFF1877F2);

  /// The crystal blue color.
  static const Color crystalBlue = Color(0xFF55ACEE);

  /// The light surface2 dress color.
  static const Color surface2 = Color(0xFFEBF2F7);

  /// The pale sky color.
  static const Color paleSky = Color(0xFF73777F);

  /// The input hover color.
  static const Color inputHover = Color(0xFFE4E4E4);

  /// The input focused color.
  static const Color inputFocused = Color(0xFFD1D1D1);

  /// The input enabled color.
  static const Color inputEnabled = Color(0xFFEDEDED);

  /// The pastel grey color.
  static const Color pastelGrey = Color(0xFFCCCCCC);

  /// The bright grey color.
  static const Color brightGrey = Color(0xFFEAEAEA);

  /// The yellow primary color.
  static const MaterialColor yellow = Colors.yellow;

  /// The red primary color and swatch.
  static const MaterialColor red = Colors.red;

  /// The background color.
  static const Color background = Color(0xFFFFFFFF);

  /// The dark background color.
  static const Color darkBackground = Color(0xFF001F28);

  /// The on-background color.
  static const Color onBackground = Color(0xFF1A1A1A);

  /// The primary container color.
  static const Color primaryContainer = Color(0xFFB1EBFF);

  /// The dark text 1 color.
  static const Color darkText1 = Color(0xFFFCFCFC);

  /// The red wine color.
  static const Color redWine = Color(0xFF9A031E);

  /// The rangoonGreen color.
  static const Color rangoonGreen = Color(0xFF1B1B1B);

  /// The modal background color.
  static const Color modalBackground = Color(0xFFEBF2F7);

  /// The eerie black color.
  static const Color eerieBlack = Color(0xFF191C1D);

  /// The medium emphasis primary color.
  static const Color mediumEmphasisPrimary = Color(0xBDFFFFFF);

  /// The medium emphasis surface color.
  static const Color mediumEmphasisSurface = Color(0x99000000);

  /// The high emphasis primary color.
  static const Color highEmphasisPrimary = Color(0xFCFFFFFF);

  /// The high emphasis surface color.
  static const Color highEmphasisSurface = Color(0xE6000000);

  /// The border outline color.
  static const Color borderOutline = Color(0x33000000);

  /// The light outline color.
  static const Color outlineLight = Color(0x33000000);

  /// The outline on dark color.
  static const Color outlineOnDark = Color(0x29FFFFFF);

  /// The secondary color of application.
  static const MaterialColor secondary = MaterialColor(0xFF963F6E, <int, Color>{
    50: Color(0xFFFFECF3),
    100: Color(0xFFFFD8E9),
    200: Color(0xFFFFAFD6),
    300: Color(0xFFF28ABE),
    400: Color(0xFFD371A3),
    500: Color(0xFFB55788),
    600: Color(0xFF963F6E),
    700: Color(0xFF7A2756),
    800: Color(0xFF5F0F40),
    900: Color(0xFF3D0026),
  });

  /// The medium high emphasis primary color.
  static const Color mediumHighEmphasisPrimary = Color(0xE6FFFFFF);

  /// The medium high emphasis surface color.
  static const Color mediumHighEmphasisSurface = Color(0xB3000000);

  /// The default disabled foreground color.
  static const Color disabledForeground = Color(0x611B1B1B);

  /// The default disabled button color.
  static const Color disabledButton = Color(0x1F000000);

  /// The default disabled surface color.
  static const Color disabledSurface = Color(0xFFE0E0E0);

  /// The gainsboro color.
  static const Color gainsboro = Color(0xFFDADCE0);

  /// The orange color.
  static const Color orange = Color(0xFFFB8B24);
}
