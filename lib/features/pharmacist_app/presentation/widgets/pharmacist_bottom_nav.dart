import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dashboard/pharmacist_dashboard_controller.dart';

class PharmacistBottomNav extends ConsumerWidget {
  const PharmacistBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(pharmacistNavIndexProvider);
    final theme = AppTheme.colors(context);

    final List<Map<String, dynamic>> navItems = [
      {'icon': AppIcons.store, 'label': 'Home'},
      {'icon': AppIcons.box, 'label': 'Inventory'},
      {'icon': AppIcons.profile, 'label': 'Profile'},
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
          ref.read(pharmacistNavIndexProvider.notifier).state = index;
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
