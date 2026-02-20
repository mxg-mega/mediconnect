import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/router/app_router.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/core/theme/theme_provider.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        // Override the useLocalAuth provider to enable local dummy auth
        useLocalAuthProvider.overrideWithValue(true),
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
