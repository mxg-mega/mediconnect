import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return SvgPicture.asset(
      'assets/svg/Rx.svg',
      height: context.figmaHeight(36),
      width: context.figmaWidth(58.0),
      colorFilter: ColorFilter.mode(
        colors.neutral.buttonTextWhite,
        BlendMode.srcIn,
      ),
    );
  }
}
