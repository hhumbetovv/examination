import 'package:flutter/material.dart';

import 'constants.dart';

class AppColors {
  final Color primaryDark;
  final Color primaryLight;
  final Color backgroundDark;
  final Color backgroundLight;

  AppColors(
    this.primaryDark,
    this.primaryLight,
    this.backgroundDark,
    this.backgroundLight,
  );

  static List<AppColors> colors = [
    //! S - 90 => 50 V - 50 => 90
    AppColors(
      const Color(0xFF7f0c0c),
      const Color(0xFFe57272),
      const Color(0xFF190f14),
      const Color(0xFFe5ceda),
    ),
    AppColors(
      const Color(0xFF7f0c7f),
      const Color(0xFFe572e5),
      const Color(0xFF190f14),
      const Color(0xFFe5ceda),
    ),
    AppColors(
      const Color(0xFF460c7f),
      const Color(0xFFac72e5),
      const Color(0xFF0f1019),
      const Color(0xFFe5e8ff),
    ),
    //! S - 50 V - 40 => 90
    AppColors(
      const Color(0xFF333366),
      const Color(0xFF7272e5),
      const Color(0xFF0f1619),
      const Color(0xFFcedde5),
    ),
    AppColors(
      const Color(0xFF336666),
      const Color(0xFF72e5e5),
      const Color(0xFF0f1914),
      const Color(0xFFcee5da),
    ),
    AppColors(
      const Color(0xFF336633),
      const Color(0xFF72e572),
      const Color(0xFF14190f),
      const Color(0xFFdae5ce),
    ),
    //! S - 90 => 70 V - 90 => 100
    AppColors(
      const Color(0xFFe5b116),
      const Color(0xFFffd24c),
      const Color(0xFF19140f),
      const Color(0xFFe5dace),
    ),
    AppColors(
      const Color(0xFFe55b16),
      const Color(0xFFff884c),
      const Color(0xFF19110f),
      const Color(0xFFe5d2ce),
    ),
    AppColors(
      const Color(0xFF3d3d3d),
      const Color(0xFFb2b2b2),
      const Color(0xFF161616),
      const Color(0xFFe5e5e5),
    ),
  ];
}

class AppTheme {
  ThemeData light(AppColors theme) => _getTheme(theme, false);
  ThemeData dark(AppColors theme) => _getTheme(theme, true);

  ThemeData _getTheme(AppColors theme, bool isDark) {
    return ThemeData(
      //! Brightness
      brightness: isDark ? Brightness.dark : Brightness.light,
      //! Color Scheme
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: theme.primaryDark,
              secondary: theme.primaryLight,
              background: theme.backgroundDark,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              tertiary: Colors.white,
            )
          : ColorScheme.light(
              primary: theme.primaryLight,
              secondary: theme.primaryDark,
              background: theme.backgroundLight,
              onPrimary: Colors.black,
              onSecondary: Colors.white,
              tertiary: Colors.black,
            ),
      //! Scaffold Background Color
      scaffoldBackgroundColor: isDark ? theme.backgroundDark : theme.backgroundLight,
      //! AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: Constants.fontSizeSmall,
          color: isDark ? Colors.white : Colors.black,
          overflow: TextOverflow.ellipsis,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        color: isDark ? theme.primaryDark : theme.primaryLight,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      //! Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: isDark ? theme.primaryDark : theme.primaryLight,
          textStyle: TextStyle(
            fontSize: Constants.fontSizeMedium,
            color: isDark ? Colors.white : Colors.black,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: Constants.radiusSmall,
          ),
        ),
      ),
      //! Bottom AppBar Theme
      bottomAppBarTheme: BottomAppBarTheme(
        shape: const CircularNotchedRectangle(),
        color: isDark ? theme.primaryDark : theme.primaryLight,
      ),
      //! Icon Theme
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Colors.black,
      ),
      //! Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDark ? theme.primaryLight : theme.primaryDark,
        extendedTextStyle: TextStyle(
          color: isDark ? Colors.black : Colors.white,
          fontSize: Constants.fontSizeSmall,
        ),
      ),
      //! Highlight and Splash Colors
      highlightColor: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
      splashColor: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
      //! Text Theme
      textTheme: TextTheme(
        bodyText2: TextStyle(
          fontSize: Constants.fontSizeSmall,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      //! Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isDark ? theme.primaryLight : theme.primaryDark,
      ),
      //! Divider Theme
      dividerTheme: DividerThemeData(
        color: isDark ? theme.primaryLight : theme.primaryDark,
        thickness: 1,
      ),
      //! Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(isDark ? theme.primaryLight : theme.primaryDark),
      ),
      //! Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all<Color>(isDark ? theme.primaryLight : theme.primaryDark),
      ),
      //! Text Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(
          height: 0,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? theme.primaryLight : theme.primaryDark,
          ),
        ),
      ),
      //! Dialog Theme
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: Constants.radiusLarge,
        ),
        backgroundColor: isDark ? theme.backgroundDark : theme.backgroundLight,
      ),
    );
  }
}
