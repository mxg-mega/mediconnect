import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mediconnect/core/router/app_router.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
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
    final themeMode = ref.watch(themeDataProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'MedConnect',
      theme: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
