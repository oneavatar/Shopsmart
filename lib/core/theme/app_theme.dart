import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static ThemeData lightTheme =
      ThemeData(

    brightness: Brightness.light,

    primaryColor: Colors.black,

    scaffoldBackgroundColor:
        const Color(0xFFF5F5F5),

    fontFamily:
        GoogleFonts.poppins().fontFamily,

    appBarTheme:
    const AppBarTheme(

      backgroundColor:
          Colors.transparent,

      elevation: 0,

      centerTitle: true,

      foregroundColor:
          Colors.black,
    ),

    cardColor: Colors.white,

    elevatedButtonTheme:
    ElevatedButtonThemeData(

      style:
      ElevatedButton.styleFrom(

        backgroundColor:
            Colors.black,

        foregroundColor:
            Colors.white,

        elevation: 0,

        minimumSize:
            const Size(
              double.infinity,
              55,
            ),

        shape:
        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(
            18,
          ),
        ),
      ),
    ),

    inputDecorationTheme:
    InputDecorationTheme(

      filled: true,

      fillColor:
          Colors.grey.shade200,

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),

      border:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        borderSide:
            BorderSide.none,
      ),

      focusedBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(
          18,
        ),

        borderSide:
        const BorderSide(
          color: Colors.black,
        ),
      ),
    ),

    bottomNavigationBarTheme:
    const BottomNavigationBarThemeData(

      selectedItemColor:
          Colors.black,

      unselectedItemColor:
          Colors.grey,

      backgroundColor:
          Colors.white,

      type:
      BottomNavigationBarType.fixed,

      elevation: 10,
    ),
  );

  static ThemeData darkTheme =
      ThemeData(

    brightness: Brightness.dark,

    scaffoldBackgroundColor:
        const Color(0xFF121212),

    fontFamily:
        GoogleFonts.poppins().fontFamily,

    appBarTheme:
    const AppBarTheme(

      backgroundColor:
          Colors.transparent,

      elevation: 0,

      centerTitle: true,
    ),

    elevatedButtonTheme:
    ElevatedButtonThemeData(

      style:
      ElevatedButton.styleFrom(

        backgroundColor:
            Colors.white,

        foregroundColor:
            Colors.black,

        elevation: 0,

        minimumSize:
            const Size(
              double.infinity,
              55,
            ),

        shape:
        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(
            18,
          ),
        ),
      ),
    ),

    bottomNavigationBarTheme:
    const BottomNavigationBarThemeData(

      selectedItemColor:
          Colors.white,

      unselectedItemColor:
          Colors.grey,

      backgroundColor:
          Color(0xFF1E1E1E),

      type:
      BottomNavigationBarType.fixed,
    ),
  );
}