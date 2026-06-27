# MedConnect - Quick Start Guide

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2+
- Dart SDK 3.9.2+
- Android Studio/VS Code with Flutter extensions

### Setup Steps

1. **Clone and Install**
   ```bash
   git clone <repository-url>
   cd mediconnect
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Test Authentication**
   - Use dummy credentials (local auth is enabled by default):
     - **Patient**: `patient@example.com` / `password123`
     - **Pharmacist**: `pharmacist@example.com` / `password123`

## 🏗️ Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── providers/          # Dependency injection (Riverpod)
│   ├── router/            # Navigation (GoRouter)
│   ├── theme/             # UI theming
│   └── network/           # HTTP client (Dio)
├── common/                 # Shared features
│   ├── auth/              # Authentication system
│   ├── onboarding/        # Onboarding flow
│   └── widgets/           # Reusable components
└── main.dart              # App entry point
```

## 🔧 Key Technologies

- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Architecture**: Clean Architecture
- **Storage**: Flutter Secure Storage

## 📱 Development Features

### Local Authentication
The app runs with dummy data by default. To switch to real backend:
```dart
// In lib/core/providers/dependency_providers.dart
final useLocalAuthProvider = Provider<bool>((ref) => false); // Change to false
```

### State Management
```dart
// Reading state
final authState = ref.watch(authProvider);
final isAuthenticated = ref.watch(isAuthenticatedProvider);

// Performing actions
final authNotifier = ref.read(authProvider.notifier);
await authNotifier.signIn(email: 'user@example.com', password: 'password');
```

### Navigation
```dart
// Navigate to routes
context.go('/home');
context.push('/profile');
context.pop();
```

## 🎨 UI Development

### Theme Usage
```dart
// Access theme in widgets
Theme.of(context).colorScheme.primary
Theme.of(context).textTheme.headlineMedium
```

### Responsive Design
```dart
// Use LayoutBuilder for responsive layouts
LayoutBuilder(
  builder: (context, constraints) {
    return constraints.maxWidth > 600 
        ? DesktopLayout() 
        : MobileLayout();
  },
)
```

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Test Authentication
```dart
// Mock providers for testing
final container = ProviderContainer(
  overrides: [
    authProvider.overrideWith((ref) => MockAuthNotifier()),
  ],
);
```

## 🐛 Common Issues

1. **Provider not found**: Ensure widget is wrapped in `ProviderScope`
2. **Build errors**: Run `flutter packages pub run build_runner build`
3. **Navigation issues**: Check routes in `lib/core/router/app_router.dart`

## 📚 Resources

- [Full Developer Guide](./DEVELOPER_GUIDE.md)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Flutter Documentation](https://flutter.dev/docs)

## 🤝 Contributing

1. Follow the established code style
2. Write tests for new features
3. Update documentation
4. Create pull requests

---

**Happy Coding! 🎉**
