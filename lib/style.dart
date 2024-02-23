import 'package:flutter/material.dart';

ThemeData getLightThemeData() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xffe4011f),
      onPrimary: Colors.grey.shade200,
      secondary: const Color(0xffe4011f),
      onSecondary: Colors.grey.shade200,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.grey.shade800,
      surface: const Color(0xffFFFFFF),
      surfaceTint: Colors.transparent, // AppBar Color on Scroll
      onSurface: Colors.grey.shade900,
    ),
    appBarTheme: AppBarTheme(
      // backgroundColor: Colors.white,
      // foregroundColor: Colors.grey.shade900,
      titleTextStyle: TextStyle(
        color: Colors.grey.shade900,
        fontWeight: FontWeight.w800,
        fontSize: 20,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.grey.shade800,
      ),
      iconTheme: IconThemeData(
        color: Colors.grey.shade800,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade400,
      thickness: 1,
      space: 0,
      indent: 5,
      endIndent: 5,
    ),
    dividerColor: Colors.green,
    iconTheme: IconThemeData(
      color: Colors.grey.shade800,
      weight: 600,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(),
      displayMedium: TextStyle(),
      displaySmall: TextStyle(),
      headlineLarge: TextStyle(),
      headlineMedium: TextStyle(),
      headlineSmall: TextStyle(),
      titleLarge: TextStyle(),
      titleMedium: TextStyle(),
      titleSmall: TextStyle(),
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
      bodySmall: TextStyle(),
      labelLarge: TextStyle(),
      labelMedium: TextStyle(),
      labelSmall: TextStyle(),
    ).apply(
      bodyColor: Colors.grey.shade900,
      displayColor: Colors.grey.shade900,
      decorationColor: Colors.grey.shade900,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
      ),
      disabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade800, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      iconColor: Colors.grey.shade800,
      labelStyle: TextStyle(color: Colors.grey.shade800),
      hintStyle: TextStyle(color: Colors.grey.shade800),
      suffixIconColor: Colors.grey.shade600,
      fillColor: const Color(0xfff6f6f6),
    ),
    listTileTheme: ListTileThemeData(
      textColor: Colors.grey.shade300,
      iconColor: Colors.grey.shade600,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: const MaterialStatePropertyAll(
          Color(0xfff6f6f6),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
        ),
        disabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade800, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        iconColor: Colors.grey.shade800,
        labelStyle: TextStyle(color: Colors.grey.shade800),
        hintStyle: TextStyle(color: Colors.grey.shade800),
        suffixIconColor: Colors.grey.shade600,
        fillColor: const Color(0xfff6f6f6),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xff292929),
      contentTextStyle: TextStyle(
        color: Color(0xfff0f0f0),
      ),
      actionTextColor: Color(0xffe4011f),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
    ),
  );
}
