import 'package:flutter/material.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class KFormField extends StatelessWidget {
  const KFormField({
    super.key,
    this.prefix,
    this.suffix,
    required this.hintText,
    this.controller,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.maxLines,
    this.minLines,
    this.maxLength,
  });

  final String hintText;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        prefix: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: prefix,
        ),
        suffix: suffix != null
            ? GestureDetector(onTap: onSuffixTap, child: suffix!)
            : null,
        hintText: hintText,
        // find a way to make the hint appear at the bottom right of a field that has a minimum lines of 5
        hintStyle: AppTextStyles.interP16R.copyWith(
          color: AppTheme.colors(context).neutral.placeholderDisabled,
        ),
        errorStyle: AppTextStyles.interP16R.copyWith(
          color: AppTheme.colors(context).support.red,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          vertical: context.figmaHeight(16),
          horizontal: context.figmaWidth(12),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //         color: AppTheme.colors(context).neutral.border,
  //         width: 1,
  //       ),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         if (prefix != null)
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: context.figmaWidth(12)),
  //             child: prefix ?? const SizedBox.shrink(),
  //           ),
  //         // if (prefix != null) const SizedBox(width: 8),
  //         Expanded(
  //           child: TextFormField(
  //             obscureText: obscureText,
  //             keyboardType: keyboardType,
  //             validator: validator,
  //             controller: controller,
  //             decoration: InputDecoration(
  //               hintText: hintText,
  //               border: InputBorder.none,
  //               contentPadding: EdgeInsets.symmetric(
  //                 vertical: context.figmaHeight(16),
  //                 horizontal: context.figmaWidth(12),
  //               ),
  //             ),
  //           ),
  //         ),
  //         suffix != null
  //  GestureDetector(onTap: onSuffixTap, child: suffix!)
  //             : const SizedBox.shrink(),
  //       ],
  //     ),
  //   );
  // }
}
