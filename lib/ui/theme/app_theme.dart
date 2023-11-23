import 'package:flutter/material.dart';
import 'package:plant_disease_detection/ui/theme/colors.dart';

final appTheme = ThemeData(
    primaryColor: AppColors.green,
    colorScheme: ColorScheme.light().copyWith(
      primary: AppColors.green,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      minimumSize: Size(double.infinity, 55),
    )),
    textTheme: TextTheme(
      // display is white,
      displayLarge: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28),
      displayMedium: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
      displaySmall: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),

      // title is black
    ));
