# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 📋 Common Development Commands

### Dependency Management
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies
- `flutter pub outdated` - Check for outdated dependencies

### Running the App
- `flutter run` - Run the app on a connected device/emulator
- `flutter run -d chrome` - Run on web (Chrome)
- `flutter run --release` - Run in release mode

### Testing
- `flutter test` - Run all unit and widget tests
- `flutter test --coverage` - Run tests with coverage report
- `flutter test test/<specific_test_file.dart>` - Run a specific test file

### Code Quality
- `flutter analyze` - Run static analysis (linter)
- `dart format .` - Format code according to Dart style
- `flutter packages pub run build_runner build` - Generate code (for JSON serializable, etc.)

### Build & Release
- `flutter clean` - Clean build artifacts
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter build web` - Build for web

### Authentication (Development)
The app uses dummy authentication by default for development:
- **Patient**: `patient@example.com` / `password123`
- **Pharmacist**: `pharmacist@example.com` / `password123`

To switch to real backend, modify `useLocalAuthProvider` in `lib/core/providers/dependency_providers.dart` to `false`.

## 🏗️ High-Level Architecture

### Overall Structure
The project follows Clean Architecture with separation into layers:
```
lib/
├── core/                    # Core functionality (providers, router, theme, network, utils)
├── common/                  # Shared features (auth, onboarding, widgets)
└── main.dart                # App entry point
```

### Key Technologies
- **State Management**: Riverpod (ProviderScope, StateNotifierProvider, FutureProvider)
- **Navigation**: GoRouter (declarative routing, ShellRoute for nested navigation)
- **HTTP Client**: Dio (with interceptors and timeout configuration)
- **Architecture**: Clean Architecture (Presentation, Domain, Data layers)
- **Local Storage**: Hive + Flutter Secure Storage
- **Dependency Injection**: Riverpod providers

### State Management with Riverpod
- Use `ref.watch()` for reactive state updates
- Use `ref.read()` for one-time reads or to perform actions
- Providers are defined in `lib/core/providers/dependency_providers.dart`
- Override providers for testing or environment changes in `main.dart`

### Navigation with GoRouter
- Router configuration in `lib/core/router/app_router.dart`
- Use `context.go('/path')` for navigation
- ShellRoute used for bottom navigation tabs (patient/pharmacist shells)
- Redirect logic handles auth flow, onboarding, splash screen

### Authentication Flow
1. Splash screen checks initialization
2. Onboarding for first-time users
3. Auth pages (login/signup) or verification
4. Role-based home screens (patient/pharmacist dashboards)
5. Auth state managed via `authProvider` (StateNotifierProvider)

### Domain Layer
- Entities (business objects) in `lib/features/*/domain/entities/`
- Use cases (interactors) in `lib/features/*/domain/usecases/`
- Repositories (interfaces) in `lib/features/*/domain/repositories/`

### Data Layer
- Repositories implementations in `lib/features/*/data/`
- Data sources (local/remote) in `lib/features/*/data/datasources/`
- Models (JSON serializable) in `lib/features/*/data/models/`

### Presentation Layer
- Pages/screens in `lib/features/*/presentation/pages/`
- Providers (state) in `lib/features/*/presentation/providers/`
- Widgets/components in `lib/features/*/presentation/widgets/`

## 🔧 Development Tips

### Working with Providers
- For widgets needing state: extend `ConsumerWidget` or `ConsumerStatefulWidget`
- Access providers with `ref.watch(provider)` or `ref.read(provider.notifier)`
- Override providers in tests using `ProviderContainer` with overrides

### Handling Navigation
- Avoid `GoRouterState.of(context)` in builders above router scope
- Read router from provider: `ref.read(goRouterProvider)`
- Get current location: `router.routerDelegate?.currentConfiguration?.fullPath ?? ''`

### Code Organization
- Keep widgets small and focused
- Extract reusable components to `common/widgets/`
- Follow existing naming conventions and architecture patterns
- Add tests for new business logic and UI components

### Debugging
- Check console for redirect logs from router (tagged with '--- ROUTER REDIRECT TRIGGERED ---')
- Use Flutter DevTools for widget inspection and performance profiling
- Verify provider overrides in `main.dart` when switching environments
