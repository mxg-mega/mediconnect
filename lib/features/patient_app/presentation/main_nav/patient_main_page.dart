
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/patient_app/presentation/activity/activity_page.dart';
import 'package:mediconnect/features/patient_app/presentation/dashboard/dashboard_page.dart';
import 'package:mediconnect/features/patient_app/presentation/profile/profile_page.dart';
import 'package:mediconnect/features/patient_app/presentation/search/search_page.dart';

class PatientMainPage extends StatefulWidget {
  const PatientMainPage({super.key});

  @override
  State<PatientMainPage> createState() => _PatientMainPageState();
}

class _PatientMainPageState extends State<PatientMainPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return AppScaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          DashboardPage(),
          SearchPage(),
          ActivityPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colors.patient.bg,
        unselectedItemColor: colors.neutral.secondaryText,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.store, 
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? colors.patient.bg : colors.neutral.secondaryText,
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.search,
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? colors.patient.bg : colors.neutral.secondaryText,
                BlendMode.srcIn,
              ),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.history,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? colors.patient.bg : colors.neutral.secondaryText,
                BlendMode.srcIn,
              ),
            ),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.profile,
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? colors.patient.bg : colors.neutral.secondaryText,
                BlendMode.srcIn,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
