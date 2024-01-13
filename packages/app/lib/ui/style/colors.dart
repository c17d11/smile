import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color.fromARGB(255, 161, 202, 200);

  static const Color background = Colors.black;
  static final Color backgroundSecond = Colors.grey[900]!;
  static final Color foreground = Colors.grey[300]!;
  static final Color foregroundSecond = Colors.grey[400]!;
  static final Color foregroundThird = Colors.grey[600]!;
}

class AppTextStyle {
  static TextStyle normal = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w600, color: AppColors.foreground);

  static TextStyle small = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
      color: AppColors.foregroundSecond);

  static TextStyle tiny = TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w800,
      color: AppColors.foregroundSecond);
}
