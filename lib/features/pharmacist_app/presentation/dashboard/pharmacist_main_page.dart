import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/widgets/pharmacist_bottom_nav.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/widgets/pharmacy_status_banner.dart';

class PharmacistMainPage extends ConsumerWidget {
  final Widget child;
  const PharmacistMainPage({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      body: Column(
        children: [
          const PharmacyStatusBanner(),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: const PharmacistBottomNav(),
      removeBodyPadding: true,
      hasAppBar: false,
    );
  }
}
