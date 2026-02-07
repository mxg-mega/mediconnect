import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class KInputContainer extends ConsumerWidget {
  const KInputContainer({
    super.key,
    this.prefix,
    this.suffix,
    this.onSuffixTap,
    required this.child,
    this.borderRadius = 8,
    this.borderWidth = 0.5,
    this.borderColor,
    this.prefixSpacing = 8,
    this.suffixSpacing = 8,
  });

  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onSuffixTap;
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final double prefixSpacing;
  final double suffixSpacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppTheme.colors(context).neutral.border,
          width: borderWidth,
        ),
      ),
      child: Row(
        children: [
          prefix ?? const SizedBox.shrink(),
          if (prefix != null) SizedBox(width: prefixSpacing),
          Expanded(child: child),
          if (suffix != null) SizedBox(width: suffixSpacing),
          suffix != null
              ? GestureDetector(onTap: onSuffixTap, child: suffix!)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
