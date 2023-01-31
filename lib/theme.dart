import 'package:flutter/material.dart';

import 'constants.dart';

final ColorTheme selectedColor = ColorTheme.colors[0];
final ThemeData lightTheme = ThemeData(
  //! Brightness
  brightness: Brightness.light,
  //! Color Scheme
  colorScheme: ColorScheme.light(
    primary: selectedColor.light.primary,
    secondary: selectedColor.light.secondary,
    background: selectedColor.light.background,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    tertiary: Colors.black,
  ),
  //! Scaffold Background Color
  scaffoldBackgroundColor: selectedColor.light.background,
  //! AppBar Theme
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    color: selectedColor.light.primary,
    centerTitle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(15),
      ),
    ),
    titleTextStyle: const TextStyle(
      fontSize: Constants.fontSizeSmall,
      color: Colors.black,
      overflow: TextOverflow.ellipsis,
    ),
  ),
  //! Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: selectedColor.light.primary,
      textStyle: const TextStyle(
        fontSize: Constants.fontSizeMedium,
        color: Colors.black,
      ),
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(
        borderRadius: Constants.radiusSmall,
      ),
    ),
  ),
  //! Bottom AppBar Theme
  bottomAppBarTheme: BottomAppBarTheme(
    shape: const CircularNotchedRectangle(),
    color: selectedColor.light.primary,
  ),
  //! Icon Theme
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  //! Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: selectedColor.light.secondary,
    extendedTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: Constants.fontSizeSmall,
    ),
  ),
  //! Highlight and Splash Colors
  highlightColor: Colors.black.withOpacity(0.2),
  splashColor: Colors.black.withOpacity(0.2),
  //! Text Theme
  textTheme: const TextTheme(
    bodyText2: TextStyle(
      fontSize: Constants.fontSizeSmall,
      color: Colors.black,
    ),
  ),
  //! Progress Indicator Theme
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: selectedColor.light.secondary,
  ),
  //! Divider Theme
  dividerTheme: DividerThemeData(
    color: selectedColor.light.secondary,
    thickness: 1,
  ),
  //! Checkbox Theme
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all<Color>(selectedColor.light.secondary),
  ),
  //! Radio Theme
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all<Color>(selectedColor.light.secondary),
  ),
  //! Text Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    errorStyle: const TextStyle(
      height: 0,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: selectedColor.light.secondary,
      ),
    ),
  ),
  //! Dialog Theme
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: Constants.radiusLarge,
    ),
    backgroundColor: selectedColor.light.background,
  ),
);

final ThemeData darkTheme = ThemeData(
  //! Brightness
  brightness: Brightness.dark,
  //! Color Scheme
  colorScheme: ColorScheme.dark(
    primary: selectedColor.dark.primary,
    secondary: selectedColor.dark.secondary,
    background: selectedColor.dark.background,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    tertiary: Colors.white,
  ),
  //! Scaffold Background Color
  scaffoldBackgroundColor: selectedColor.dark.background,
  //! AppBar Theme
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    color: selectedColor.dark.primary,
    centerTitle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(15),
      ),
    ),
    titleTextStyle: const TextStyle(
      fontSize: Constants.fontSizeSmall,
      color: Colors.white,
      overflow: TextOverflow.ellipsis,
    ),
  ),
  //! Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: selectedColor.dark.primary,
      textStyle: const TextStyle(
        fontSize: Constants.fontSizeMedium,
        color: Colors.white,
      ),
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(
        borderRadius: Constants.radiusSmall,
      ),
    ),
  ),
  //! Bottom AppBar Theme
  bottomAppBarTheme: BottomAppBarTheme(
    shape: const CircularNotchedRectangle(),
    color: selectedColor.dark.primary,
  ),
  //! Icon Theme
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  //! Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: selectedColor.dark.secondary,
    extendedTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: Constants.fontSizeSmall,
    ),
  ),
  //! Highlight and Splash Colors
  highlightColor: Colors.white.withOpacity(0.2),
  splashColor: Colors.white.withOpacity(0.2),
  //! Text Theme
  textTheme: const TextTheme(
    bodyText2: TextStyle(
      fontSize: Constants.fontSizeSmall,
      color: Colors.white,
    ),
  ),
  //! Progress Indicator Theme
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: selectedColor.dark.secondary,
  ),
  //! Divider Theme
  dividerTheme: DividerThemeData(
    color: selectedColor.dark.secondary,
    thickness: 1,
  ),
  //! Checkbox Theme
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all<Color>(selectedColor.dark.secondary),
  ),
  //! Radio Theme
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all<Color>(selectedColor.dark.secondary),
  ),
  //! Text Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    errorStyle: const TextStyle(
      height: 0,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: selectedColor.dark.secondary,
      ),
    ),
  ),
  //! Dialog Theme
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: Constants.radiusLarge,
    ),
    backgroundColor: selectedColor.dark.background,
  ),
);
const ThemeMode mode = ThemeMode.dark;
