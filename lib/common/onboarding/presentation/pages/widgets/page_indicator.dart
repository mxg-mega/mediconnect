import 'package:flutter/material.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class PageIndicator extends StatefulWidget {
  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.totalPages,
  });

  final int currentIndex;
  final int totalPages;

  @override
  State<PageIndicator> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalPages, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: widget.currentIndex == index ? context.figmaWidth(20) : context.figmaWidth(18),
          height: context.figmaHeight(8),
          decoration: BoxDecoration(
            color: widget.currentIndex == index
                ? AppColors.of(context).neutral.bg
                : AppColors.of(context).neutral.placeholderDisabled,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }
}
