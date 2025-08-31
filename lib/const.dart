import 'package:flutter/material.dart';

class MyConst {
  static String gift = '500,000';
  // Material 3 Color Scheme
  static const Color primary = Color(0xFF6750A4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimaryContainer = Color(0xFF21005D);

  static const Color secondary = Color(0xFF625B71);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE8DEF8);
  static const Color onSecondaryContainer = Color(0xFF1D192B);

  static const Color tertiary = Color(0xFF7D5260);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFD8E4);
  static const Color onTertiaryContainer = Color(0xFF31111D);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color background = Color(0xFFFFFBFE);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color surface = Color(0xFFFFFBFE);
  static const Color onSurface = Color(0xFF1C1B1F);

  static const Color surfaceVariant = Color(0xFFE7E0EC);
  static const Color onSurfaceVariant = Color(0xFF49454F);
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFF313033);
  static const Color onInverseSurface = Color(0xFFF4EFF4);
  static const Color inversePrimary = Color(0xFFD0BCFF);
  static const Color surfaceTint = Color(0xFF6750A4);

  // Legacy colors for backward compatibility
  static const Color backgroundColor400 = primary;
  static const Color backgroundColor200 = primaryContainer;
  static const Color backgroundColor500 = tertiary;
  static const Color iconColor36 = onSurface;
  static const Color ongroundColor = onSurface;

  // Material 3 Typography
  static TextStyle style12_16(double screenH, {FontWeight? fontWeight}) {
    return TextStyle(
        fontSize: screenH < 600 ? 12 : 16,
        fontWeight: fontWeight ?? FontWeight.w500,
        letterSpacing: screenH < 600 ? 0.4 : 0.5,
        height: screenH < 600 ? 1.33 : 1.5,
        fontFamily: 'vazir');
  }

  static TextStyle style16_18(double screenH) {
    return TextStyle(
        fontSize: screenH < 600 ? 16 : 18,
        fontWeight: FontWeight.w400,
        letterSpacing: screenH < 600 ? 0.5 : 0.5,
        height: screenH < 600 ? 1.5 : 1.5,
        fontFamily: 'vazir');
  }

  static TextStyle style11_15(double screenH) {
    return TextStyle(
      fontSize: screenH < 600 ? 11 : 15,
      fontWeight: FontWeight.w400,
      letterSpacing: screenH < 600 ? 0.5 : 0.25,
      height: screenH < 600 ? 1.45 : 1.43,
      fontFamily: 'vazir',
    );
  }

  // Material 3 specific text styles
  static TextStyle headlineLarge(double screenH) {
    return TextStyle(
      fontSize: screenH < 600 ? 24 : 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: screenH < 600 ? 1.33 : 1.25,
      fontFamily: 'vazir',
    );
  }

  static TextStyle headlineMedium(double screenH) {
    return TextStyle(
      fontSize: screenH < 600 ? 20 : 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: screenH < 600 ? 1.4 : 1.29,
      fontFamily: 'vazir',
    );
  }

  static TextStyle titleLarge(double screenH) {
    return TextStyle(
      fontSize: screenH < 600 ? 18 : 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: screenH < 600 ? 1.27 : 1.27,
      fontFamily: 'vazir',
    );
  }

  static TextStyle bodyLarge(double screenH) {
    return TextStyle(
      fontSize: screenH < 600 ? 14 : 16,
      fontWeight: FontWeight.w400,
      letterSpacing: screenH < 600 ? 0.25 : 0.5,
      height: screenH < 600 ? 1.43 : 1.5,
      fontFamily: 'vazir',
    );
  }

  static TextStyle labelLarge(double screenH) {
    return TextStyle(
      fontSize: screenH < 600 ? 12 : 14,
      fontWeight: FontWeight.w500,
      letterSpacing: screenH < 600 ? 0.5 : 0.1,
      height: screenH < 600 ? 1.33 : 1.43,
      fontFamily: 'vazir',
    );
  }
}
