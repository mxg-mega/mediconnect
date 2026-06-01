import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/router/app_router.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class PharmacistBottomNav extends ConsumerWidget {
  const PharmacistBottomNav({super.key});

  int _calculateIndex(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.read(goRouterProvider);
    final String location = router.routerDelegate?.currentConfiguration?.fullPath ?? '';
    if (location.contains('/pharmacist/dashboard')) return 0;
    if (location.contains('/pharmacist/inventory')) return 1;
    if (location.contains('/pharmacist/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _calculateIndex(context, ref);
    final theme = AppTheme.colors(context);

    final List<Map<String, dynamic>> navItems = [
      {'icon': AppIcons.store, 'label': 'Home', 'route': '/pharmacist/dashboard'},
      {'icon': AppIcons.box, 'label': 'Inventory', 'route': '/pharmacist/inventory'},
      {'icon': AppIcons.profile, 'label': 'Profile', 'route': '/pharmacist/profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.neutral.buttonTextWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          context.go(navItems[index]['route']);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: theme.pharmacist.bg,
        unselectedItemColor: theme.neutral.secondaryText,
        type: BottomNavigationBarType.fixed,
        items: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final isSelected = selectedIndex == index;
          return BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              decoration: isSelected
                  ? BoxDecoration(
                      color: theme.pharmacist.bg.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    )
                  : null,
              child: SvgPicture.asset(
                item['icon'],
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? theme.pharmacist.bg
                      : theme.neutral.secondaryText,
                  BlendMode.srcIn,
                ),
              ),
            ),
            label: item['label'],
          );
        }),
      ),
    );
  }
}
