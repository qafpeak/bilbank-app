
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final  ThemeData appThemeData = ThemeData(

        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white),
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      );
}