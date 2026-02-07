import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class KInputField extends ConsumerWidget {
  const KInputField({
    super.key,
    this.prefix,
    this.suffix,
    this.hintText,
    this.controller,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isPasswordField = false,
    this.visibilityProvider,
    this.child,
  }) : assert(
         child != null || (hintText != null && controller != null),
         'Either child must be provided or both hintText and controller must be provided',
       );

  final String? hintText;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final StateProvider<bool>? visibilityProvider;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasswordVisible = isPasswordField && visibilityProvider != null
        ? ref.watch(visibilityProvider!)
        : null;
    final togglePasswordVisibility =
        isPasswordField && visibilityProvider != null
        ? () => ref.read(visibilityProvider!.notifier).state = !ref.read(
            visibilityProvider!,
          )
        : null;

    Widget? effectiveSuffix = suffix;
    VoidCallback? effectiveOnSuffixTap = onSuffixTap;
    bool effectiveObscureText = obscureText;

    if (isPasswordField) {
      effectiveSuffix = SvgPicture.asset(
        isPasswordVisible ?? false ? AppIcons.eyeSlash : AppIcons.eyeOpen,
      );
      effectiveOnSuffixTap = togglePasswordVisibility;
      effectiveObscureText = !(isPasswordVisible ?? false);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.colors(context).neutral.border,
          // width: context.figmaWidth(1),
          width: .5,
        ),
      ),
      child: Row(
        children: [
          prefix ?? const SizedBox.shrink(),
          if (prefix != null) const SizedBox(width: 8),
          Expanded(
            child:
                child ??
                TextField(
                  obscureText: effectiveObscureText,
                  keyboardType: keyboardType,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                  ),
                ),
          ),
          effectiveSuffix != null
              ? GestureDetector(
                  onTap: effectiveOnSuffixTap,
                  child: effectiveSuffix,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
