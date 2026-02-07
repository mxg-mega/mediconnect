import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dashboard/pharmacist_dashboard.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dashboard/pharmacist_dashboard_controller.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/inventory_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/profile_page.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/widgets/pharmacist_bottom_nav.dart';

class PharmacistMainPage extends ConsumerWidget {
  const PharmacistMainPage({super.key});

  static final List<Widget> _pages = <Widget>[
    const PharmacistDashboard(),
    const InventoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(pharmacistNavIndexProvider);

    return AppScaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: const PharmacistBottomNav(),
      removeBodyPadding: true,
      hasAppBar: false,
    );
  }
}
