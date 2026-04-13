import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/providers/k_button_provider.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';

class KElevatedButtonExample extends ConsumerWidget {
  const KElevatedButtonExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldNotifier = ref.read(appScaffoldProvider.notifier);
    final currentRole = ref.watch(appScaffoldRoleProvider);
    final globalLoading = ref.watch(
      appScaffoldProvider.select((state) => state.isLoading),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('KElevatedButton Examples'),
        actions: [
          PopupMenuButton<UserRole>(
            icon: const Icon(Icons.person),
            onSelected: (UserRole role) {
              scaffoldNotifier.updateRole(role);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<UserRole>(
                value: UserRole.none,
                child: Text('None'),
              ),
              const PopupMenuItem<UserRole>(
                value: UserRole.patient,
                child: Text('Patient'),
              ),
              const PopupMenuItem<UserRole>(
                value: UserRole.pharmacist,
                child: Text('Pharmacist'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Current Role: ${currentRole.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Global Loading: $globalLoading',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            const Text(
              'Traditional Usage (Backward Compatible)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Basic role-aware button (traditional)
            KElevatedButton(
              onPressed: () {},
              child: const Text('Role-Aware Button'),
            ),

            const SizedBox(height: 16),

            // Button with custom color (traditional)
            KElevatedButton(
              onPressed: () {},
              backgroundColor: Colors.blue,
              child: const Text('Primary Blue Button'),
            ),

            const SizedBox(height: 24),

            const Text(
              'Provider-Based Usage',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Global provider-based button
            KElevatedButton(
              useProvider: true,
              onPressed: () async {
                await ref.read(kButtonProvider.notifier).executeAction(
                  () async {
                    await Future.delayed(const Duration(seconds: 2));
                    // Simulate success
                  },
                  errorMessage: 'Action failed!',
                );
              },
              child: const Text('Global Provider Button'),
            ),

            const SizedBox(height: 16),

            // Button-specific provider
            KElevatedButton(
              useProvider: true,
              buttonId: 'submit_form',
              onPressed: () async {
                await ref
                    .read(kButtonFamilyProvider('submit_form').notifier)
                    .executeAction(() async {
                      await Future.delayed(const Duration(seconds: 1));
                      // Simulate form submission
                    }, errorMessage: 'Form submission failed!');
              },
              child: const Text('Form Submit Button'),
            ),

            const SizedBox(height: 16),

            // Button with manual loading control
            KElevatedButton(
              useProvider: true,
              buttonId: 'manual_loading',
              onPressed: () {
                final notifier = ref.read(
                  kButtonFamilyProvider('manual_loading').notifier,
                );
                notifier.setLoading(true);
                Future.delayed(const Duration(seconds: 3), () {
                  notifier.setLoading(false);
                });
              },
              child: const Text('Manual Loading (3s)'),
            ),

            const SizedBox(height: 16),

            // Button that triggers error
            KElevatedButton(
              useProvider: true,
              buttonId: 'error_demo',
              onPressed: () async {
                await ref
                    .read(kButtonFamilyProvider('error_demo').notifier)
                    .executeAction(() async {
                      await Future.delayed(const Duration(seconds: 1));
                      throw Exception('Demo error occurred!');
                    }, errorMessage: 'This is a demo error message');
              },
              child: const Text('Trigger Error Demo'),
            ),

            const SizedBox(height: 16),

            // Button with explicit role override
            KElevatedButton(
              useProvider: true,
              buttonId: 'role_override',
              role: UserRole.patient,
              onPressed: () {},
              child: const Text('Force Patient Role'),
            ),

            const SizedBox(height: 16),

            // Button with disabled role-based styling
            KElevatedButton(
              useProvider: true,
              buttonId: 'no_role_styling',
              useRoleBasedStyling: false,
              backgroundColor: Colors.orange,
              onPressed: () {},
              child: const Text('No Role-Based Styling'),
            ),

            const SizedBox(height: 24),

            const Text(
              'Control Buttons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: KElevatedButton(
                    onPressed: () {
                      scaffoldNotifier.setLoading(true);
                      Future.delayed(const Duration(seconds: 2), () {
                        scaffoldNotifier.setLoading(false);
                      });
                    },
                    child: const Text('Global Loading (2s)'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: KElevatedButton(
                    onPressed: () {
                      ref.read(kButtonProvider.notifier).reset();
                      ref
                          .read(kButtonFamilyProvider('submit_form').notifier)
                          .reset();
                      ref
                          .read(
                            kButtonFamilyProvider('manual_loading').notifier,
                          )
                          .reset();
                      ref
                          .read(kButtonFamilyProvider('error_demo').notifier)
                          .reset();
                    },
                    child: const Text('Reset All'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
