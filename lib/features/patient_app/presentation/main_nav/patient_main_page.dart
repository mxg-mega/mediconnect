import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class PatientMainPage extends StatelessWidget {
  final Widget child;

  const PatientMainPage({
    required this.child,
    super.key,
  });

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    if (location.contains('dashboard')) return 0;
    if (location.contains('search')) return 1;
    if (location.contains('activity')) return 2;
    if (location.contains('profile')) return 3;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final currentIndex = _calculateIndex(context);

    return AppScaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colors.patient.bg,
        unselectedItemColor: colors.neutral.secondaryText,
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
    );
  }

  BottomNavigationBarItem _navItem(
    String icon,
    String label,
    bool isSelected,
    dynamic colors,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(
          isSelected
              ? colors.patient.bg
              : colors.neutral.secondaryText,
          BlendMode.srcIn,
        ),
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
