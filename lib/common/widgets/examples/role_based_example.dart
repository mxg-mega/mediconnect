import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';

class RoleBasedExample extends ConsumerWidget {
  const RoleBasedExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(appScaffoldRoleProvider);
    final scaffoldNotifier = ref.read(appScaffoldProvider.notifier);

    return AppScaffold(
      title: Text('Role: ${currentRole.name}'),
      scaffoldActions: [
        PopupMenuButton<UserType>(
          icon: const Icon(Icons.person),
          onSelected: (UserType role) {
            scaffoldNotifier.updateRole(role);
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<UserType>(
              value: UserType.unknown,
              child: Text('Default'),
            ),
            const PopupMenuItem<UserType>(
              value: UserType.patient,
              child: Text('Patient'),
            ),
            const PopupMenuItem<UserType>(
              value: UserType.pharmacist,
              child: Text('Pharmacist'),
            ),
          ],
        ),
      ],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Role: ${currentRole.name}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            const Text('Background color changes based on role'),
            const Text('Border radius persists across all pages'),
          ],
        ),
      ),
    );
  }
}
