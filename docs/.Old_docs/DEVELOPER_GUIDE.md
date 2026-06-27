# MedConnect Developer Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [State Management with Riverpod](#state-management-with-riverpod)
4. [Navigation](#navigation)
5. [Authentication](#authentication)
6. [App Configuration](#app-configuration)
7. [Development Setup](#development-setup)
8. [Best Practices](#best-practices)
9. [Common Patterns](#common-patterns)

## Project Overview

MedConnect is a Flutter application that connects patients with pharmacists for medication management. The app supports two user types:
- **Patients**: Can browse medications, place orders, and manage prescriptions
- **Pharmacists**: Can manage inventory, process orders, and provide consultations

## Architecture

The project follows Clean Architecture principles with clear separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── constants/          # App constants
│   ├── errors/            # Error handling
│   ├── network/           # Network layer
│   ├── providers/         # Dependency injection
│   ├── router/            # Navigation
│   ├── theme/            # UI theming
│   └── utils/            # Utility functions
├── common/                # Shared features
│   ├── auth/             # Authentication
│   ├── onboarding/       # Onboarding flow
│   ├── models/           # Data models
│   ├── services/         # Shared services
│   └── widgets/          # Reusable widgets
└── main.dart            # App entry point
```

### Layer Structure

1. **Presentation Layer**: UI components, providers, and state management
2. **Domain Layer**: Business logic, entities, and use cases
3. **Data Layer**: Repositories, data sources, and models

## State Management with Riverpod

We use Riverpod for state management, which provides:
- Type-safe dependency injection
- Automatic disposal of resources
- Easy testing and mocking
- Hot reload support

### Provider Types

#### 1. Provider
For immutable data that doesn't change:
```dart
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig();
});
```

#### 2. StateNotifierProvider
For mutable state that can change over time:
```dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    signUpUseCase: ref.watch(signUpUseCaseProvider),
    signInUseCase: ref.watch(signInUseCaseProvider),
    // ... other dependencies
  );
});
```

#### 3. FutureProvider
For async operations that return a single value:
```dart
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return await authRepository.getCurrentUser();
});
```

### Using Providers in Widgets

#### ConsumerWidget
For widgets that need to read providers:
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoading = ref.watch(authProvider.select((state) => state.isLoading));
    
    return Text('Status: ${authState.status}');
  }
}
```

#### ConsumerStatefulWidget
For stateful widgets that need providers:
```dart
class MyStatefulWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider.notifier);
    
    return ElevatedButton(
      onPressed: () => authNotifier.signOut(),
      child: Text('Sign Out'),
    );
  }
}
```

### Provider Overrides

You can override providers for testing or different environments:
```dart
void main() {
  runApp(
    ProviderScope(
      overrides: [
        useLocalAuthProvider.overrideWithValue(true), // Use local auth for development
      ],
      child: MyApp(),
    ),
  );
}
```

## Navigation

We use GoRouter for navigation, which provides:
- Declarative routing
- Type-safe navigation
- Deep linking support
- Nested routing

### Router Configuration

The router is configured in `lib/core/router/app_router.dart`:

```dart
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
```

### Navigation Methods

#### Programmatic Navigation
```dart
// Navigate to a route
context.go('/home');

// Push a new route
context.push('/profile');

// Replace current route
context.pushReplacement('/login');

// Pop current route
context.pop();
```

#### Conditional Navigation
```dart
class AuthGuard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return switch (authState.status) {
      AuthStatus.authenticated => const HomeScreen(),
      AuthStatus.unauthenticated => const LoginScreen(),
      AuthStatus.loading => const LoadingScreen(),
      _ => const SplashScreen(),
    };
  }
}
```

## Authentication

The authentication system supports both local dummy data and real backend integration.

### Authentication Flow

1. **Splash Screen**: Checks if user is already authenticated
2. **Onboarding**: First-time user experience
3. **Login/Signup**: User authentication
4. **Home**: Main app interface

### Auth State Management

```dart
enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final Pharmacy? pharmacy;
  final String? errorMessage;
  
  // ... getters and methods
}
```

### Using Authentication

