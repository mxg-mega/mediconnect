import 'dart:math';
import 'package:flutter/widgets.dart';

/// Responsive design utilities for Mediconnect app
class ResponsiveUtils {
  static const double _designWidth = 375.0; // iPhone 6/7/8 width
  static const double _designHeight = 812.0; // iPhone X height

  // Breakpoints
  static const double mobileMaxWidth = 767;
  static const double tabletMinWidth = 768;
  static const double tabletMaxWidth = 1023;
  static const double desktopMinWidth = 1024;

  // Responsive sizing based on screen width
  static double scaleWidth(double size, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = min(screenWidth / _designWidth, 2.0); // Max scale of 2.0
    return size * scaleFactor;
  }

  // Responsive sizing based on screen height
  static double scaleHeight(double size, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = min(screenHeight / _designHeight, 2.0); // Max scale of 2.0
    return size * scaleFactor;
  }

  // Responsive sizing based on minimum of width and height scaling
  static double scale(double size, BuildContext context) {
    return min(scaleWidth(size, context), scaleHeight(size, context));
  }

  // Get responsive font size with minimum and maximum constraints
  static double responsiveFontSize(double size, BuildContext context,
      {double minSize = 12, double maxSize = 32}) {
    final scaledSize = scale(size, context);
    return max(minSize, min(maxSize, scaledSize));
  }

  // Check device type based on screen width
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletMinWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletMinWidth && width <= tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopMinWidth;
  }

  // Get adaptive padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context,
      {double mobile = 16, double tablet = 24, double desktop = 32}) {
    if (isMobile(context)) return EdgeInsets.all(mobile);
    if (isTablet(context)) return EdgeInsets.all(tablet);
    return EdgeInsets.all(desktop);
  }

  // Get responsive margin
  static EdgeInsets responsiveMargin(BuildContext context,
      {double mobile = 8, double tablet = 16, double desktop = 24}) {
    if (isMobile(context)) return EdgeInsets.all(mobile);
    if (isTablet(context)) return EdgeInsets.all(tablet);
    return EdgeInsets.all(desktop);
  }

  // Get responsive button size
  static Size responsiveButtonSize(BuildContext context,
      {double width = double.infinity,
      double heightMobile = 48,
      double heightTablet = 52,
      double heightDesktop = 56}) {
    final responsiveHeight = isMobile(context)
        ? heightMobile
        : isTablet(context)
            ? heightTablet
            : heightDesktop;

    return Size(
      width == double.infinity ? double.infinity : scaleWidth(width, context),
      responsiveHeight,
    );
  }

  // Responsive grid columns
  static int responsiveGridColumns(BuildContext context,
      {int mobile = 2, int tablet = 3, int desktop = 4}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Responsive spacing multiplier
  static double responsiveSpacing(BuildContext context,
      {double mobile = 1.0, double tablet = 1.2, double desktop = 1.5}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Safe area aware sizing
  static double safeHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
           MediaQuery.of(context).padding.top -
           MediaQuery.of(context).padding.bottom;
  }

  static double safeWidth(BuildContext context) {
    return MediaQuery.of(context).size.width -
           MediaQuery.of(context).padding.left -
           MediaQuery.of(context).padding.right;
  }

  // Orientation aware sizing
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double responsiveWidth(BuildContext context, double percentage) {
    return safeWidth(context) * (percentage / 100);
  }

  static double responsiveHeight(BuildContext context, double percentage) {
    return safeHeight(context) * (percentage / 100);
  }
}

/// Extension methods for easier responsive usage
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  bool get isLandscape => ResponsiveUtils.isLandscape(this);

  double responsiveScale(double size) => ResponsiveUtils.scale(size, this);

  double responsiveFontSize(double size,
          {double minSize = 12, double maxSize = 32}) =>
      ResponsiveUtils.responsiveFontSize(size, this,
          minSize: minSize, maxSize: maxSize);

  EdgeInsets responsivePadding(
          {double mobile = 16, double tablet = 24, double desktop = 32}) =>
      ResponsiveUtils.responsivePadding(this,
          mobile: mobile, tablet: tablet, desktop: desktop);

  EdgeInsets responsiveMargin(
          {double mobile = 8, double tablet = 16, double desktop = 24}) =>
      ResponsiveUtils.responsiveMargin(this,
          mobile: mobile, tablet: tablet, desktop: desktop);

  Size responsiveButtonSize(
          {double width = double.infinity,
          double heightMobile = 48,
          double heightTablet = 52,
          double heightDesktop = 56}) =>
      ResponsiveUtils.responsiveButtonSize(this,
          width: width,
          heightMobile: heightMobile,
          heightTablet: heightTablet,
          heightDesktop: heightDesktop);

  int responsiveGridColumns({int mobile = 2, int tablet = 3, int desktop = 4}) =>
      ResponsiveUtils.responsiveGridColumns(this,
          mobile: mobile, tablet: tablet, desktop: desktop);

  double responsiveWidth(double percentage) =>
      ResponsiveUtils.responsiveWidth(this, percentage);

  double responsiveHeight(double percentage) =>
      ResponsiveUtils.responsiveHeight(this, percentage);

  double get safeWidth => ResponsiveUtils.safeWidth(this);
  double get safeHeight => ResponsiveUtils.safeHeight(this);
}

/// Responsive builder widget for complex layouts
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, BoxConstraints, bool) builder;

  const ResponsiveBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        return builder(context, constraints, isLandscape);
      },
    );
  }
}

/// Responsive container that adapts to screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? maxWidth;
  final double? maxHeight;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
    this.maxHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding ?? context.responsivePadding();
    final responsiveMargin = margin ?? context.responsiveMargin();

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? context.safeWidth,
        maxHeight: maxHeight ?? context.safeHeight,
      ),
      padding: responsivePadding,
      margin: responsiveMargin,
      child: child,
    );
  }
}
