import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class AuthMethodButton extends StatelessWidget {
  const AuthMethodButton({
    super.key,
    this.path,
    required this.onPressed,
    required this.label,
  });

  final String? path;
  final void Function() onPressed;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, context.figmaHeight(50)),
      ),
      onPressed: onPressed,
      label: label,
      icon: path != null
          ? SvgPicture.asset(
              path!,
              width: context.figmaWidth(22.7),
              height: context.figmaHeight(22.7),
            )
          : null,
    );
  }
}
