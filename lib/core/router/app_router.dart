import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/presentation/pages/login_screen.dart';
import 'package:mediconnect/common/auth/presentation/pages/password_and_verification/code_verification_page.dart';
import 'package:mediconnect/common/auth/presentation/pages/signup_screen.dart';
import 'package:mediconnect/common/auth/presentation/pages/welcome_page.dart';
import 'package:mediconnect/common/auth/presentation/pages/setup_finalization_page.dart';
import 'package:mediconnect/common/auth/presentation/pages/information_capture_page.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/common/widgets/splash_screen.dart';
import 'package:mediconnect/common/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:mediconnect/features/patient_app/presentation/activity/activity_page.dart';
import 'package:mediconnect/features/patient_app/presentation/dashboard/dashboard_page.dart';
import 'package:mediconnect/features/patient_app/presentation/main_nav/patient_main_page.dart';
import 'package:mediconnect/features/patient_app/presentation/search/search_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/pages/dispense_entry_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/profile_page.dart';

import 'package:mediconnect/features/pharmacist_app/presentation/dashboard/pharmacist_main_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dashboard/pharmacist_dashboard.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/inventory_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/pages/inventory_item_view_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/pages/inventory_item_edit_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/medication_catalog/pages/medication_catalog_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/medication_catalog/pages/add_medication_page.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/common/domain/entities/medication.dart' as entity;
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_history/pages/dispense_history_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_history/pages/dispense_receipt_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_history/pages/export_receipt_page.dart';
import 'package:mediconnect/features/splash_screen/splash_controller.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final isSplashFinished = ref.watch(splashFinishedProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,

    redirect: (context, state) {
      if (!isSplashFinished) return null;
      if (authState.status == AuthStatus.uninitialized) return null;

      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/signup';
      final isWelcome = state.matchedLocation == '/welcome';
      final isSplash = state.matchedLocation == '/';
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isVerification = state.matchedLocation == '/code-verification';
      final isFinalization = state.matchedLocation == '/setup-finalization';
      final isCapture = state.matchedLocation == '/information-capture';
      
      final isAuthFlow = isLoggingIn || isSigningUp || isWelcome || isVerification || isFinalization || isCapture;
      final role = authState.user?.userType ?? UserType.unknown;

      if (!isLoggedIn) {
        if (isAuthFlow || isOnboarding) return null;
        return '/welcome';
      }

      if (isLoggedIn && (isAuthFlow || isSplash || isOnboarding)) {
        if (role == UserType.unknown) {
          return '/setup-finalization';
        } else if (role == UserType.patient) {
          return '/patient/dashboard';
        } else {
          return '/pharmacist/dashboard';
        }
      }

      return null;
    },

    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (context, state) => const WelcomePage()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/code-verification',
        name: 'code-verification',
        builder: (context, state) {
          final nextPage = state.extra as Widget?;
          if (nextPage == null) {
            return const Scaffold(body: Center(child: Text('No page to navigate to')));
          }
          return CodeVerificationPage(nextPage: nextPage);
        },
      ),
      GoRoute(path: '/setup-finalization', builder: (context, state) => const SetupFinalizationPage()),
      GoRoute(
        path: '/information-capture',
        builder: (context, state) {
          final role = state.extra as UserType? ?? UserType.patient;
          return InformationCapturePage(role: role);
        },
      ),

      // Pharmacist Shell (Pages WITH bottom nav)
      ShellRoute(
        builder: (context, state, child) => PharmacistMainPage(child: child),
        routes: [
          GoRoute(path: '/pharmacist/dashboard', builder: (context, state) => const PharmacistDashboard()),
          GoRoute(path: '/pharmacist/inventory', builder: (context, state) => const InventoryPage()),
          GoRoute(path: '/pharmacist/profile', builder: (context, state) => const ProfilePage()),
        ],
      ),

      // Pharmacist Full Screen Pages (WITHOUT bottom nav)
      GoRoute(
        path: '/pharmacist/inventory/item',
        builder: (context, state) {
          final item = state.extra as InventoryItem;
          return InventoryItemViewPage(item: item);
        },
      ),
      GoRoute(
        path: '/pharmacist/inventory/edit',
        builder: (context, state) {
          final item = state.extra as InventoryItem;
          return InventoryItemEditPage(item: item);
        },
      ),
      GoRoute(
        path: '/pharmacist/medication-catalog',
        builder: (context, state) => const MedicationCatalogPage(),
      ),
      GoRoute(
        path: '/pharmacist/add-medication',
        builder: (context, state) {
          final med = state.extra as entity.Medication?;
          return AddMedicationPage(medication: med);
        },
      ),
      GoRoute(
        path: '/pharmacist/dispense-history',
        builder: (context, state) => const DispenseHistoryPage(),
        routes: [
          GoRoute(
            path: 'receipt',
            builder: (context, state) {
              final record = state.extra as DispenseRecord?;
              return DispenseReceiptPage(record: record);
            },
          ),
          GoRoute(path: 'export', builder: (context, state) => const ExportReceiptPage()),
        ],
      ),
      GoRoute(
        path: '/dispense-entry',
        builder: (context, state) => const DispenseEntryPage(),
      ),

      // Patient Shell
      ShellRoute(
        builder: (context, state, child) => PatientMainPage(child: child),
        routes: [
          GoRoute(path: '/patient/dashboard', builder: (context, state) => const DashboardPage()),
          GoRoute(path: '/patient/search', builder: (context, state) => const SearchPage()),
          GoRoute(path: '/patient/activity', builder: (context, state) => const ActivityPage()),
          GoRoute(path: '/patient/profile', builder: (context, state) => const ProfilePage()),
        ],
      ),
    ],
  );
});
