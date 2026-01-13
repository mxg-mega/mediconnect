import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';
import 'package:mediconnect/core/constants/colors.dart';

class SignupFlowExample extends ConsumerWidget {
  const SignupFlowExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFlow = ref.watch(
      appScaffoldProvider.select((state) => state.currentFlow),
    );
    final previewRole = ref.watch(
      appScaffoldProvider.select((state) => state.previewRole),
    );
    final scaffoldNotifier = ref.read(appScaffoldProvider.notifier);

    return AppScaffold(
      title: Text('Sign Up - ${previewRole.name} Preview'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your role to preview the theme:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Role selection buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      scaffoldNotifier.setPreviewRole(UserRole.patient);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: previewRole == UserRole.patient
                          ? AppColors.lightTheme.patient.bg
                          : null,
                    ),
                    child: const Text('Patient'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      scaffoldNotifier.setPreviewRole(UserRole.pharmacist);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: previewRole == UserRole.pharmacist
                          ? AppColors.lightTheme.pharmacist.bg
                          : null,
                    ),
                    child: const Text('Pharmacist'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Preview section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme Preview - ${previewRole.name}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Background color changes based on your selection.\n'
                    'This helps users see how the app will look\n'
                    'before completing signup.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: scaffoldNotifier.getBackgroundColor(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Background'),
                      const SizedBox(width: 20),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: scaffoldNotifier.getScaffoldColor(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Scaffold'),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Simulate signup completion
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Simulate completing signup
                  scaffoldNotifier.updateRole(previewRole);
                  scaffoldNotifier.setFlow(AppFlow.authenticated);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Signed up as ${previewRole.name}!'),
                    ),
                  );
                },
                child: const Text('Complete Signup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Initialize signup flow when entering signup
class SignupInitializer extends ConsumerWidget {
  const SignupInitializer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldNotifier = ref.read(appScaffoldProvider.notifier);

    // Set flow to signup when this widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldNotifier.setFlow(AppFlow.signup);
    });

    return const SignupFlowExample();
  }
}
