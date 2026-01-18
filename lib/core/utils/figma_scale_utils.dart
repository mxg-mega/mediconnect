import 'package:flutter/material.dart';

class FigmaScale {
  static const double figmaWidth = 440;
  static const double figmaHeight = 956;

  static const double _defaultMinScale = 0.85;
  static const double _defaultMaxScale = 1.20;

  static double widthScale(
    BuildContext context, {
    double minScale = _defaultMinScale,
    double maxScale = _defaultMaxScale,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = screenWidth / figmaWidth;
    return scale.clamp(minScale, maxScale);
  }

  static double heightScale(
    BuildContext context, {
    double minScale = _defaultMinScale,
    double maxScale = _defaultMaxScale,
  }) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final scale = screenHeight / figmaHeight;
    return scale.clamp(minScale, maxScale);
  }

  static double uniformScale(
    BuildContext context, {
    double minScale = _defaultMinScale,
    double maxScale = _defaultMaxScale,
  }) {
    final w = MediaQuery.sizeOf(context).width / figmaWidth;
    final h = MediaQuery.sizeOf(context).height / figmaHeight;
    final scale = w < h ? w : h;
    return scale.clamp(minScale, maxScale);
  }

  static double w(BuildContext context, double value) {
    return value * widthScale(context);
  }

  static double h(BuildContext context, double value) {
    return value * heightScale(context);
  }

  static double fontSize(BuildContext context, double value) {
    return value;
  }
}

extension FigmaScaleExtension on BuildContext {
  double figmaWidth(double value) => FigmaScale.w(this, value);
  double figmaHeight(double value) => FigmaScale.h(this, value);
  double figmaFontSize(double value) => FigmaScale.fontSize(this, value);

  double figmaWidthScale() => FigmaScale.widthScale(this);
  double figmaHeightScale() => FigmaScale.heightScale(this);
  double figmaUniformScale() => FigmaScale.uniformScale(this);
}
