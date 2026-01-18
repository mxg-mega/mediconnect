import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  const AppTextStyles._();

  // Tokens sourced from assets/textStyles_Medconnect/values/fonts.xml
  // Naming matches Zeplin export exactly (lowerCamelCase variants).

  static TextStyle get inter32M =>
      GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w500);

  static TextStyle get inter24M =>
      GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w500);

  static TextStyle get interP24R =>
      GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w400);

  static TextStyle get h1Sb => GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    // Zeplin Android export uses lineSpacingExtra=5.7sp
    // height = (fontSize + lineSpacingExtra) / fontSize
    height: (22 + 5.7) / 22,
  );

  static TextStyle get interP22M =>
      GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w500);

  static TextStyle get interP22R =>
      GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w400);

  static TextStyle get interP20M =>
      GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w500);

  static TextStyle get interP20R =>
      GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w400);

  static TextStyle get h2Sb => GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    // lineSpacingExtra=4.7sp
    height: (18 + 4.7) / 18,
  );

  static TextStyle get interP18M =>
      GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500);

  static TextStyle get interP18R =>
      GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w400);

  static TextStyle get interP16Sm =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get h3Sb =>
      GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get interP16M =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get interP16R => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    // lineSpacingExtra=6sp
    height: (16 + 6) / 16,
  );

  static TextStyle get p14Sm =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get h4Sb =>
      GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get interP14M =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get interP14R =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle get h5Sb =>
      GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600);

  static TextStyle get interP12M =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle get interP12R =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400);
}
