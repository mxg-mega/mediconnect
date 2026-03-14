import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';
import 'package:mediconnect/common/widgets/providers/k_button_provider.dart';

class KElevatedButton extends ConsumerWidget {
  const KElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.useProvider = false,
    this.buttonId,
    this.role,
    this.useRoleBasedStyling = true,
  });

  final void Function()? onPressed;
  final Widget child;
  final Color? color;
  final bool useProvider;
  final String? buttonId;
  final UserRole? role;
  final bool useRoleBasedStyling;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use provider-based state if enabled
    if (useProvider) {
      return _KElevatedButtonWithProvider(
        onPressed: onPressed,
        color: color,
        buttonId: buttonId,
        role: role,
        useRoleBasedStyling: useRoleBasedStyling,
        child: child,
      );
    }

    // Original implementation for backward compatibility
    final effectiveRole =
        role ?? ref.watch(appScaffoldProvider.notifier).getEffectiveRole();
    final globalLoading = ref.watch(
      appScaffoldProvider.select((state) => state.isLoading),
    );
    final isActuallyLoading = globalLoading;

    Color? getRoleBasedColor() {
      if (!useRoleBasedStyling || color != null) return color;

      switch (effectiveRole) {
        case UserRole.patient:
          return AppTheme.colors(context).patient.bg;
        case UserRole.pharmacist:
          return AppTheme.colors(context).pharmacist.bg;
        case UserRole.none:
        default:
          return AppTheme.colors(context).neutral.bg00;
      }
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: getRoleBasedColor(),
        disabledBackgroundColor: AppTheme.colors(context).neutral.bg00,
        minimumSize: Size(
          // double.infinity, --- IGNORE ---
          //  look more into a better way to handle this
          MediaQuery.widthOf(context) - 16 ,
          context.figmaHeight(50),
        ),
      ),
      onPressed: isActuallyLoading ? null : onPressed,
      child: isActuallyLoading
          ? SizedBox(
              height: context.figmaHeight(20),
              width: context.figmaHeight(20),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.colors(context).neutral.bgTint,
                ),
              ),
            )
          : child,
    );
  }
}

class _KElevatedButtonWithProvider extends ConsumerWidget {
  const _KElevatedButtonWithProvider({
    required this.onPressed,
    required this.child,
    this.color,
    this.buttonId,
    this.role,
    this.useRoleBasedStyling = true,
  });

  final void Function()? onPressed;
  final Widget child;
  final Color? color;
  final String? buttonId;
  final UserRole? role;
  final bool useRoleBasedStyling;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use button-specific provider if buttonId is provided, otherwise use global
    final buttonState = buttonId != null
        ? ref.watch(kButtonFamilyProvider(buttonId!))
        : ref.watch(kButtonProvider);

    final effectiveRole = role ?? ref.watch(kButtonRoleProvider);
    final isActuallyLoading = buttonState.isLoading || buttonState.isDisabled;

    Color? getRoleBasedColor() {
      if (!useRoleBasedStyling || color != null) return color;

      switch (effectiveRole) {
        case UserRole.patient:
          return AppTheme.colors(context).patient.bg;
        case UserRole.pharmacist:
          return AppTheme.colors(context).pharmacist.bg;
        case UserRole.none:
        default:
          return AppTheme.colors(context).neutral.bg;
      }
    }

    Widget buildButtonContent() {
      if (buttonState.isLoading) {
        return SizedBox(
          height: context.figmaHeight(20),
          width: context.figmaHeight(20),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.colors(context).neutral.bgTint,
            ),
          ),
        );
      }

      if (buttonState.isSuccess) {
        return Icon(
          Icons.check_circle,
          color: AppTheme.colors(context).neutral.bgTint,
          size: context.figmaHeight(20),
        );
      }

      if (buttonState.hasError) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              color: AppTheme.colors(context).neutral.bgTint,
              size: context.figmaHeight(16),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                buttonState.errorMessage!,
                style: TextStyle(
                  color: AppTheme.colors(context).neutral.bgTint,
                  fontSize: context.figmaFontSize(12),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }

      return child;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: getRoleBasedColor(),
        disabledBackgroundColor: AppTheme.colors(
          context,
        ).neutral.placeholderDisabled,
        minimumSize: Size(double.infinity, context.figmaHeight(50)),
      ),
      onPressed: isActuallyLoading ? null : onPressed,
      child: buildButtonContent(),
    );
  }
}
