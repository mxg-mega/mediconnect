import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';

/// Example widget showing how to use authentication with Riverpod
class AuthExampleWidget extends ConsumerWidget {
  const AuthExampleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state for reactive updates
    final authState = ref.watch(authProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Example'),
        actions: [
          if (isAuthenticated)
            IconButton(
              onPressed: () async {
                // Read the notifier to perform actions
                final authNotifier = ref.read(authProvider.notifier);
                await authNotifier.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: Column(
        children: [
          // Show current auth status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status: ${authState.status.name}'),
                  if (currentUser != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'User: ${currentUser.firstName} ${currentUser.lastName}',
                    ),
                    Text('Email: ${currentUser.email}'),
                    Text('Type: ${currentUser.userType.displayName}'),
                  ],
                  if (authState.hasError) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${authState.errorMessage}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Show different content based on auth status
          Expanded(
            child: switch (authState.status) {
              AuthStatus.authenticated => const AuthenticatedContent(),
              AuthStatus.unauthenticated => const UnauthenticatedContent(),
              AuthStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
              AuthStatus.error => const ErrorContent(),
              AuthStatus.uninitialized => const Center(
                child: CircularProgressIndicator(),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class AuthenticatedContent extends ConsumerWidget {
  const AuthenticatedContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          Text(
            'Welcome, ${currentUser?.firstName}!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'You are logged in as a ${currentUser?.userType.displayName}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class UnauthenticatedContent extends ConsumerWidget {
  const UnauthenticatedContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Not Authenticated',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // Example of signing in with dummy credentials
              final authNotifier = ref.read(authProvider.notifier);
              try {
                await authNotifier.signIn(
                  email: 'patient@example.com',
                  password: 'password123',
                );
              } catch (e) {
                // Handle error (show snackbar, etc.)
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
              }
            },
            child: const Text('Sign In (Patient)'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final authNotifier = ref.read(authProvider.notifier);
              try {
                await authNotifier.signIn(
                  email: 'pharmacist@example.com',
                  password: 'password123',
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
              }
            },
            child: const Text('Sign In (Pharmacist)'),
          ),
        ],
      ),
    );
  }
}

class ErrorContent extends ConsumerWidget {
  const ErrorContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorMessage = ref.watch(authErrorProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Authentication Error',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'Unknown error occurred',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Clear error and try again
              final authNotifier = ref.read(authProvider.notifier);
              authNotifier.clearError();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
