import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class KInputField extends ConsumerWidget {
  const KInputField({
    super.key,
    this.prefix,
    this.suffix,
    required this.hintText,
    required this.controller,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isPasswordField = false,
    this.visibilityProvider,
  });

  final String hintText;
  final TextEditingController controller;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final StateProvider<bool>? visibilityProvider;

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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.colors(context).neutral.border),
      ),
      child: Row(
        children: [
          prefix ?? const SizedBox.shrink(),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              obscureText: effectiveObscureText,
              keyboardType: keyboardType,
              controller: controller,
              decoration: InputDecoration(hintText: hintText),
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
