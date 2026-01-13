import 'package:flutter/material.dart';

class FigmaScale {
  static const figmaWidth = 440;
  static const figmaHeight = 956;

  static double w(BuildContext context, double value) {
    final screenWidth = MediaQuery.of(context).size.width;
    return value * (screenWidth / figmaWidth);
  }

  static double h(BuildContext context, double value) {
    final screenHeight = MediaQuery.of(context).size.height;
    return value * (screenHeight / figmaHeight);
  }

  static double fontSize(BuildContext context, double value) {
    // Assuming font size scales with width
    final screenWidth = MediaQuery.of(context).size.width;
    return value * (screenWidth / figmaWidth);
  }
}

extension FigmaScaleExtension on BuildContext {
  double figmaWidth(double value) => FigmaScale.w(this, value);
  double figmaHeight(double value) => FigmaScale.h(this, value);
  double figmaFontSize(double value) => FigmaScale.fontSize(this, value);
}