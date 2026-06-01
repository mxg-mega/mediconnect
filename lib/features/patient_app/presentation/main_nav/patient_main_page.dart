import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/router/app_router.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class PatientMainPage extends ConsumerWidget {
  final Widget child;

  const PatientMainPage({required this.child, super.key});

  int _calculateIndex(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.read(goRouterProvider);
    final String location = router.routerDelegate.currentConfiguration.fullPath;

    if (location.contains('dashboard')) return 0;
    if (location.contains('search')) return 1;
    if (location.contains('activity')) return 2;
    if (location.contains('profile')) return 3;

    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppTheme.colors(context);
    final currentIndex = _calculateIndex(context, ref);

    return AppScaffold(
      removeBodyPadding: true,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/patient/dashboard');
                break;
              case 1:
                context.go('/patient/search');
                break;
              case 2:
                context.go('/patient/activity');
                break;
              case 3:
                context.go('/patient/profile');
                break;
            }
          },
          items: [
            _navItem(AppIcons.store, 'Home', currentIndex == 0, colors),
            _navItem(AppIcons.search, 'Search', currentIndex == 1, colors),
            _navItem(AppIcons.history, 'Activity', currentIndex == 2, colors),
            _navItem(AppIcons.profile, 'Profile', currentIndex == 3, colors),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
    String icon,
    String label,
    bool isSelected,
    dynamic colors,
  ) {
    return BottomNavigationBarItem(
      icon: isSelected
          ? Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.patient.bg.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(
                  colors.patient.bg,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
            )
          : SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                colors.neutral.secondaryText,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
      label: label,
    );
  }
}

// class PatientMainPage extends StatefulWidget {
//   const PatientMainPage({super.key});

//   @override
//   State<PatientMainPage> createState() => _PatientMainPageState();
// }

// class _PatientMainPageState extends State<PatientMainPage> {
//   final PageController _pageController = PageController();
//   int _currentIndex = 0;

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//     _pageController.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = AppTheme.colors(context);
//     return AppScaffold(
//       removeBodyPadding: true,
//       body: PageView(
//         controller: _pageController,
//         onPageChanged: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         children: const [
//           DashboardPage(),
//           SearchPage(),
//           ActivityPage(),
//           ProfilePage(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: colors.patient.bg,
//         unselectedItemColor: colors.neutral.secondaryText,
//         items: [
//           BottomNavigationBarItem(
//             icon: SvgPicture.asset(
//               AppIcons.store,
//               colorFilter: ColorFilter.mode(
//                 _currentIndex == 0
//                     ? colors.patient.bg
//                     : colors.neutral.secondaryText,
//                 BlendMode.srcIn,
//               ),
//             ),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: SvgPicture.asset(
//               AppIcons.search,
//               colorFilter: ColorFilter.mode(
//                 _currentIndex == 1
//                     ? colors.patient.bg
//                     : colors.neutral.secondaryText,
//                 BlendMode.srcIn,
//               ),
//             ),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: SvgPicture.asset(
//               AppIcons.history,
//               colorFilter: ColorFilter.mode(
//                 _currentIndex == 2
//                     ? colors.patient.bg
//                     : colors.neutral.secondaryText,
//                 BlendMode.srcIn,
//               ),
//             ),
//             label: 'Activity',
//           ),
//           BottomNavigationBarItem(
//             icon: SvgPicture.asset(
//               AppIcons.profile,
//               colorFilter: ColorFilter.mode(
//                 _currentIndex == 3
//                     ? colors.patient.bg
//                     : colors.neutral.secondaryText,
//                 BlendMode.srcIn,
//               ),
//             ),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
