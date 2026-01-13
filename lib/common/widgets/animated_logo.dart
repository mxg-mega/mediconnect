import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediconnect/common/widgets/logo.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    this.scale = 1.0,
    required this.logoTextScale,
    required this.textTranslateX,
  });

  final double scale;
  final double logoTextScale;
  final double textTranslateX;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final safeScale = scale.clamp(0.001, double.infinity);

    return Transform.scale(
      scale: scale,
      child: Container(
        decoration: ShapeDecoration(
          shape: StarBorder.polygon(sides: 6.0),
          color: colors.neutral.bg00,
        ),
        height: context.figmaHeight(90.33),
        width: context.figmaWidth(80),
        child: Transform.translate(
          offset: Offset(textTranslateX, 0),
          child: Center(
            child: Transform.scale(
              scale: (1 / safeScale) * logoTextScale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Logo(),
                  SizedBox(width: context.figmaWidth(4)),
                  Transform.scale(
                    scale: 0.00,
                    child: Text(
                      'MedConnect',
                      style: GoogleFonts.poppins(
                        color: colors.neutral.buttonTextWhite,
                        fontSize: context.figmaFontSize(32),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
