import 'package:flutter/material.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class DashedBorderContainer extends StatelessWidget {
  const DashedBorderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Container(
        padding: EdgeInsets.all(24),
        width: double.infinity,
        height: context.figmaHeight(231),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightTheme.neutral.border
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 6;
    const dashSpace = 4;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(8)),
      );

    final dashPath = Path();

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
