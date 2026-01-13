import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/pages/home_screen.dart';
import 'package:mediconnect/common/auth/presentation/pages/login_screen.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:mediconnect/common/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:mediconnect/common/widgets/splash_screen.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _minSplashTimeDone = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 7), () {
      if (mounted) {
        setState(() {
          _minSplashTimeDone = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final onboardingState = ref.watch(onboardingProvider);

    if (!_minSplashTimeDone ||
        onboardingState.isLoading ||
        authState.status == AuthStatus.uninitialized) {
      return const SplashScreen();
    }

    if (!onboardingState.isOnboardingComplete) {
      return const OnboardingScreen();
    }

    if (authState.status == AuthStatus.authenticated) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
