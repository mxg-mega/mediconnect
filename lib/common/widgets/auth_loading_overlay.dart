import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';

/// A full-screen overlay shown during [AuthStatus.loading] states.
///
/// This widget wraps the app's entire widget tree via [MaterialApp.router]'s
/// `builder` property. It watches [authProvider] exclusively, so it only
/// activates for auth operations (sign-in, sign-up, OTP verification,
/// profile updates) and never for feature-level loaders like inventory.
///
/// It is suppressed on the splash screen ('/') to avoid a double-loader
/// on cold-start when [_checkCurrentUser] runs.
class AuthLoadingOverlay extends ConsumerWidget {
  const AuthLoadingOverlay({
    required this.child,
    required this.currentLocation,
    super.key,
  });

  final Widget child;

  /// The current matched GoRouter location, used to suppress the overlay
  /// on the splash screen during cold-start initialisation.
  final String currentLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch the auth loading state — nothing else.
    final isAuthLoading = ref.watch(
      authProvider.select((s) => s.isLoading),
    );

    // Suppress overlay on splash screen: the splash screen has its own
    // animated loading indicator and the cold-start user-check runs there.
    final isSplash = currentLocation == '/';

    final showOverlay = isAuthLoading && !isSplash;

    return Stack(
      children: [
        child,
        if (showOverlay)
          // ModalBarrier absorbs all touches — prevents double-taps.
          const ModalBarrier(dismissible: false, color: Colors.transparent),
        if (showOverlay)
          _AuthLoadingIndicator(),
      ],
    );
  }
}

class _AuthLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barrierColor =
        isDark ? Colors.black.withAlpha(153) : Colors.black.withAlpha(102);
    final indicatorColor = Theme.of(context).colorScheme.primary;

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: barrierColor,
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1E1E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
