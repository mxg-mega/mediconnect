import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/presentation/pages/login_screen.dart';
import 'package:mediconnect/common/auth/presentation/pages/signup_screen.dart';
import 'package:mediconnect/common/auth/presentation/widgets/auth_wrapper.dart';
import 'package:mediconnect/common/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:mediconnect/features/patient_app/presentation/main_nav/patient_main_page.dart';

final GoRouter router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) {
    // Note: We'll handle onboarding redirect in the AuthWrapper for now
    // since GoRouter redirect doesn't have access to Riverpod context
    return null;
  },
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthWrapper();
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return const SignupScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/patient',
      builder: (BuildContext context, GoRouterState state) {
        return const PatientMainPage();
      },
    ),
  ],
);

