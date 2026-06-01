import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/auth_loading_overlay.dart';
import 'package:mediconnect/core/router/app_router.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/common/auth/presentation/providers/pharmacy_auth_sync_provider.dart';
import 'package:mediconnect/core/theme/theme_provider.dart';
import 'package:mediconnect/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  // Note: For now, I'm wrapping this in a try-catch so the app still runs if not configured
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        // Set to false to use real Firebase Auth
        useLocalAuthProvider.overrideWithValue(false),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pharmacyAuthSyncProvider);
    final themeMode = ref.watch(themeDataProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'MedConnect',
      theme: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // The builder wraps every routed page so the overlay sits above
      // the entire navigation stack without interfering with routes.
      builder: (context, child) {
        final GoRouter router = ref.read(goRouterProvider);
        final String location = router.routerDelegate?.currentConfiguration?.fullPath ?? '';
        return AuthLoadingOverlay(
          currentLocation: location,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
