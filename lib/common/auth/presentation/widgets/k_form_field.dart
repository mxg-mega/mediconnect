import 'package:flutter/material.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class KFormField extends StatelessWidget {
  const KFormField({
    super.key,
    this.prefix,
    this.suffix,
    required this.hintText,
    required this.controller,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final String hintText;
  final TextEditingController controller;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
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
            child: TextFormField(
              obscureText: obscureText,
              keyboardType: keyboardType,
              validator: validator,
              controller: controller,
              decoration: InputDecoration(hintText: hintText),
            ),
          ),
          suffix != null
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: prefix!,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
