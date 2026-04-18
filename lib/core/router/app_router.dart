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
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/personal_details_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/pharmacy_information_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/pharmacy_verification_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/preferences_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/notification_settings_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/display_settings_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/language_settings_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/security/security_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/security/change_password_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/security/contact_info_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/security/add_email_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/security/add_phone_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/security/security_code_verification_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/pages/security/security_success_page.dart';

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
import 'package:mediconnect/core/providers/settings_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final isSplashFinished = ref.watch(splashFinishedProvider);
  final settings = ref.watch(settingsProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,

    redirect: (context, state) {
      print('--- ROUTER REDIRECT TRIGGERED ---');
      print('Current Location: ${state.matchedLocation}');
      print('Splash Finished: $isSplashFinished');
      print('Auth Status: ${authState.status}');

      // 1. Wait for splash animation to finish
      if (!isSplashFinished) {
        print('Redirect: Waiting for splash to finish (returning null)');
        return null;
      }

      // 2. Wait for auth to initialize
      if (authState.status == AuthStatus.uninitialized) {
        print('Redirect: Auth is uninitialized (returning null)');
        return null;
      }

      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/signup';
      final isWelcome = state.matchedLocation == '/welcome';
      final isSplash = state.matchedLocation == '/';
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isVerification = state.matchedLocation == '/code-verification';
      final isFinalization = state.matchedLocation == '/setup-finalization';
      final isCapture = state.matchedLocation == '/information-capture';

      print('Is Logged In: $isLoggedIn');
      print('Has Seen Onboarding: ${settings.hasSeenOnboarding}');

      final isAuthFlow =
          isLoggingIn ||
          isSigningUp ||
          isWelcome ||
          isVerification ||
          isFinalization ||
          isCapture;

      // 3. Unauthenticated flow
      if (!isLoggedIn) {
        if (!settings.hasSeenOnboarding) {
          if (isOnboarding) {
            print(
              'Redirect: Unauthenticated, not seen onboarding, already on onboarding (returning null)',
            );
            return null;
          }
          print(
            'Redirect: Unauthenticated, not seen onboarding -> going to /onboarding',
          );
          return '/onboarding';
        }

        // If they've seen onboarding, they must be on an auth page or login
        // We removed `|| isSplash` here so that the splash screen actually redirects to login when finished!
        if (isAuthFlow || isOnboarding) {
          print(
            'Redirect: Unauthenticated, seen onboarding, on auth flow -> returning null',
          );
          return null;
        }

        if (isSplash) {
          print(
            'Redirect: Unauthenticated, seen onboarding, currently on splash -> redirecting to /login',
          );
        } else {
          print(
            'Redirect: Unauthenticated, seen onboarding, unexpected location -> going to /login',
          );
        }
        return '/login';
      }

      // 4. Authenticated flow
      final user = authState.user;
      final role = user?.userType ?? UserType.unknown;
      final isProfileComplete = user?.isProfileComplete ?? false;

      print('Role: $role');
      print('Is Profile Complete: $isProfileComplete');

      // a. Role selection
      if (role == UserType.unknown) {
        if (isFinalization) {
          print(
            'Redirect: Authenticated, unknown role, on setup-finalization (returning null)',
          );
          return null;
        }
        print(
          'Redirect: Authenticated, unknown role -> going to /setup-finalization',
        );
        return '/setup-finalization';
      }

      // b. Information capture
      if (!isProfileComplete) {
        if (isCapture) {
          print(
            'Redirect: Authenticated, profile incomplete, on capture (returning null)',
          );
          return null;
        }
        print(
          'Redirect: Authenticated, profile incomplete -> going to /information-capture',
        );
        return '/information-capture';
      }

      // c. Welcome (Success) Page - User lands here after capture
      // If they are logged in and complete but still on auth/setup pages, show Welcome
      if (isAuthFlow || isSplash || isOnboarding) {
        if (isWelcome) {
          print(
            'Redirect: Authenticated, profile complete, on welcome (returning null)',
          );
          return null;
        }
        print(
          'Redirect: Authenticated, profile complete, on auth/splash -> going to /welcome (or pharmacist/dashboard)',
        );

        // Let's redirect to dashboard instead of welcome if role is complete?
        // Let's just print for now and redirect to welcome.
        return '/welcome';
      }

      print('Redirect: Allow normal navigation (returning null)');
      return null;
    },

    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/code-verification',
        name: 'code-verification',
        builder: (context, state) {
          final nextPage = state.extra as Widget?;
          if (nextPage == null) {
            return const Scaffold(
              body: Center(child: Text('No page to navigate to')),
            );
          }
          return CodeVerificationPage(nextPage: nextPage);
        },
      ),
      GoRoute(
        path: '/setup-finalization',
        builder: (context, state) => const SetupFinalizationPage(),
      ),
      GoRoute(
        path: '/information-capture',
        builder: (context, state) {
          final authState = ref.read(authProvider);
          final savedRole = authState.user?.userType;
          
          final role = state.extra as UserType? ?? savedRole ?? UserType.patient;
          
          print("Information Capture Route Builder:");
          print(" - state.extra: ${state.extra}");
          print(" - authState.user.userType: $savedRole");
          print(" - Resolved Role: $role");
          
          return InformationCapturePage(role: role);
        },
      ),

      // Pharmacist Shell (Pages WITH bottom nav)
      ShellRoute(
        builder: (context, state, child) => PharmacistMainPage(child: child),
        routes: [
          GoRoute(
            path: '/pharmacist/dashboard',
            builder: (context, state) => const PharmacistDashboard(),
          ),
          GoRoute(
            path: '/pharmacist/inventory',
            builder: (context, state) => const InventoryPage(),
          ),
          GoRoute(
            path: '/pharmacist/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Pharmacist Full Screen Pages (WITHOUT bottom nav)
      GoRoute(
        path: '/pharmacist/profile/personal-details',
        builder: (context, state) => const PersonalDetailsPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/pharmacy-information',
        builder: (context, state) => const PharmacyInformationPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/pharmacy-verification',
        builder: (context, state) => const PharmacyVerificationPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/preferences',
        builder: (context, state) => const PreferencesPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/notification-settings',
        builder: (context, state) => const NotificationSettingsPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/display-settings',
        builder: (context, state) => const DisplaySettingsPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/language-settings',
        builder: (context, state) => const LanguageSettingsPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/security',
        builder: (context, state) => const SecurityPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/security/change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/security/contact-info',
        builder: (context, state) => const ContactInfoPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/security/add-email',
        builder: (context, state) => const AddEmailPage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/security/add-phone',
        builder: (context, state) => const AddPhonePage(),
      ),
      GoRoute(
        path: '/pharmacist/profile/security/verification',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return SecurityCodeVerificationPage(data: data);
        },
      ),
      GoRoute(
        path: '/pharmacist/profile/security/success',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return SecuritySuccessPage(data: data);
        },
      ),
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
          GoRoute(
            path: 'export',
            builder: (context, state) => const ExportReceiptPage(),
          ),
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
          GoRoute(
            path: '/patient/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/patient/search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: '/patient/activity',
            builder: (context, state) => const ActivityPage(),
          ),
          GoRoute(
            path: '/patient/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
});