#### Sign In
```dart
final authNotifier = ref.read(authProvider.notifier);
await authNotifier.signIn(
  email: 'user@example.com',
  password: 'password123',
);
```

#### Sign Up
```dart
await authNotifier.signUp(
  email: 'user@example.com',
  password: 'password123',
  firstName: 'John',
  lastName: 'Doe',
  phoneNumber: '1234567890',
);
```

#### Sign Out
```dart
await authNotifier.signOut();
```

#### Check Authentication Status
```dart
final isAuthenticated = ref.watch(isAuthenticatedProvider);
final currentUser = ref.watch(currentUserProvider);
```

### Dummy Users for Development

When `useLocalAuth` is enabled, you can use these dummy accounts:

**Patient Account:**
- Email: `patient@example.com`
- Password: `password123`

**Pharmacist Account:**
- Email: `pharmacist@example.com`
- Password: `password123`

## App Configuration

### Environment Configuration

The app supports different configurations for development, staging, and production:

```dart
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.medconnect.com',
  );
  
  static const bool isDebug = bool.fromEnvironment('DEBUG', defaultValue: true);
  
  static const String userTypePatient = 'patient';
  static const String userTypePharmacist = 'pharmacist';
}
```

### Theme Configuration

The app supports both light and dark themes:

```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    // ... other theme properties
  );
  
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    // ... other theme properties
  );
}
```

### Network Configuration

The Dio client is configured with appropriate timeouts and interceptors:

```dart
class DioClient {
  late final Dio _dio;
  
  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }
}
```

## Development Setup

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate code (if needed):
   ```bash
   flutter packages pub run build_runner build
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Development Commands

```bash
# Install dependencies
flutter pub get

# Generate code
flutter packages pub run build_runner build

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .

# Clean build
flutter clean
```

## Best Practices

### 1. State Management
- Use `ref.watch()` for reactive updates
- Use `ref.read()` for one-time reads or actions
- Use `ref.listen()` for side effects
- Keep state immutable and use `copyWith()` for updates

### 2. Error Handling
- Always handle errors in async operations
- Use proper error types (AuthException, NetworkException, etc.)
- Show user-friendly error messages
- Log errors for debugging

### 3. Code Organization
- Follow the established folder structure
- Keep widgets small and focused
- Extract reusable components
- Use meaningful names for variables and functions

### 4. Testing
- Write unit tests for business logic
- Write widget tests for UI components
- Mock external dependencies
- Test error scenarios

### 5. Performance
- Use `const` constructors where possible
- Avoid unnecessary rebuilds
- Use `ListView.builder` for large lists
- Optimize images and assets

## Common Patterns

### 1. Loading States
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    if (authState.isLoading) {
      return const CircularProgressIndicator();
    }
    
    if (authState.hasError) {
      return Text('Error: ${authState.errorMessage}');
    }
    
    return const MyContent();
  }
}
```

### 2. Form Validation
```dart
class LoginForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          // ... other fields
        ],
      ),
    );
  }
}
```

### 3. Responsive Design
```dart
class ResponsiveWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const DesktopLayout();
        } else {
          return const MobileLayout();
        }
      },
    );
  }
}
```

### 4. Dependency Injection
```dart
// Define providers for dependencies
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final repositoryProvider = Provider<Repository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return Repository(apiService);
});

// Use in widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(repositoryProvider);
    // Use repository...
  }
}
```

## Troubleshooting

### Common Issues

1. **Provider not found**: Make sure the widget is wrapped in `ProviderScope`
2. **Hot reload not working**: Restart the app or run `flutter clean`
3. **Build errors**: Run `flutter packages pub run build_runner build`
4. **Navigation issues**: Check route definitions in `app_router.dart`

### Debug Tips

1. Use `ref.debugDisposeProvider()` to debug provider disposal
2. Use `ProviderScope.containerOf(context).read(provider)` for debugging
3. Check the Flutter Inspector for widget tree issues
4. Use `print()` statements or logging for debugging

## Contributing

1. Follow the established code style
2. Write tests for new features
3. Update documentation as needed
4. Create pull requests for changes
5. Follow the commit message conventions

## Resources

- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Flutter Documentation](https://flutter.dev/docs)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
