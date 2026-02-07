# KElevatedButton - Role-Aware Enhanced Button

## Overview

The `KElevatedButton` is a role-aware, dynamic button component that integrates with the AppScaffold provider and offers both traditional and provider-based state management options. It provides consistent styling across different user roles (Patient, Pharmacist) and supports comprehensive loading states, error handling, and success feedback.

## Features

- **Role-Aware Styling**: Automatically adapts colors based on current user role
- **Dual State Management**: Traditional props-based OR provider-based state management
- **Advanced Loading States**: Supports local, global, and provider-based loading states
- **Error Handling**: Built-in error display with automatic state management
- **Success Feedback**: Visual success indicators with auto-reset
- **Flexible Configuration**: Can override role-based styling or specify explicit roles
- **Centralized Management**: Integrates with AppScaffold provider for consistent state management

## Usage Patterns

### 1. Traditional Usage (Backward Compatible)

```dart
// Basic role-aware button
KElevatedButton(
  onPressed: () {
    // Button action
  },
  child: const Text('Submit'),
)

// With custom color (overrides role-based styling)
KElevatedButton(
  onPressed: () {},
  color: Colors.purple,
  child: const Text('Custom Button'),
)
```

### 2. Provider-Based Usage (Recommended)

```dart
// Global provider-based button
KElevatedButton(
  useProvider: true,
  onPressed: () async {
    await ref.read(kButtonProvider.notifier).executeAction(
      () async {
        // Your async operation
        await Future.delayed(const Duration(seconds: 2));
      },
      errorMessage: 'Operation failed!',
    );
  },
  child: const Text('Submit'),
)

// Button-specific provider (for multiple independent buttons)
KElevatedButton(
  useProvider: true,
  buttonId: 'submit_form',
  onPressed: () async {
    await ref.read(kButtonFamilyProvider('submit_form').notifier).executeAction(
      () async {
        // Form submission logic
      },
      errorMessage: 'Form submission failed!',
    );
  },
  child: const Text('Submit Form'),
)
```

### 3. Manual Provider Control

```dart
KElevatedButton(
  useProvider: true,
  buttonId: 'manual_control',
  onPressed: () {
    final notifier = ref.read(kButtonFamilyProvider('manual_control').notifier);
    notifier.setLoading(true);
    
    // Your async operation
    someAsyncOperation().then((_) {
      notifier.setSuccess();
    }).catchError((error) {
      notifier.setError('Operation failed: $error');
    });
  },
  child: const Text('Manual Control'),
)
```

## Constructor Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onPressed` | `VoidCallback?` | required | Callback when button is pressed |
| `child` | `Widget` | required | Button content |
| `color` | `Color?` | `null` | Custom color (overrides role-based styling) |
| `useProvider` | `bool` | `false` | Enable provider-based state management |
| `buttonId` | `String?` | `null` | Unique ID for button-specific provider |
| `role` | `UserRole?` | `null` | Explicit role override |
| `useRoleBasedStyling` | `bool` | `true` | Whether to apply role-based styling |

## Provider API

### KButtonNotifier Methods

```dart
// Loading state management
notifier.setLoading(bool loading)
notifier.setDisabled(bool disabled)

// State management
notifier.setSuccess() // Auto-resets after 2 seconds
notifier.setError(String error)
notifier.clearError()

// Configuration
notifier.setExplicitRole(UserRole role)
notifier.setRoleBasedStyling(bool enabled)

// Utility
notifier.reset() // Reset all state
notifier.executeAction(
  Future<void> Function() action,
  {String? errorMessage}
) // Execute with automatic loading/error handling
```

### Provider Types

- **`kButtonProvider`**: Global shared button state
- **`kButtonFamilyProvider`**: Button-specific state (requires unique ID)
- **`kButtonRoleProvider`**: Convenience provider for effective role
- **`kButtonLoadingProvider`**: Combined loading state (local + global)

## State Management

### Button States

- **`idle`**: Normal state, button is clickable
- **`loading`**: Shows loading indicator, button disabled
- **`disabled`**: Button disabled without loading indicator
- **`success`**: Shows success icon, auto-resets to idle after 2 seconds

### Error Handling

When using provider-based mode, errors are automatically displayed in the button with:
- Error icon
- Error message text
- Proper text overflow handling

## Role-Based Color Mapping

- **Patient**: Uses `AppTheme.colors(context).patient.primary`
- **Pharmacist**: Uses `AppTheme.colors(context).pharmacist.primary`
- **None/Default**: Uses `AppTheme.colors(context).neutral.primary`

## Best Practices

### When to Use Provider Mode

✅ **Use Provider Mode When:**
- You need complex state management
- You want automatic error handling
- You need success feedback
- Managing multiple buttons independently
- You want centralized state control

✅ **Use Traditional Mode When:**
- Simple button interactions
- No need for complex state
- Migrating existing code
- Performance-critical simple buttons

### Provider Usage Patterns

```dart
// For single, shared button state
KElevatedButton(useProvider: true, ...)

// For multiple independent buttons
KElevatedButton(useProvider: true, buttonId: 'unique_id', ...)

// Access button state programmatically
final buttonState = ref.watch(kButtonFamilyProvider('button_id'));
final notifier = ref.read(kButtonFamilyProvider('button_id').notifier);
```

## Migration Guide

### From Traditional to Provider Mode

**Before:**
```dart
KElevatedButton(
  onPressed: () async {
    setState(() => _loading = true);
    try {
      await someOperation();
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _loading = false);
    }
  },
  child: _loading ? CircularProgressIndicator() : Text('Submit'),
)
```

**After:**
```dart
KElevatedButton(
  useProvider: true,
  buttonId: 'submit',
  onPressed: () async {
    await ref.read(kButtonFamilyProvider('submit').notifier).executeAction(
      () async => await someOperation(),
      errorMessage: 'Submission failed',
    );
  },
  child: const Text('Submit'),
)
```

## Example Implementation

See `k_elevated_button_example.dart` for a complete working example demonstrating:
- Traditional vs provider-based usage
- Multiple independent buttons
- Error handling and success states
- Manual and automatic state management
- Role-based styling demonstrations
