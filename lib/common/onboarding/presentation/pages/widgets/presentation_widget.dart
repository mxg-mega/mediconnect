import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class PresentationWidget extends StatelessWidget {
  const PresentationWidget({
    super.key,
    required this.svgPath,
    required this.title,
    required this.description,
  });

  final String svgPath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          width: context.figmaWidth(392),
          height: context.figmaHeight(320),
        ),
        Text(
          title,
          style: AppTheme.textTheme(
            context,
          ).headlineMedium!.copyWith(fontSize: context.figmaFontSize(24)),
          textAlign: TextAlign.center,
        ),
        Text(
          description,
          style: AppTheme.textTheme(context).headlineSmall!.copyWith(
            fontSize: context.figmaFontSize(18),
            color: AppTheme.colors(context).neutral.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
        // ElevatedButton(onPressed: () {}, child: Text("Get Started")),
      ],
    );
  }
}
